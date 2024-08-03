import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocBuilderExtension on BlocBuilder {
  Widget create<B extends StateStreamableSource<S>, S>(
    B Function(BuildContext) create, {
    Key? key,
  }) {
    return BlocProvider<B>(
      key: key,
      create: create,
      child: this,
    );
  }
}

extension BlocListenerExtension on BlocListener {
  Widget create<B extends StateStreamableSource<S>, S>(
    B Function(BuildContext) create, {
    Key? key,
  }) {
    return BlocProvider<B>(
      key: key,
      create: create,
      child: this,
    );
  }
}

extension BlocConsumerExtension on BlocConsumer {
  Widget create<B extends StateStreamableSource<S>, S>(
    B Function(BuildContext) create, {
    Key? key,
  }) {
    return BlocProvider<B>(
      key: key,
      create: create,
      child: this,
    );
  }
}
