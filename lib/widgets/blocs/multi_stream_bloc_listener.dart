import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';
import 'package:hcd/utils/extensions/bloc_extensions.dart';

/// A widget that listens to a [MultiStreamBloc] and reacts accordingly.
///
/// It requires a listener function, and an optional [listenWhen] condition.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocListener<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final void Function(BuildContext, S) listener;
  final bool Function(S, S)? listenWhen;
  final T? bloc;
  final T Function(BuildContext)? create;
  final Widget child;
  final bool onlyIfTopRoute;

  /// Constructs a [MultiStreamBlocListener].
  ///
  /// - [bloc]: The [MultiStreamBloc] this widget listens to (optional).
  /// - [create]: A function that creates and returns a [MultiStreamBloc] (optional).
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [child]: The widget below this widget in the tree.
  /// - [onlyIfTopRoute]: Whether to only call listener if the current route is the top route.
  const MultiStreamBlocListener({
    super.key,
    this.bloc,
    this.create,
    required this.listener,
    this.listenWhen,
    required this.child,
    this.onlyIfTopRoute = true,
  });

  @override
  Widget build(BuildContext context) {
    final listener = BlocListener<T, MultiStreamBlocState>(
      bloc: bloc,
      listener: _listener,
      listenWhen: _listenWhen,
      child: child,
    );

    return create != null ? listener.create(create!) : listener;
  }

  void _listener(BuildContext context, MultiStreamBlocState state) {
    if (onlyIfTopRoute && !(ModalRoute.of(context)?.isCurrent == true)) {
      return;
    }
    final S currentState = state as S;
    listener(context, currentState);
  }

  bool _listenWhen(
      MultiStreamBlocState previous, MultiStreamBlocState current) {
    if (listenWhen == null) {
      return true;
    }
    final S previousState = previous as S;
    final S currentState = current as S;
    return listenWhen!(previousState, currentState);
  }
}
