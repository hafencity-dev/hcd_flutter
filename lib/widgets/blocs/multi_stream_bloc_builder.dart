import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';
import 'package:hcd/utils/extensions/bloc_extensions.dart';

/// A widget that listens to a [MultiStreamBloc] and builds accordingly.
///
/// It requires a builder function, and optionally a bloc, a create function, and a buildWhen condition.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocBuilder<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final Widget Function(BuildContext, S) builder;
  final bool Function(S, S)? buildWhen;
  final T? bloc;
  final T Function(BuildContext)? create;

  /// Constructs a [MultiStreamBlocBuilder].
  ///
  /// - [bloc]: An optional [MultiStreamBloc] this widget listens to.
  /// - [create]: An optional function that creates and returns a [MultiStreamBloc].
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  const MultiStreamBlocBuilder({
    super.key,
    this.bloc,
    this.create,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    final builder = BlocBuilder<T, MultiStreamBlocState>(
      builder: _buildWithState,
      buildWhen: _buildWhen,
    );

    return create != null ? builder.create(create!) : builder;
  }

  Widget _buildWithState(BuildContext context, MultiStreamBlocState state) {
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
