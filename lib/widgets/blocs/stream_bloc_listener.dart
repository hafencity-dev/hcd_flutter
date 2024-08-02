import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/stream_bloc/stream_bloc.dart';

/// A widget that listens to a [StreamBloc] and reacts accordingly.
///
/// It requires a bloc of type [T], a listener function, and an optional [listenWhen] condition.
/// [B] is the type of the stream snapshot emitted by the bloc.
class StreamBlocListener<T extends StreamBloc<B, StreamBlocEvent>, B>
    extends StatelessWidget {
  final void Function(BuildContext, B?) listener;
  final bool Function(B?, B?)? listenWhen;
  final T? bloc;
  final Widget child;
  final bool onlyIfTopRoute;

  /// Constructs a [StreamBlocListener].
  ///
  /// - [bloc]: The [StreamBloc] this widget listens to.
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [child]: The widget below this widget in the tree.
  /// - [onlyIfTopRoute]: Whether to only call listener if the current route is the top route.
  const StreamBlocListener({
    super.key,
    this.bloc,
    required this.listener,
    this.listenWhen,
    required this.child,
    this.onlyIfTopRoute = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<T, StreamBlocState<B?>>(
      bloc: bloc,
      listener: (context, state) {
        if (onlyIfTopRoute && !(ModalRoute.of(context)?.isCurrent == true)) {
          return;
        }
        final B? currentState = state.snapshot;
        listener(context, currentState);
      },
      listenWhen: (previous, current) {
        if (listenWhen == null) {
          return true;
        }
        final B? previousState = previous.snapshot;
        final B? currentState = current.snapshot;
        return listenWhen!(previousState, currentState);
      },
      child: child,
    );
  }
}
