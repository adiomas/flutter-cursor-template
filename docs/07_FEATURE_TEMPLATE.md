# Feature Template ⭐

**PRIMARY DOCUMENT** - Your daily reference for implementing new features from zero to complete.

## Overview

This template provides a step-by-step guide to implement any CRUD feature in ~30 minutes. Follow this for consistent, high-quality code.

**What you'll build:**
- Data layer (Model, Repository)
- Domain layer (Entity, Notifier)
- Presentation layer (Pages, Widgets)
- Full CRUD operations (Create, Read, Update, Delete)
- Error handling
- Loading states
- User-friendly UI

## Prerequisites Checklist

Before starting:
- [ ] Project initialized with clean architecture
- [ ] Base dependencies installed (riverpod, either_dart, q_architecture)
- [ ] Supabase/Backend configured
- [ ] Database table created
- [ ] Design system in place

## Example Feature: Task Management

We'll implement a complete task management feature with:
- Task list view
- Task details view
- Create/Edit task
- Delete task
- Mark task complete

### Database Schema

```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT FALSE,
  priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
  due_date TIMESTAMPTZ,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Step 1: Create Feature Folder Structure

```bash
mkdir -p lib/features/tasks/{data/{models,repositories},domain/{entities,notifiers},presentation/{pages,widgets}}
```

**Result:**
```
lib/features/tasks/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── notifiers/
└── presentation/
    ├── pages/
    └── widgets/
```

## Step 2: Data Layer - Model

**File:** `lib/features/tasks/data/models/task_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.priority,
    this.dueDate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
  
  // Convert to domain entity
  TaskEntity toDomain() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      completed: completed,
      priority: TaskPriority.fromString(priority),
      dueDate: dueDate,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  // Create from domain entity (for updates)
  factory TaskModel.fromDomain(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      completed: entity.completed,
      priority: entity.priority.value,
      dueDate: entity.dueDate,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

**Generate code:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Step 3: Domain Layer - Entity

**File:** `lib/features/tasks/domain/entities/task_entity.dart`

```dart
import 'package:equatable/equatable.dart';

enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high');
  
  final String value;
  const TaskPriority(this.value);
  
  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (p) => p.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.priority,
    this.dueDate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Business logic methods
  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }
  
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year &&
           now.month == due.month &&
           now.day == due.day;
  }
  
  bool get isDueSoon {
    if (dueDate == null || completed) return false;
    final now = DateTime.now();
    final diff = dueDate!.difference(now);
    return diff.inDays >= 0 && diff.inDays <= 3;
  }
  
  // For empty/new task
  factory TaskEntity.empty(String userId) {
    return TaskEntity(
      id: '',
      title: '',
      description: null,
      completed: false,
      priority: TaskPriority.medium,
      dueDate: null,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Immutable copy
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    TaskPriority? priority,
    DateTime? dueDate,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        completed,
        priority,
        dueDate,
        userId,
        createdAt,
        updatedAt,
      ];
}
```

## Step 4: Data Layer - Repository

**File:** `lib/features/tasks/data/repositories/task_repository.dart`

```dart
import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../../../common/data/supabase_service.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(
    ref.watch(supabaseServiceProvider),
  ),
);

abstract interface class TaskRepository {
  EitherFailureOr<List<TaskEntity>> getTasks(String userId);
  EitherFailureOr<TaskEntity> getTask(String id);
  EitherFailureOr<TaskEntity> createTask(TaskEntity task);
  EitherFailureOr<TaskEntity> updateTask(TaskEntity task);
  EitherFailureOr<void> deleteTask(String id);
}

class TaskRepositoryImpl implements TaskRepository {
  final SupabaseService _supabase;
  
  TaskRepositoryImpl(this._supabase);
  
  @override
  EitherFailureOr<List<TaskEntity>> getTasks(String userId) async {
    try {
      final response = await _supabase.client
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json).toDomain())
          .toList();
      
      return Right(tasks);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<TaskEntity> getTask(String id) async {
    try {
      final response = await _supabase.client
          .from('tasks')
          .select()
          .eq('id', id)
          .single();
      
      final task = TaskModel.fromJson(response).toDomain();
      return Right(task);
    } catch (e) {
      return Left(Failure.notFound(resource: 'Task'));
    }
  }
  
  @override
  EitherFailureOr<TaskEntity> createTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromDomain(task);
      final response = await _supabase.client
          .from('tasks')
          .insert(model.toJson())
          .select()
          .single();
      
      final createdTask = TaskModel.fromJson(response).toDomain();
      return Right(createdTask);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<TaskEntity> updateTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromDomain(task);
      final response = await _supabase.client
          .from('tasks')
          .update(model.toJson())
          .eq('id', task.id)
          .select()
          .single();
      
      final updatedTask = TaskModel.fromJson(response).toDomain();
      return Right(updatedTask);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<void> deleteTask(String id) async {
    try {
      await _supabase.client
          .from('tasks')
          .delete()
          .eq('id', id);
      
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

## Step 5: Domain Layer - List Notifier

**File:** `lib/features/tasks/domain/notifiers/tasks_list_notifier.dart`

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../data/repositories/task_repository.dart';
import '../entities/task_entity.dart';

final tasksListNotifierProvider =
    NotifierProvider<TasksListNotifier, BaseState<List<TaskEntity>>>(
  () => TasksListNotifier(),
);

class TasksListNotifier extends BaseNotifier<List<TaskEntity>> {
  late TaskRepository _repository;
  late String _currentUserId;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(taskRepositoryProvider);
    _currentUserId = ref.watch(currentUserProvider)?.id ?? '';
  }
  
  Future<void> loadTasks() async {
    state = const BaseLoading();
    final result = await _repository.getTasks(_currentUserId);
    state = result.fold(
      BaseError.new,
      (tasks) {
        // Sort: incomplete first, then by due date
        tasks.sort((a, b) {
          if (a.completed != b.completed) {
            return a.completed ? 1 : -1;
          }
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        return BaseData(tasks);
      },
    );
  }
  
  Future<void> toggleTaskComplete(String taskId) async {
    final currentTasks = state.dataOrNull;
    if (currentTasks == null) return;
    
    // Find task
    final taskIndex = currentTasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;
    
    final task = currentTasks[taskIndex];
    final updatedTask = task.copyWith(completed: !task.completed);
    
    // Optimistic update
    final optimisticTasks = List<TaskEntity>.from(currentTasks);
    optimisticTasks[taskIndex] = updatedTask;
    state = BaseData(optimisticTasks);
    
    // Update in backend
    final result = await _repository.updateTask(updatedTask);
    
    result.fold(
      (failure) {
        // Revert on failure
        state = BaseData(currentTasks);
        ref.read(snackbarProvider).showError(failure.userMessage);
      },
      (_) {
        // Success - reload to get sorted list
        loadTasks();
      },
    );
  }
  
  Future<void> deleteTask(String taskId) async {
    state = const BaseLoading();
    final result = await _repository.deleteTask(taskId);
    
    result.fold(
      (failure) {
        state = BaseError(failure);
        ref.read(snackbarProvider).showError(failure.userMessage);
      },
      (_) {
        ref.read(snackbarProvider).showSuccess('Task deleted');
        loadTasks();
      },
    );
  }
  
  void filterByPriority(TaskPriority? priority) {
    final currentTasks = state.dataOrNull;
    if (currentTasks == null) return;
    
    if (priority == null) {
      loadTasks();
      return;
    }
    
    final filtered = currentTasks
        .where((task) => task.priority == priority)
        .toList();
    
    state = BaseData(filtered);
  }
  
  void filterByCompleted(bool? completed) {
    final currentTasks = state.dataOrNull;
    if (currentTasks == null) return;
    
    if (completed == null) {
      loadTasks();
      return;
    }
    
    final filtered = currentTasks
        .where((task) => task.completed == completed)
        .toList();
    
    state = BaseData(filtered);
  }
}
```

## Step 6: Domain Layer - Single Task Notifier

**File:** `lib/features/tasks/domain/notifiers/task_notifier.dart`

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../data/repositories/task_repository.dart';
import '../entities/task_entity.dart';

final taskNotifierProvider =
    NotifierProvider<TaskNotifier, BaseState<TaskEntity>>(
  () => TaskNotifier(),
);

class TaskNotifier extends BaseNotifier<TaskEntity> {
  late TaskRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(taskRepositoryProvider);
  }
  
  void initializeNew(String userId) {
    state = BaseData(TaskEntity.empty(userId));
  }
  
  Future<void> loadTask(String id) async {
    state = const BaseLoading();
    final result = await _repository.getTask(id);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  void updateTitle(String title) {
    final task = state.dataOrNull;
    if (task == null) return;
    
    state = BaseData(task.copyWith(title: title));
  }
  
  void updateDescription(String description) {
    final task = state.dataOrNull;
    if (task == null) return;
    
    state = BaseData(task.copyWith(description: description));
  }
  
  void updatePriority(TaskPriority priority) {
    final task = state.dataOrNull;
    if (task == null) return;
    
    state = BaseData(task.copyWith(priority: priority));
  }
  
  void updateDueDate(DateTime? dueDate) {
    final task = state.dataOrNull;
    if (task == null) return;
    
    state = BaseData(task.copyWith(dueDate: dueDate));
  }
  
  Future<bool> saveTask() async {
    final task = state.dataOrNull;
    if (task == null) return false;
    
    // Validation
    if (task.title.trim().isEmpty) {
      ref.read(snackbarProvider).showError('Title is required');
      return false;
    }
    
    state = const BaseLoading();
    
    final result = task.id.isEmpty
        ? await _repository.createTask(task)
        : await _repository.updateTask(task);
    
    return result.fold(
      (failure) {
        state = BaseError(failure);
        ref.read(snackbarProvider).showError(failure.userMessage);
        return false;
      },
      (savedTask) {
        state = BaseData(savedTask);
        ref.read(snackbarProvider).showSuccess(
          task.id.isEmpty ? 'Task created' : 'Task updated',
        );
        
        // Refresh list
        ref.invalidate(tasksListNotifierProvider);
        return true;
      },
    );
  }
}
```

## Step 7: Presentation - List Page

**File:** `lib/features/tasks/presentation/pages/tasks_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../common/presentation/build_context_extensions.dart';
import '../../../../common/presentation/spacing.dart';
import '../../domain/notifiers/tasks_list_notifier.dart';
import '../widgets/task_list_item.dart';
import '../widgets/loading_shimmer.dart';
import 'task_details_page.dart';

class TasksPage extends HookConsumerWidget {
  static const routeName = '/tasks';
  
  const TasksPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksListNotifierProvider);
    
    useEffect(
      () {
        Future.microtask(() {
          ref.read(tasksListNotifierProvider.notifier).loadTasks();
        });
        return null;
      },
      const [],
    );
    
    Future<void> onRefresh() async {
      await ref.read(tasksListNotifierProvider.notifier).loadTasks();
    }
    
    return Scaffold(
      backgroundColor: context.appColors.contentBackground,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, ref);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: switch (tasksState) {
          BaseLoading() => const TasksLoadingShimmer(),
          BaseData(:final data) => data.isEmpty
              ? const EmptyTasksView()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => spacing12,
                  itemBuilder: (context, index) {
                    return TaskListItem(
                      task: data[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TaskDetailsPage.routeName,
                          arguments: data[index].id,
                        );
                      },
                      onToggle: () {
                        ref
                            .read(tasksListNotifierProvider.notifier)
                            .toggleTaskComplete(data[index].id);
                      },
                    );
                  },
                ),
          BaseError(:final failure) => ErrorView(
              failure: failure,
              onRetry: onRefresh,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, TaskDetailsPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TaskFilterBottomSheet(),
    );
  }
}

class EmptyTasksView extends StatelessWidget {
  const EmptyTasksView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: context.appColors.greyText,
          ),
          spacing16,
          Text(
            'No tasks yet',
            style: context.textStyles.headline2,
          ),
          spacing8,
          Text(
            'Tap + to create your first task',
            style: context.textStyles.greyBodyText1,
          ),
        ],
      ),
    );
  }
}
```

## Step 8: Presentation - List Item Widget

**File:** `lib/features/tasks/presentation/widgets/task_list_item.dart`

```dart
import 'package:flutter/material.dart';
import '../../../../common/presentation/build_context_extensions.dart';
import '../../../../common/presentation/spacing.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  
  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.appColors.border,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.completed,
                onChanged: (_) => onToggle(),
              ),
              spacingH12,
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: context.textStyles.bodyText1.copyWith(
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    
                    if (task.description != null) ...[
                      spacing4,
                      Text(
                        task.description!,
                        style: context.textStyles.greyBodyText2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    if (task.dueDate != null) ...[
                      spacing8,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: _getDueDateColor(context),
                          ),
                          spacingH4,
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: context.textStyles.caption.copyWith(
                              color: _getDueDateColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Priority indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPriorityColor(BuildContext context) {
    return switch (task.priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.orange,
      TaskPriority.low => Colors.green,
    };
  }
  
  Color _getDueDateColor(BuildContext context) {
    if (task.completed) return context.appColors.greyText;
    if (task.isOverdue) return Colors.red;
    if (task.isDueToday) return Colors.orange;
    if (task.isDueSoon) return Colors.blue;
    return context.appColors.greyText;
  }
  
  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays == -1) return 'Yesterday';
    if (diff.inDays < 0) return '${-diff.inDays} days overdue';
    if (diff.inDays < 7) return 'In ${diff.inDays} days';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

## Step 9: Presentation - Details/Edit Page

**File:** `lib/features/tasks/presentation/pages/task_details_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../common/presentation/build_context_extensions.dart';
import '../../../../common/presentation/spacing.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/notifiers/task_notifier.dart';

class TaskDetailsPage extends HookConsumerWidget {
  static const routeName = '/tasks/:id';
  final String? taskId;
  
  const TaskDetailsPage({
    super.key,
    this.taskId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    
    final isNewTask = taskId == null;
    
    useEffect(
      () {
        final userId = ref.read(currentUserProvider)?.id ?? '';
        
        Future.microtask(() {
          if (isNewTask) {
            ref.read(taskNotifierProvider.notifier).initializeNew(userId);
          } else {
            ref.read(taskNotifierProvider.notifier).loadTask(taskId!);
          }
        });
        return null;
      },
      [taskId],
    );
    
    // Update controllers when task loads
    useEffect(
      () {
        final task = taskState.dataOrNull;
        if (task != null) {
          titleController.text = task.title;
          descriptionController.text = task.description ?? '';
        }
        return null;
      },
      [taskState],
    );
    
    Future<void> handleSave() async {
      final success = await ref.read(taskNotifierProvider.notifier).saveTask();
      if (success && context.mounted) {
        Navigator.pop(context);
      }
    }
    
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        title: Text(isNewTask ? 'New Task' : 'Edit Task'),
        actions: [
          if (!isNewTask)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteDialog(context, ref);
              },
            ),
        ],
      ),
      body: switch (taskState) {
        BaseLoading() => const Center(child: CircularProgressIndicator()),
        BaseData(:final data) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(taskNotifierProvider.notifier).updateTitle(value);
                  },
                ),
                spacing16,
                
                // Description
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    ref
                        .read(taskNotifierProvider.notifier)
                        .updateDescription(value);
                  },
                ),
                spacing16,
                
                // Priority
                DropdownButtonFormField<TaskPriority>(
                  value: data.priority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.value.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(taskNotifierProvider.notifier)
                          .updatePriority(value);
                    }
                  },
                ),
                spacing16,
                
                // Due Date
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.appColors.border),
                  ),
                  title: const Text('Due Date'),
                  subtitle: data.dueDate != null
                      ? Text('${data.dueDate!.day}/${data.dueDate!.month}/${data.dueDate!.year}')
                      : const Text('No due date'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: data.dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      ref
                          .read(taskNotifierProvider.notifier)
                          .updateDueDate(date);
                    }
                  },
                ),
                spacing24,
                
                // Save Button
                ElevatedButton(
                  onPressed: handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isNewTask ? 'Create Task' : 'Save Changes'),
                ),
              ],
            ),
          ),
        BaseError(:final failure) => ErrorView(
            failure: failure,
            onRetry: () {
              if (isNewTask) {
                final userId = ref.read(currentUserProvider)?.id ?? '';
                ref.read(taskNotifierProvider.notifier).initializeNew(userId);
              } else {
                ref.read(taskNotifierProvider.notifier).loadTask(taskId!);
              }
            },
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
  
  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(tasksListNotifierProvider.notifier)
                  .deleteTask(taskId!);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Step 10: Add Routes

**File:** `lib/common/domain/router/routes.dart` (add to existing):

```dart
GoRoute(
  path: TasksPage.routeName,
  builder: (context, state) => const TasksPage(),
),
GoRoute(
  path: TaskDetailsPage.routeName,
  builder: (context, state) {
    final taskId = state.pathParameters['id'];
    return TaskDetailsPage(taskId: taskId);
  },
),
```

## Completion Checklist

After implementing feature:

- [ ] All files created in correct folder structure
- [ ] Code generated (`build_runner`)
- [ ] Repository tests written
- [ ] Notifier tests written
- [ ] Widget tests for key components
- [ ] Error handling implemented
- [ ] Loading states implemented
- [ ] Navigation working
- [ ] Snackbar notifications showing
- [ ] No linter warnings
- [ ] Feature documented

## Time Estimate

- **Data Layer:** 5 minutes
- **Domain Layer:** 10 minutes
- **Presentation Layer:** 15 minutes
- **Testing & Polish:** 10 minutes

**Total:** ~40 minutes for complete CRUD feature

## Common Mistakes to Avoid

1. **Forgetting to run build_runner** after creating models
2. **Not handling null in state.dataOrNull**
3. **Skipping error handling in UI**
4. **Forgetting to invalidate list after create/update/delete**
5. **Not adding routes to router**
6. **Missing loading states**
7. **Hardcoded strings instead of localization**

## 🌍 Internationalization (i18n) Implementation

### CRITICAL: No Hardcoded Strings!

**Before implementing UI**, add ALL strings to ARB files.

### Step-by-Step i18n Integration

#### 1. Check if i18n is Configured

```bash
# Check for these files:
# - l10n.yaml (project root)
# - lib/l10n/arb/app_en.arb
# - lib/common/presentation/extensions/localization_extension.dart
```

If not configured, copy setup from `docs/templates/l10n_setup/`.

#### 2. Add Feature Strings to ARB

**Edit `lib/l10n/arb/app_en.arb`:**

```json
{
  "@@locale": "en",
  
  "@@_TASKS_FEATURE": "═══════════════════════════════════════",
  "tasksTitle": "Tasks",
  "@tasksTitle": {
    "description": "Tasks page title"
  },
  
  "tasksEmpty": "No tasks yet",
  "tasksEmptyMessage": "Tap + to create your first task",
  
  "taskDetailsTitle": "Task Details",
  "taskEditTitle": "Edit Task",
  "taskCreateTitle": "New Task",
  
  "taskFieldTitle": "Title",
  "taskFieldDescription": "Description",
  "taskFieldPriority": "Priority",
  "taskFieldDueDate": "Due Date",
  
  "taskPriorityLow": "Low",
  "taskPriorityMedium": "Medium",
  "taskPriorityHigh": "High",
  
  "taskStatusPending": "Pending",
  "taskStatusCompleted": "Completed",
  
  "taskDeleteConfirm": "Delete this task?",
  "taskDeleteSuccess": "Task deleted",
  "taskSaveSuccess": "Task saved",
  "taskCreateSuccess": "Task created",
  
  "taskValidationTitleRequired": "Title is required",
  "taskValidationTitleTooShort": "Title must be at least 3 characters",
  
  "taskDueToday": "Due today",
  "taskDueTomorrow": "Due tomorrow",
  "taskOverdue": "Overdue",
  "taskDueInDays": "Due in {days} days",
  "@taskDueInDays": {
    "placeholders": {
      "days": {
        "type": "int"
      }
    }
  }
}
```

#### 3. Generate Localization Code

```bash
flutter gen-l10n
```

This generates `lib/l10n/generated/app_localizations.dart`.

#### 4. Use in UI Code

**Import localization extension:**

```dart
import '../../../../common/presentation/extensions/localization_extension.dart';
```

**Page Title:**

```dart
// ❌ NEVER
AppBar(
  title: const Text('Tasks'),
)

// ✅ ALWAYS
AppBar(
  title: Text(context.l10n.tasksTitle),
)
```

**Empty State:**

```dart
// ❌ NEVER
Column(
  children: [
    Text('No tasks yet'),
    Text('Tap + to create your first task'),
  ],
)

// ✅ ALWAYS
Column(
  children: [
    Text(context.l10n.tasksEmpty),
    Text(context.l10n.tasksEmptyMessage),
  ],
)
```

**Buttons:**

```dart
// ❌ NEVER
ElevatedButton(
  child: const Text('Save'),
  onPressed: () {},
)

// ✅ ALWAYS
ElevatedButton(
  child: Text(context.l10n.save),  // Using common key
  onPressed: () {},
)
```

**Form Fields:**

```dart
// ❌ NEVER
TextField(
  decoration: InputDecoration(
    labelText: 'Title',
    hintText: 'Enter task title',
  ),
)

// ✅ ALWAYS
TextField(
  decoration: InputDecoration(
    labelText: context.l10n.taskFieldTitle,
    hintText: context.l10n.placeholderEnterText,
  ),
)
```

**Validation Messages:**

```dart
// ❌ NEVER
if (title.isEmpty) {
  return 'Title is required';
}

// ✅ ALWAYS
if (title.isEmpty) {
  return context.l10n.taskValidationTitleRequired;
}
```

**Snackbars:**

```dart
// ❌ NEVER
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Task deleted')),
);

// ✅ ALWAYS
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(context.l10n.taskDeleteSuccess)),
);
```

**Dialog:**

```dart
// ❌ NEVER
AlertDialog(
  title: const Text('Delete Task'),
  content: const Text('Are you sure?'),
  actions: [
    TextButton(
      child: const Text('Cancel'),
      onPressed: () => Navigator.pop(context),
    ),
    TextButton(
      child: const Text('Delete'),
      onPressed: () {},
    ),
  ],
)

// ✅ ALWAYS
AlertDialog(
  title: Text(context.l10n.taskDeleteConfirm),
  actions: [
    TextButton(
      child: Text(context.l10n.cancel),
      onPressed: () => Navigator.pop(context),
    ),
    TextButton(
      child: Text(context.l10n.delete),
      onPressed: () {},
    ),
  ],
)
```

**Dropdown/Enum Values:**

```dart
// ❌ NEVER
DropdownButton<Priority>(
  items: [
    DropdownMenuItem(value: Priority.low, child: Text('Low')),
    DropdownMenuItem(value: Priority.medium, child: Text('Medium')),
    DropdownMenuItem(value: Priority.high, child: Text('High')),
  ],
)

// ✅ ALWAYS
DropdownButton<Priority>(
  items: [
    DropdownMenuItem(value: Priority.low, child: Text(context.l10n.taskPriorityLow)),
    DropdownMenuItem(value: Priority.medium, child: Text(context.l10n.taskPriorityMedium)),
    DropdownMenuItem(value: Priority.high, child: Text(context.l10n.taskPriorityHigh)),
  ],
)
```

**Conditional Text (Status):**

```dart
// ❌ NEVER
Text(task.completed ? 'Completed' : 'Pending')

// ✅ ALWAYS
Text(task.completed ? context.l10n.taskStatusCompleted : context.l10n.taskStatusPending)
```

**Date Formatting:**

```dart
// ❌ NEVER
Text('Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}')

// ✅ ALWAYS
Text(context.l10n.formattedDate(task.dueDate))
```

**Relative Dates:**

```dart
// ❌ NEVER
final diff = task.dueDate.difference(DateTime.now()).inDays;
Text(diff == 0 ? 'Today' : diff == 1 ? 'Tomorrow' : '$diff days')

// ✅ ALWAYS
final diff = task.dueDate.difference(DateTime.now()).inDays;
if (diff == 0) {
  return Text(context.l10n.taskDueToday);
} else if (diff == 1) {
  return Text(context.l10n.taskDueTomorrow);
} else {
  return Text(context.l10n.taskDueInDays(diff));
}
```

#### 5. Add Translations to Other Languages

**Edit `lib/l10n/arb/app_hr.arb`** (Croatian):

```json
{
  "@@locale": "hr",
  
  "tasksTitle": "Zadaci",
  "tasksEmpty": "Nema zadataka",
  "tasksEmptyMessage": "Dodirni + za novi zadatak",
  
  "taskDetailsTitle": "Detalji zadatka",
  "taskEditTitle": "Uredi zadatak",
  "taskCreateTitle": "Novi zadatak",
  
  "taskFieldTitle": "Naslov",
  "taskFieldDescription": "Opis",
  "taskFieldPriority": "Prioritet",
  "taskFieldDueDate": "Rok",
  
  "taskPriorityLow": "Nizak",
  "taskPriorityMedium": "Srednji",
  "taskPriorityHigh": "Visok",
  
  "taskStatusPending": "Na čekanju",
  "taskStatusCompleted": "Završeno",
  
  "taskDeleteConfirm": "Obrisati ovaj zadatak?",
  "taskDeleteSuccess": "Zadatak obrisan",
  "taskSaveSuccess": "Zadatak spremljen",
  "taskCreateSuccess": "Zadatak stvoren",
  
  "taskValidationTitleRequired": "Naslov je obavezan",
  "taskValidationTitleTooShort": "Naslov mora imati najmanje 3 znaka",
  
  "taskDueToday": "Rok danas",
  "taskDueTomorrow": "Rok sutra",
  "taskOverdue": "Prekoračen rok",
  "taskDueInDays": "Rok za {days} dana"
}
```

Then run `flutter gen-l10n` again.

#### 6. Testing i18n

**Test in each language:**

```dart
// Change language in app
ref.read(localeProvider.notifier).setCroatian();

// Or test in widget test
testWidgets('Task page shows Croatian', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('hr'),
      home: const TasksPage(),
    ),
  );
  
  expect(find.text('Zadaci'), findsOneWidget);
});
```

### i18n Checklist for Feature

- [ ] All UI strings added to `app_en.arb`
- [ ] Descriptions added for each string
- [ ] `flutter gen-l10n` ran successfully
- [ ] `localization_extension.dart` imported
- [ ] ALL Text widgets use `context.l10n.*`
- [ ] ALL buttons use `context.l10n.*`
- [ ] ALL form labels use `context.l10n.*`
- [ ] ALL error messages use `context.l10n.*`
- [ ] ALL snackbars use `context.l10n.*`
- [ ] ALL dialogs use `context.l10n.*`
- [ ] Enum values localized
- [ ] Status text localized
- [ ] Date formatting uses l10n
- [ ] Translations added to other languages
- [ ] `flutter gen-l10n` ran for translations
- [ ] Tested in all supported languages
- [ ] No `Text('hardcoded')` found in grep

### Quick Verification

```bash
# Check for hardcoded strings (rough check)
grep -r "Text('" lib/features/tasks/ | grep -v ".l10n"

# Should return ZERO results!
```

### Resources

- Full i18n guide: `docs/17_INTERNATIONALIZATION.md`
- Setup templates: `docs/templates/l10n_setup/`
- Complete checklist: `docs/checklists/i18n_checklist.md`

---

## Next Steps

- **Navigation:** Deep dive in [08_NAVIGATION_SYSTEM.md](08_NAVIGATION_SYSTEM.md)
- **Data Layer:** Advanced patterns in [09_DATA_LAYER.md](09_DATA_LAYER.md)
- **UI Components:** Reusable widgets in [10_UI_COMPONENT_LIBRARY.md](10_UI_COMPONENT_LIBRARY.md)
- **Testing:** Test this feature in [14_TESTING_STRATEGY.md](14_TESTING_STRATEGY.md)

---

**Congratulations! You've mastered the feature template. Use this for every new feature!** ⭐

