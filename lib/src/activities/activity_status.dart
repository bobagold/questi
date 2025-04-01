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
    final status = activities.find(quest).$2;

    return status == null
        ? OutlinedButton(
            onPressed: () =>
                ref.read(userActivityCollectorProvider.notifier).accept(quest),
            child: const Text("Принять"),
          )
        : status == UserAction.accepted
            ? ElevatedButton(
                onPressed: () => ref
                    .read(userActivityCollectorProvider.notifier)
                    .complete(quest),
                child: const Text("Выполнено"),
              )
            : const Text("Выполнено, поздравляем!");
  }
}
