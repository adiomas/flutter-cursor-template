import 'package:q_architecture/q_architecture.dart';

// Simple sealed class for state management
sealed class BaseState<T> {
  const BaseState();

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T value) data,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      BaseInitial() => initial(),
      BaseLoading() => loading(),
      BaseData(:final value) => data(value),
      BaseError(:final failure) => error(failure),
    };
  }

  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? data,
    R Function(Failure failure)? error,
    required R Function() orElse,
  }) {
    return switch (this) {
      BaseInitial() => initial?.call() ?? orElse(),
      BaseLoading() => loading?.call() ?? orElse(),
      BaseData(:final value) => data?.call(value) ?? orElse(),
      BaseError(:final failure) => error?.call(failure) ?? orElse(),
    };
  }
}

class BaseInitial<T> extends BaseState<T> {
  const BaseInitial();
}

class BaseLoading<T> extends BaseState<T> {
  const BaseLoading();
}

class BaseData<T> extends BaseState<T> {
  final T value;
  const BaseData(this.value);

  T get data => value;
}

class BaseError<T> extends BaseState<T> {
  final Failure failure;
  const BaseError(this.failure);
}
