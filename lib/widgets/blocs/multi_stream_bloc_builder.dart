import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';

/// A widget that listens to a [MultiStreamBloc] and builds accordingly.
///
/// It requires a bloc of type [T], a builder function, and an optional [buildWhen] condition.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocBuilder<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final Widget Function(BuildContext, S) builder;
  final bool Function(S, S)? buildWhen;
  final T? bloc;

  /// Constructs a [MultiStreamBlocBuilder].
  ///
  /// - [bloc]: The [MultiStreamBloc] this widget listens to.
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  const MultiStreamBlocBuilder({
    super.key,
    this.bloc,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, MultiStreamBlocState>(
      bloc: bloc,
      builder: (context, state) {
        final S currentState = state as S;
        return builder(context, currentState);
      },
      buildWhen: (previous, current) {
        if (buildWhen == null) {
          return true;
        }
        final S previousState = previous as S;
        final S currentState = current as S;
        return buildWhen!(previousState, currentState);
      },
    );
  }
}
