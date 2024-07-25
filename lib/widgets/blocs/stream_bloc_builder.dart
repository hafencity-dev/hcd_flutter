import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/stream_bloc/stream_bloc.dart';

/// A widget that listens to a [StreamBloc] and builds accordingly.
///
/// It requires a bloc of type [T], a builder function, and an optional [buildWhen] condition.
/// [B] is the type of the stream snapshot emitted by the bloc.
class StreamBlocBuilder<T extends StreamBloc<B, StreamBlocEvent>, B>
    extends StatelessWidget {
  final Widget Function(BuildContext, B?) builder;
  final bool Function(B?, B?)? buildWhen;
  final T? bloc;

  /// Constructs a [StreamBlocBuilder].
  ///
  /// - [bloc]: The [StreamBloc] this widget listens to.
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  const StreamBlocBuilder({
    super.key,
    this.bloc,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, StreamBlocState<B?>>(
      bloc: bloc,
      builder: (context, state) {
        final B? currentState = state.snapshot;
        return builder(context, currentState);
      },
      buildWhen: (previous, current) {
        if (buildWhen == null) {
          return true;
        }
        final B? previousState = previous.snapshot;
        final B? currentState = current.snapshot;
        return buildWhen!(previousState, currentState);
      },
    );
  }
}
