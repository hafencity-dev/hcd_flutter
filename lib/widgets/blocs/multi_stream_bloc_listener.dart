import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';

/// A widget that listens to a [MultiStreamBloc] and reacts accordingly.
///
/// It requires a bloc of type [T], a listener function, and an optional [listenWhen] condition.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocListener<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final void Function(BuildContext, S) listener;
  final bool Function(S, S)? listenWhen;
  final T? bloc;
  final Widget child;

  /// Constructs a [MultiStreamBlocListener].
  ///
  /// - [bloc]: The [MultiStreamBloc] this widget listens to.
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [child]: The widget below this widget in the tree.
  const MultiStreamBlocListener({
    super.key,
    this.bloc,
    required this.listener,
    this.listenWhen,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<T, MultiStreamBlocState>(
      bloc: bloc,
      listener: (context, state) {
        final S currentState = state as S;
        return listener(context, currentState);
      },
      listenWhen: (previous, current) {
        if (listenWhen == null) {
          return true;
        }
        final S previousState = previous as S;
        final S currentState = current as S;
        return listenWhen!(previousState, currentState);
      },
      child: child,
    );
  }
}
