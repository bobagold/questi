import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../activities/user_activity_repository.dart';
import '../images/carousel.dart';
import 'quest.dart';
import 'quest_list_view.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({
    super.key,
    required this.items,
  });

  final List<Quest> items;

  @override
  Widget build(BuildContext context, ref) {
    final activities = ref.watch(userActivityCollectorProvider);
    return ListView(
      children: [
        ListTile(title: Text('Популярные квесты')),
        ActivityCarouselLoader(
          languageCode: 'ru',
          activities: items.where((i) => !activities.has(i)).toList(),
        ),
        SizedBox.square(dimension: 10),
        if (activities.isNotEmpty) ...[
          ListTile(title: Text('Мои квесты')),
          ActivityCarouselLoader(
            languageCode: 'ru',
            activities: activities.map((a) => a.$1).toList(),
          ),
        ],
        SizedBox.square(dimension: 10),
        ListTile(
          title: Text.rich(
            TextSpan(
              text: 'Всего очков: ',
              children: [
                TextSpan(
                  text: activities.done
                      .fold<int>(0, (sum, item) => sum + item.$1.points)
                      .toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SizedBox.square(dimension: 10),
        ListTile(title: Text('Награды')),
        Wrap(
          children: activities.quests
              .map((item) => Chip(
                    label: Text(item.tags.join(', ')),
                    avatar: CircleAvatar(
                      child: Icon(randomIconByTags(item.tags)),
                    ),
                  ))
              .toList(),
        ),
        Column(children: [
          ListTile(
            leading: Text('Чат группы'),
            trailing: Text('20:00'),
          ),
          ListTile(
            leading: Text('20:00'),
            trailing: Text('Бег'),
          ),
          ListTile(
            leading: Text('Спорт'),
            trailing: Text('20:00'),
          ),
        ]),
      ],
    );
  }
}
