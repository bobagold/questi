import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_activity_repository.g.dart';

enum UserAction { accepted, completed }

typedef UserActivity = (String, UserAction);

@riverpod
class UserActivityCollector extends _$UserActivityCollector {
  @override
  List<UserActivity> build() => [];

  void accept(String activityName) {
    state = [
      ...state,
      (activityName, UserAction.accepted),
    ];
  }

  void complete(String activityName) {
    state = state.map((activity) {
      if (activity.$1 == activityName && activity.$2 == UserAction.accepted) {
        return (activityName, UserAction.completed);
      }
      return activity;
    }).toList();
  }
}
