import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// Base class for all events in StreamBloc.
@immutable
abstract class StreamBlocEvent extends Equatable {}

/// Event emitted when new data is available from the stream.
class StreamBlocUpdated<T> extends StreamBlocEvent {
  /// The new data snapshot.
  final T snapshot;

  StreamBlocUpdated(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

/// Event emitted when an error occurs in the stream.
class StreamBlocError extends StreamBlocEvent {
  /// The error object.
  final Object error;

  /// Optional stack trace associated with the error.
  final StackTrace? stackTrace;

  StreamBlocError(this.error, [this.stackTrace]);

  @override
  List<Object?> get props => [error, stackTrace];
}

/// Event to reset the StreamBloc to its initial state.
class StreamBlocReset extends StreamBlocEvent {
  @override
  List<Object?> get props => [];
}

/// Represents the state of a StreamBloc.
@immutable
class StreamBlocState<T> extends Equatable {
  /// The current data snapshot.
  final T? snapshot;

  /// Indicates if the bloc is currently loading data.
  final bool isLoading;

  /// Holds any error that occurred during stream processing.
  final Object? error;

  /// Creates a new instance of StreamBlocState.
  const StreamBlocState({
    this.snapshot,
    this.isLoading = false,
    this.error,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  StreamBlocState<T> copyWith({
    T? snapshot,
    bool? isLoading,
    Object? error,
  }) {
    return StreamBlocState<T>(
      snapshot: snapshot ?? this.snapshot,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [snapshot, isLoading, error];

  @override
  String toString() =>
      'StreamBlocState(snapshot: $snapshot, isLoading: $isLoading, error: $error)';
}

/// A generic Bloc for managing streaming data.
///
/// [T] is the type of data that the bloc works with.
/// [ListenEvent] is the specific type of [StreamBlocEvent] that this bloc listens to.
///
/// This bloc is designed to manage a stream of data of type [T] and update its state
/// based on events. It listens to [ListenEvent]s to start streaming data and updates
/// its state with [StreamBlocUpdated] events when new data is available.
abstract class StreamBloc<T, ListenEvent extends StreamBlocEvent>
    extends Bloc<StreamBlocEvent, StreamBlocState<T>> {
  StreamSubscription<T?>? _subscription;
  Timer? _debounceTimer;
  final Duration _debounceDuration;

  /// Creates a new instance of StreamBloc.
  ///
  /// [initialState] is the initial state of the Bloc. If not provided, it defaults to [StreamBlocState] with default values.
  /// [debounceDuration] is an optional duration to debounce rapid state updates.
  StreamBloc({
    StreamBlocState<T>? initialState,
    Duration debounceDuration = Duration.zero,
  })  : _debounceDuration = debounceDuration,
        super(initialState ?? StreamBlocState<T>()) {
    on<ListenEvent>(_onListenTo);
    on<StreamBlocUpdated<T>>(_onUpdated);
    on<StreamBlocError>(_onError);
    on<StreamBlocReset>(_onReset);
  }

  /// Abstract method to be implemented by subclasses.
  ///
  /// This method should return a [Stream] of [T?] based on the provided [ListenEvent].
  /// The stream represents the source of data this bloc works with.
  @protected
  Stream<T?> getStream(ListenEvent event);

  /// Handles the [ListenEvent] by setting up a new stream subscription.
  @protected
  Future<void> _onListenTo(
      ListenEvent event, Emitter<StreamBlocState<T>> emit) async {
    await _subscription?.cancel();
    emit(state.copyWith(isLoading: true, error: null));
    _subscription = getStream(event).listen(
      (result) {
        if (result != null) {
          add(StreamBlocUpdated<T>(result));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        add(StreamBlocError(error, stackTrace));
      },
    );
  }

  /// Handles [StreamBlocUpdated] events by updating the state with new data.
  @protected
  Future<void> _onUpdated(
      StreamBlocUpdated<T> event, Emitter<StreamBlocState<T>> emit) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      if (state.snapshot != event.snapshot) {
        emit(state.copyWith(
            snapshot: event.snapshot, isLoading: false, error: null));
      }
    });
  }

  /// Handles [StreamBlocError] events by updating the state with the error.
  @protected
  Future<void> _onError(
      StreamBlocError event, Emitter<StreamBlocState<T>> emit) async {
    emit(state.copyWith(error: event.error, isLoading: false));
  }

  /// Handles [StreamBlocReset] events by resetting the bloc to its initial state.
  @protected
  Future<void> _onReset(
      StreamBlocReset event, Emitter<StreamBlocState<T>> emit) async {
    await _subscription?.cancel();
    _debounceTimer?.cancel();
    emit(StreamBlocState<T>());
  }

  /// Closes the StreamBloc and cleans up resources.
  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _debounceTimer?.cancel();
    return super.close();
  }
}
