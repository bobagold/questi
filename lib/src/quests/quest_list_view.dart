import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../settings/settings_view.dart';
import 'dashboard.dart';
import 'quest.dart';
import 'quest_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends HookWidget {
  const SampleItemListView({
    super.key,
  });

  static const routeName = '/';
  final bool useFixtures = true;

  @override
  Widget build(BuildContext context) {
    final useCarousel = useState(false);
    final db = FirebaseFirestore.instance;
    final futureList = useMemoized(() => !useFixtures
        ? db.collection("quests").get().then((event) =>
            event.docs.map((doc) => Quest.fromJson(doc.data())).toList())
        : rootBundle
            .loadString('assets/quests/fixture.json')
            .then(jsonDecode)
            .then((list) => list
                .map((e) => Quest.fromJson(e))
                .where((e) => e != null)
                .toList()
                .cast<Quest>()));
    final data = useFuture(futureList);
    final List<Quest>? items = data.data;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Квесты'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => useCarousel.value = !useCarousel.value,
          child:
              Icon(useCarousel.value ? Icons.view_list : Icons.view_carousel),
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: items != null
            ? (useCarousel.value
                ? Dashboard(items: items)
                : ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'sampleItemListView',
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];

                      return ListTile(
                          title: Text(item.name),
                          leading: CircleAvatar(
                            child: Icon(randomIconByTags(item.tags)),
                          ),
                          subtitle:
                              Text(item.tags.map((tag) => '#$tag').join(' ')),
                          trailing: Text(item.points.toString()),
                          onTap: () {
                            // Navigate to the details page. If the user leaves and returns to
                            // the app after it has been killed while running in the
                            // background, the navigation stack is restored.
                            Navigator.restorablePushNamed(
                              context,
                              SampleItemDetailsView.routeName,
                            );
                          });
                    },
                  ))
            : Center(child: CircularProgressIndicator()));
  }
}

const _byTag = {
  "поход": Icons.hiking,
  "спорт": Icons.fitness_center,
  "бег": Icons.directions_run,
  "чтение": Icons.local_library,
  "природа": Icons.park,
  "плавание": Icons.pool,
  "еда": Icons.fastfood,
  "готовка": Icons.restaurant,
  "музыка": Icons.music_note,
  "инструмент": Icons.piano,
  "путешествие": Icons.flight,
  "история": Icons.history_edu,
  "йога": Icons.self_improvement,
  "искусство": Icons.brush,
  "живопись": Icons.palette,
  "велосипед": Icons.directions_bike,
  "общение": Icons.groups,
  "нетворкинг": Icons.handshake,
  "мероприятие": Icons.event,
  "благотворительность": Icons.volunteer_activism,
  "дискуссия": Icons.record_voice_over,
  "разговор": Icons.forum,
  "друзья": Icons.people,
  "отдых": Icons.spa,
};
final _random = Random();
IconData randomIconByTags(List<String> tags) {
  final availableIcons =
      tags.map((tag) => _byTag[tag]).whereType<IconData>().toList();
  return availableIcons.isNotEmpty
      ? availableIcons[_random.nextInt(availableIcons.length)]
      : Icons.help_outline;
}
