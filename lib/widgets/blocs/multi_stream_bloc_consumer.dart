import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';
import 'package:hcd/utils/extensions/bloc_extensions.dart';

/// A widget that listens to a [MultiStreamBloc], reacts to state changes, and rebuilds accordingly.
///
/// It combines the functionality of [MultiStreamBlocListener] and [MultiStreamBlocBuilder].
/// This widget requires a listener function, a builder function,
/// and optional [listenWhen] and [buildWhen] conditions.
///
/// [T] is the type of the [MultiStreamBloc].
/// [Event] is the type of events that the bloc handles.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocConsumer<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final void Function(BuildContext, S) listener;
  final bool Function(S, S)? listenWhen;
  final Widget Function(BuildContext, S) builder;
  final bool Function(S, S)? buildWhen;
  final T? bloc;
  final T Function(BuildContext)? create;
  final bool onlyIfTopRoute;

  /// Constructs a [MultiStreamBlocConsumer].
  ///
  /// - [bloc]: The [MultiStreamBloc] this widget listens to and builds from (optional).
  /// - [create]: A function that creates and returns a [MultiStreamBloc] (optional).
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  /// - [onlyIfTopRoute]: Whether to only call listener if the current route is the top route.
  const MultiStreamBlocConsumer({
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
    final consumer = BlocConsumer<T, MultiStreamBlocState>(
      bloc: bloc,
      listener: _listener,
      listenWhen: _listenWhen,
      builder: _builder,
      buildWhen: _buildWhen,
    );

    return create != null ? consumer.create(create!) : consumer;
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

  Widget _builder(BuildContext context, MultiStreamBlocState state) {
    final S currentState = state as S;
    return builder(context, currentState);
  }

  bool _buildWhen(MultiStreamBlocState previous, MultiStreamBlocState current) {
    if (buildWhen == null) {
      return true;
    }
    final S previousState = previous as S;
    final S currentState = current as S;
    return buildWhen!(previousState, currentState);
  }
}
