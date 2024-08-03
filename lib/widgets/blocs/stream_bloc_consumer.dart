import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/stream_bloc/stream_bloc.dart';
import 'package:hcd/utils/extensions/bloc_extensions.dart';

/// A widget that listens to a [StreamBloc], reacts to state changes, and rebuilds accordingly.
///
/// It combines the functionality of [StreamBlocListener] and [StreamBlocBuilder].
/// This widget requires a listener function, a builder function,
/// and optional [listenWhen] and [buildWhen] conditions.
/// [B] is the type of the stream snapshot emitted by the bloc.
class StreamBlocConsumer<T extends StreamBloc<B, StreamBlocEvent>, B>
    extends StatelessWidget {
  final void Function(BuildContext, B?) listener;
  final bool Function(B?, B?)? listenWhen;
  final Widget Function(BuildContext, B?) builder;
  final bool Function(B?, B?)? buildWhen;
  final T? bloc;
  final T Function(BuildContext)? create;
  final bool onlyIfTopRoute;

  /// Constructs a [StreamBlocConsumer].
  ///
  /// - [bloc]: The [StreamBloc] this widget listens to and builds from (optional).
  /// - [create]: A function that creates and returns a [StreamBloc] (optional).
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  /// - [onlyIfTopRoute]: Whether to only call listener if the current route is the top route.
  const StreamBlocConsumer({
    super.key,
    this.bloc,
    this.create,
    required this.listener,
    this.listenWhen,
    required this.builder,
    this.buildWhen,
    this.onlyIfTopRoute = true,
  });

  @override
  Widget build(BuildContext context) {
    final consumer = BlocConsumer<T, StreamBlocState<B?>>(
      bloc: bloc,
      listener: _listener,
      listenWhen: _listenWhen,
      builder: _builder,
      buildWhen: _buildWhen,
    );

    return create != null ? consumer.create(create!) : consumer;
  }

  void _listener(BuildContext context, StreamBlocState<B?> state) {
    if (onlyIfTopRoute && !(ModalRoute.of(context)?.isCurrent == true)) {
      return;
    }
    final B? currentState = state.snapshot;
    listener(context, currentState);
  }

  bool _listenWhen(StreamBlocState<B?> previous, StreamBlocState<B?> current) {
    if (listenWhen == null) {
      return true;
    }
    final B? previousState = previous.snapshot;
    final B? currentState = current.snapshot;
    return listenWhen!(previousState, currentState);
  }

  Widget _builder(BuildContext context, StreamBlocState<B?> state) {
    final B? currentState = state.snapshot;
    return builder(context, currentState);
  }

  bool _buildWhen(StreamBlocState<B?> previous, StreamBlocState<B?> current) {
    if (buildWhen == null) {
      return true;
    }
    final B? previousState = previous.snapshot;
    final B? currentState = current.snapshot;
    return buildWhen!(previousState, currentState);
  }
}


/// Example usage:
///
/// ```dart
/// // Define a StreamBloc
/// class UserStreamBloc extends StreamBloc<User?, UserStreamBlocEvent> {
///   UserStreamBloc() : super(initialState: null);
///
///   ....
/// }
///
/// // Use StreamBlocConsumer in a widget
/// class UserProfileWidget extends StatelessWidget {
///   final String userId;
///
///   const UserProfileWidget({Key? key, required this.userId}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return StreamBlocConsumer<UserStreamBloc, User?>(
///       bloc: UserStreamBloc()..add(FetchUser(userId)),
///       listener: (context, user) {
///         if (user == null) {
///           ScaffoldMessenger.of(context).showSnackBar(
///             SnackBar(content: Text('User not found')),
///           );
///         }
///       },
///       builder: (context, user) {
///         if (user == null) {
///           return Center(child: CircularProgressIndicator());
///         }
///         return Column(
///           children: [
///             Text(user.name),
///             Text(user.email),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
///
/// This example demonstrates:
/// 1. Defining a custom `StreamBloc` for user data.
/// 2. Using `StreamBlocConsumer` in a widget to listen to and build from the bloc's state.
/// 3. Handling both the listener and builder functions to react to state changes and build the UI.
/// 4. Proper error handling and loading state management.