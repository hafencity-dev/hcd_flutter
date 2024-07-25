import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hcd/blocs/multi_stream_bloc/multi_stream_bloc.dart';

/// A widget that listens to a [MultiStreamBloc], reacts to state changes, and rebuilds accordingly.
///
/// It combines the functionality of [MultiStreamBlocListener] and [MultiStreamBlocBuilder].
/// This widget requires a bloc of type [T], a listener function, a builder function,
/// and optional [listenWhen] and [buildWhen] conditions.
///
/// [T] is the type of the [MultiStreamBloc].
/// [Event] is the type of events that the bloc handles.
/// [S] is the type of the state emitted by the bloc.
class MultiStreamBlocConsumer<
    T extends MultiStreamBloc<Event, S>,
    Event extends MultiStreamBlocEvent,
    S extends MultiStreamBlocState> extends StatelessWidget {
  final void Function(BuildContext, S?) listener;
  final bool Function(S?, S?)? listenWhen;
  final Widget Function(BuildContext, S?) builder;
  final bool Function(S?, S?)? buildWhen;
  final T? bloc;

  /// Constructs a [MultiStreamBlocConsumer].
  ///
  /// - [bloc]: The [MultiStreamBloc] this widget listens to and builds from.
  /// - [listener]: A function that reacts to the bloc's state changes.
  /// - [listenWhen]: An optional condition that determines whether to trigger the listener.
  /// - [builder]: A function that builds the widget tree based on the bloc's state.
  /// - [buildWhen]: An optional condition that determines whether to rebuild.
  const MultiStreamBlocConsumer({
    super.key,
    this.bloc,
    required this.listener,
    this.listenWhen,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, MultiStreamBlocState>(
      bloc: bloc,
      listener: (context, state) {
        final S? currentState = state as S?;
        return listener(context, currentState);
      },
      listenWhen: (previous, current) {
        if (listenWhen == null) {
          return true;
        }
        final S? previousState = previous as S?;
        final S? currentState = current as S?;
        return listenWhen!(previousState, currentState);
      },
      builder: (context, state) {
        final S? currentState = state as S?;
        return builder(context, currentState);
      },
      buildWhen: (previous, current) {
        if (buildWhen == null) {
          return true;
        }
        final S? previousState = previous as S?;
        final S? currentState = current as S?;
        return buildWhen!(previousState, currentState);
      },
    );
  }
}


/// Example usage:
///
/// ```dart
/// // Define custom events
/// abstract class UserBlocEvent extends MultiStreamBlocEvent {}
///
/// class FetchUserData extends UserBlocEvent {
///   final String userId;
///   FetchUserData(this.userId);
/// }
///
/// // Define custom state
/// class UserBlocState extends MultiStreamBlocState {
///   final DocumentSnapshot<UserModel>? user;
///   final QuerySnapshot<PostModel>? posts;
///
///   UserBlocState({this.user, this.posts});
///
///   @override
///   List<Object?> get props => [user, posts];
///
///   UserBlocState copyWith({
///     DocumentSnapshot<UserModel>? user,
///     QuerySnapshot<PostModel>? posts,
///   }) {
///     return UserBlocState(
///       user: user ?? this.user,
///       posts: posts ?? this.posts,
///     );
///   }
/// }
///
/// // Implement MultiStreamBloc
/// class UserBloc extends MultiStreamBloc<UserBlocEvent, UserBlocState> {
///   final UserRepository repository;
///
///   UserBloc({required this.repository})
///       : super(initialState: UserBlocState());
///
///   @override
///   void onStreamData<T>(int streamId, T data) {
///     if (streamId == 0 && data is DocumentSnapshot<UserModel>) {
///       updateState(state.copyWith(user: data));
///     } else if (streamId == 1 && data is QuerySnapshot<PostModel>) {
///       updateState(state.copyWith(posts: data));
///     }
///   }
///
///   void _onFetchUserData(FetchUserData event, Emitter<UserBlocState> emit) {
///     addSubscription<DocumentSnapshot<UserModel>>(
///       0,
///       repository.getUserStream(event.userId),
///     );
///     addSubscription<QuerySnapshot<PostModel>>(
///       1,
///       repository.getUserPostsStream(event.userId),
///     );
///   }
/// }
///
/// // Usage in a Flutter widget
/// class UserProfileWidget extends StatelessWidget {
///   final String userId;
///
///   const UserProfileWidget({Key? key, required this.userId}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return BlocProvider(
///       create: (context) => UserBloc(repository: UserRepository())
///         ..add(FetchUserData(userId)),
///       child: MultiStreamBlocConsumer<UserBloc, UserBlocState>(
///         listener: (context, state) {
///           if (state.user == null) {
///             ScaffoldMessenger.of(context).showSnackBar(
///               SnackBar(content: Text('User not found')),
///             );
///           }
///         },
///         builder: (context, state) {
///           if (state.user == null) {
///             return Center(child: CircularProgressIndicator());
///           }
///           return Column(
///             children: [
///               Text(state.user!.data()!.name),
///               Text(state.user!.data()!.email),
///               if (state.posts != null)
///                 ListView.builder(
///                   itemCount: state.posts!.docs.length,
///                   itemBuilder: (context, index) {
///                     final post = state.posts!.docs[index].data();
///                     return ListTile(
///                       title: Text(post.title),
///                       subtitle: Text(post.content),
///                     );
///                   },
///                 ),
///             ],
///           );
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// This example demonstrates:
/// 1. Defining custom events and state for a specific use case (user profile).
/// 2. Implementing the `MultiStreamBloc` with custom logic for handling user and posts data.
/// 3. Using the `MultiStreamBlocConsumer` in a Flutter widget to listen to and build from the bloc's state.
/// 4. Handling multiple streams (user data and user posts).
/// 5. Proper error handling and loading state management.
/// 6. Updating the UI based on the combined state from multiple streams.

