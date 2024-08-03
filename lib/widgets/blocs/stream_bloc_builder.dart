import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/stream_bloc/stream_bloc.dart';
import 'package:hcd/utils/extensions/bloc_extensions.dart';

/// A widget that listens to a [StreamBloc] and builds accordingly.
///
/// It requires a builder function, and an optional bloc, create function, and buildWhen condition.
/// [B] is the type of the stream snapshot emitted by the bloc.
class StreamBlocBuilder<T extends StreamBloc<B, StreamBlocEvent>, B>
    extends StatelessWidget {
  final Widget Function(BuildContext, B?) builder;
  final bool Function(B?, B?)? buildWhen;
  final T? bloc;
  final T Function(BuildContext)? create;

  /// Constructs a [StreamBlocBuilder].
  ///
  /// - [bloc]: The [StreamBloc] this widget listens to (optional).
  /// - [create]: A function that creates and returns a [StreamBloc] (optional).
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  const StreamBlocBuilder({
    super.key,
    this.bloc,
    this.create,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    final blocBuilder = BlocBuilder<T, StreamBlocState<B?>>(
      bloc: bloc,
      builder: _buildWithState,
      buildWhen: _buildWhen,
    );

    return create != null ? blocBuilder.create(create!) : blocBuilder;
  }

  Widget _buildWithState(BuildContext context, StreamBlocState<B?> state) {
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
