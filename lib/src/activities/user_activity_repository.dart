import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../quests/quest.dart';

part 'user_activity_repository.g.dart';

enum UserAction { accepted, completed }

typedef UserActivity = (Quest, UserAction);

@riverpod
class UserActivityCollector extends _$UserActivityCollector {
  @override
  List<UserActivity> build() => [];

  void accept(Quest quest) {
    state = [
      ...state,
      (quest, UserAction.accepted),
    ];
  }

  void complete(Quest quest) {
    state = state.map((activity) {
      if (activity.$1.name == quest.name &&
          activity.$2 == UserAction.accepted) {
        return (quest, UserAction.completed);
      }
      return activity;
    }).toList();
  }
}
