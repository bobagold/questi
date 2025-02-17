import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questi/src/activities/user_activity_repository.dart';

class ActivityStatus extends ConsumerWidget {
  final String activityName;

  const ActivityStatus({super.key, required this.activityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(userActivityCollectorProvider);
    final activity = activities.firstWhere(
      (a) => a.$1 == activityName,
      orElse: () => ("", UserAction.accepted),
    );

    return activity.$1.isEmpty
        ? OutlinedButton(
            onPressed: () => ref
                .read(userActivityCollectorProvider.notifier)
                .accept(activityName),
            child: const Text("Принять"),
          )
        : activity.$2 == UserAction.accepted
            ? ElevatedButton(
                onPressed: () => ref
                    .read(userActivityCollectorProvider.notifier)
                    .complete(activityName),
                child: const Text("Выполнено"),
              )
            : const Text("Выполнено, поздравляем!");
  }
}
