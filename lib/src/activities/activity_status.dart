import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_activity_repository.dart';
import '../quests/quest.dart';

class ActivityStatus extends ConsumerWidget {
  final Quest quest;

  const ActivityStatus({super.key, required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(userActivityCollectorProvider);
    final activity = activities.firstWhere(
      (a) => a.$1.name == quest.name,
      orElse: () => (
        Quest(
          name: '',
          complexity: '',
        ),
        UserAction.accepted
      ),
    );

    return activity.$1.name == ''
        ? OutlinedButton(
            onPressed: () =>
                ref.read(userActivityCollectorProvider.notifier).accept(quest),
            child: const Text("Принять"),
          )
        : activity.$2 == UserAction.accepted
            ? ElevatedButton(
                onPressed: () => ref
                    .read(userActivityCollectorProvider.notifier)
                    .complete(quest),
                child: const Text("Выполнено"),
              )
            : const Text("Выполнено, поздравляем!");
  }
}
