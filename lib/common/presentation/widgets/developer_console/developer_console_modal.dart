import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/app_environment.dart';
import '../../../utils/logger/app_logger.dart';
import '../../../utils/logger/log_entry.dart';

/// Developer console modal with logs viewer
class DeveloperConsoleModal extends HookConsumerWidget {
  const DeveloperConsoleModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<String?>('ALL');
    final searchQuery = useState<String>('');
    final logs = useState<List<LogEntry>>([]);
    final isLoading = useState<bool>(true);

    // Load logs on mount
    useEffect(
      () {
        Future.microtask(() async {
          final allLogs = await AppLogger.instance.getLogs();
          logs.value = allLogs;
          isLoading.value = false;
        });
        return null;
      },
      const [],
    );

    // Listen to real-time log updates
    useEffect(
      () {
        final subscription = AppLogger.instance.logStream.listen((entry) {
          logs.value = [entry, ...logs.value];
        });
        return subscription.cancel;
      },
      const [],
    );

    // Filter logs
    final filteredLogs = useMemoized(
      () {
        var result = logs.value;

        // Filter by level
        if (selectedFilter.value != null && selectedFilter.value != 'ALL') {
          result =
              result.where((log) => log.level == selectedFilter.value).toList();
        }

        // Filter by search query
        if (searchQuery.value.isNotEmpty) {
          final query = searchQuery.value.toLowerCase();
          result = result.where((log) {
            return log.message.toLowerCase().contains(query) ||
                (log.error?.toLowerCase().contains(query) ?? false);
          }).toList();
        }

        return result;
      },
      [logs.value, selectedFilter.value, searchQuery.value],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context, logs, searchQuery),

          // Filters
          _buildFilters(context, selectedFilter, logs),

          // Search
          _buildSearch(context, searchQuery),

          // Logs list
          Expanded(
            child: isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : filteredLogs.isEmpty
                    ? _buildEmptyState(context)
                    : _buildLogsList(context, filteredLogs),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ValueNotifier<List<LogEntry>> logs,
    ValueNotifier<String> searchQuery,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bug_report,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Developer Console',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${EnvInfo.environment.name.toUpperCase()} • ${logs.value.length} logs',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await _exportLogs(context);
                },
                icon: const Icon(Icons.share, color: Colors.white),
                tooltip: 'Export Logs',
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await _showClearConfirmation(context);
                  if (confirmed == true) {
                    await AppLogger.instance.clearLogs();
                    logs.value = [];
                    searchQuery.value = '';
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logs cleared'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Clear Logs',
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    ValueNotifier<String?> selectedFilter,
    ValueNotifier<List<LogEntry>> logs,
  ) {
    final filters = [
      'ALL',
      'TRACE',
      'DEBUG',
      'INFO',
      'WARNING',
      'ERROR',
      'FATAL'
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter.value == filter;
          final count = filter == 'ALL'
              ? logs.value.length
              : logs.value.where((log) => log.level == filter).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                '$filter ($count)',
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                selectedFilter.value = selected ? filter : 'ALL';
              },
              backgroundColor: const Color(0xFF2D2D2D),
              selectedColor: Colors.green,
              side: BorderSide(
                color:
                    isSelected ? Colors.green : Colors.white.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearch(
    BuildContext context,
    ValueNotifier<String> searchQuery,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => searchQuery.value = value,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search logs...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
          suffixIcon: searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () => searchQuery.value = '',
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLogsList(BuildContext context, List<LogEntry> logs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _LogEntryCard(log: log);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No logs found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportLogs(BuildContext context) async {
    try {
      final file = await AppLogger.instance.exportLogs();
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'GlowAI Logs Export',
      );
      if (result.status == ShareResultStatus.success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logs exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export logs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool?> _showClearConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Clear All Logs?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _LogEntryCard extends StatelessWidget {
  final LogEntry log;

  const _LogEntryCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(log.level);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF2D2D2D),
      child: InkWell(
        onTap: () => _showLogDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    log.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color),
                    ),
                    child: Text(
                      log.level,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(log.timestamp),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Message
              Text(
                log.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Error if present
              if (log.error != null) ...[
                const SizedBox(height: 4),
                Text(
                  log.error!,
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Row(
          children: [
            Text(
              log.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Text(
              log.level,
              style: TextStyle(
                color: _getLevelColor(log.level),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(
                label: 'Time',
                value: log.timestamp.toString(),
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Message',
                value: log.message,
              ),
              if (log.error != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Error',
                  value: log.error!,
                  isError: true,
                ),
              ],
              if (log.stackTrace != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Stack Trace',
                  value: log.stackTrace!,
                  isMonospace: true,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: _formatLogForCopy(log),
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Log copied to clipboard'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    return switch (level) {
      'TRACE' => Colors.grey,
      'DEBUG' => Colors.blue,
      'INFO' => Colors.green,
      'WARNING' => Colors.orange,
      'ERROR' => Colors.red,
      'FATAL' => Colors.red[900]!,
      _ => Colors.white,
    };
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatLogForCopy(LogEntry log) {
    final buffer = StringBuffer();
    buffer.writeln('[${log.timestamp}] [${log.level}]');
    buffer.writeln(log.message);
    if (log.error != null) {
      buffer.writeln('\nError: ${log.error}');
    }
    if (log.stackTrace != null) {
      buffer.writeln('\nStack Trace:\n${log.stackTrace}');
    }
    return buffer.toString();
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isError;
  final bool isMonospace;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isError = false,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isError
                ? Colors.red.withOpacity(0.1)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isError
                  ? Colors.red.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isError ? Colors.red[300] : Colors.white,
              fontSize: 12,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
