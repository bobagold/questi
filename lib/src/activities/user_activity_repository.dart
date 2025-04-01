import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../quests/quest.dart';

part 'user_activity_repository.g.dart';

enum UserAction { accepted, completed }

typedef UserActivity = (Quest, UserAction?);

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

extension UserActivityFind on List<UserActivity> {
  UserActivity find(Quest quest) => firstWhere(
        (a) => a.$1.name == quest.name,
        orElse: () => (quest, null),
      );
  bool has(Quest quest) => any((a) => a.$1.name == quest.name);
  Iterable<UserActivity> get done => where((a) => a.$2 == UserAction.completed);
  Iterable<Quest> get quests => map((a) => a.$1);
}
