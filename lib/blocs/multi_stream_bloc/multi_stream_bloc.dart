import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// Base class for all events in MultiStreamBloc.
@immutable
abstract class MultiStreamBlocEvent {}

/// Internal event emitted when new data is available from a stream.
class _MultiStreamBlocUpdated<T> extends MultiStreamBlocEvent {
  /// The ID of the stream that emitted new data.
  final int streamId;

  /// The new data snapshot.
  final T snapshot;

  _MultiStreamBlocUpdated(this.streamId, this.snapshot);
}

/// Event emitted when an error occurs in a stream.
class MultiStreamBlocError extends MultiStreamBlocEvent {
  /// The ID of the stream where the error occurred.
  final int streamId;

  /// The error object.
  final Object error;

  /// Optional stack trace associated with the error.
  final StackTrace? stackTrace;

  MultiStreamBlocError(this.streamId, this.error, [this.stackTrace]);
}

/// Event to reset the MultiStreamBloc to its initial state.
class MultiStreamBlocReset extends MultiStreamBlocEvent {}

/// Base class for the state of a MultiStreamBloc.
///
/// Extend this class to define the specific state for your bloc.
@immutable
abstract class MultiStreamBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// A generic Bloc for managing multiple streaming data sources.
///
/// [Event] is the type of events this bloc handles, extending [MultiStreamBlocEvent].
/// [State] is the type of state this bloc manages, extending [MultiStreamBlocState].
abstract class MultiStreamBloc<Event extends MultiStreamBlocEvent,
        State extends MultiStreamBlocState>
    extends Bloc<MultiStreamBlocEvent, State> {
  /// Stores active stream subscriptions, keyed by stream ID.
  final Map<int, StreamSubscription<dynamic>> _subscriptions = {};

  /// Stores debounce timers for each stream, keyed by stream ID.
  final Map<int, Timer> _debouncers = {};

  /// Duration to debounce rapid updates from streams.
  final Duration _debounceDuration;

  /// The initial state of the bloc.
  final State _initialState;

  /// Creates a new instance of MultiStreamBloc.
  ///
  /// [initialState] is the initial state of the Bloc.
  /// [debounceDuration] is an optional duration to debounce rapid state updates.
  MultiStreamBloc({
    required State initialState,
    Duration debounceDuration = Duration.zero,
  })  : _debounceDuration = debounceDuration,
        _initialState = initialState,
        super(initialState) {
    on<_MultiStreamBlocUpdated>(_onUpdated);
    on<MultiStreamBlocError>(_onError);
    on<MultiStreamBlocReset>(_onReset);
  }

  /// Adds a new stream subscription to the bloc.
  ///
  /// [streamId] is a unique identifier for the stream.
  /// [stream] is the stream to subscribe to.
  void addSubscription<T>(int streamId, Stream<T?> stream) {
    _subscriptions[streamId]?.cancel();
    _subscriptions[streamId] = stream.listen((data) {
      if (data != null) {
        add(_MultiStreamBlocUpdated<T>(streamId, data));
      }
    }, onError: (Object error, StackTrace stackTrace) {
      add(MultiStreamBlocError(streamId, error, stackTrace));
    });
  }

  /// Abstract method to be implemented by subclasses to handle new stream data.
  ///
  /// [streamId] is the identifier of the stream that emitted new data.
  /// [data] is the new data emitted by the stream.
  @protected
  void onStreamData<T>(int streamId, T data);

  /// Handles the [_MultiStreamBlocUpdated] event.
  ///
  /// This method debounces rapid updates and calls [onStreamData].
  @protected
  Future<void> _onUpdated(
      _MultiStreamBlocUpdated event, Emitter<State> emit) async {
    _debouncers[event.streamId]?.cancel();
    _debouncers[event.streamId] = Timer(_debounceDuration, () {
      onStreamData(event.streamId, event.snapshot);
    });
  }

  /// Handles the [MultiStreamBlocError] event.
  ///
  /// Override this method to implement custom error handling logic.
  @protected
  Future<void> _onError(MultiStreamBlocError event, Emitter<State> emit) async {
    // Implement error handling logic here
  }

  /// Handles the [MultiStreamBlocReset] event.
  ///
  /// Cancels all subscriptions and debouncers, and resets the state to the initial state.
  @protected
  Future<void> _onReset(MultiStreamBlocReset event, Emitter<State> emit) async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    for (final debouncer in _debouncers.values) {
      debouncer.cancel();
    }
    _subscriptions.clear();
    _debouncers.clear();
    emit(_initialState);
  }

  /// Updates the bloc's state.
  ///
  /// Use this method to emit a new state from within your bloc logic.
  void updateState(State newState) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(newState);
  }

  /// Closes the MultiStreamBloc and cleans up resources.
  ///
  /// This method is called automatically when the bloc is closed.
  @override
  Future<void> close() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    for (final debouncer in _debouncers.values) {
      debouncer.cancel();
    }
    return super.close();
  }
}

/// Example usage:
///
/// ```dart
/// // Define custom events
/// abstract class CompanyBlocEvent extends MultiStreamBlocEvent {}
///
/// class ListenToCompany extends CompanyBlocEvent {
///   final String companyId;
///   ListenToCompany(this.companyId);
/// }
///
/// // Define custom state
/// class CompanyBlocState extends MultiStreamBlocState {
///   final DocumentSnapshot<CompanyModel>? company;
///   final QuerySnapshot<PlatformConnectionModel>? platformConnections;
///
///   CompanyBlocState({this.company, this.platformConnections});
///
///   @override
///   List<Object?> get props => [company, platformConnections];
///
///   CompanyBlocState copyWith({
///     DocumentSnapshot<CompanyModel>? company,
///     QuerySnapshot<PlatformConnectionModel>? platformConnections,
///   }) {
///     return CompanyBlocState(
///       company: company ?? this.company,
///       platformConnections: platformConnections ?? this.platformConnections,
///     );
///   }
/// }
///
/// // Implement MultiStreamBloc
/// class CompanyBloc extends MultiStreamBloc<CompanyBlocEvent, CompanyBlocState> {
///   final CompanyRepository repository;
///
///   CompanyBloc({required this.repository})
///       : super(initialState: CompanyBlocState());
///
///   @override
///   void onStreamData<T>(int streamId, T data) {
///     if (streamId == 0 && data is DocumentSnapshot<CompanyModel>) {
///       updateState(state.copyWith(company: data));
///     } else if (streamId == 1 && data is QuerySnapshot<PlatformConnectionModel>) {
///       updateState(state.copyWith(platformConnections: data));
///     }
///   }
///
///   void _onListenToCompany(ListenToCompany event, Emitter<CompanyBlocState> emit) {
///     addSubscription<DocumentSnapshot<CompanyModel>>(
///       0,
///       repository.getCompanyStream(event.companyId),
///     );
///     addSubscription<QuerySnapshot<PlatformConnectionModel>>(
///       1,
///       repository.getPlatformConnectionsStream(event.companyId),
///     );
///   }
///
///   @override
///   void onTransition(Transition<MultiStreamBlocEvent, CompanyBlocState> transition) {
///     super.onTransition(transition);
///     print(transition);
///   }
/// }
///
/// // Usage in a Flutter widget
/// class CompanyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return BlocProvider(
///       create: (context) => CompanyBloc(repository: CompanyRepository())
///         ..add(ListenToCompany('company_id')),
///       child: BlocBuilder<CompanyBloc, CompanyBlocState>(
///         builder: (context, state) {
///           if (state.company == null) {
///             return CircularProgressIndicator();
///           }
///           return Column(
///             children: [
///               Text(state.company!.data()!.name),
///               if (state.platformConnections != null)
///                 ListView.builder(
///                   itemCount: state.platformConnections!.docs.length,
///                   itemBuilder: (context, index) {
///                     final connection = state.platformConnections!.docs[index].data();
///                     return Text(connection.platformName);
///                   },
///                 ),
///             ],
///           );
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// This example demonstrates:
/// 1. Defining custom events and state for a specific use case.
/// 2. Implementing the `MultiStreamBloc` with custom logic.
/// 3. Using the bloc in a Flutter widget with `BlocProvider` and `BlocBuilder`.
/// 4. Handling multiple streams (company data and platform connections).
/// 5. Updating the state based on new data from different streams.