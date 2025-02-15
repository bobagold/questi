import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:questi/src/images/carousel.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class Quest {
  final String name;
  final String complexity;
  final List<String> tags;
  final List<String> badges;

  const Quest({
    required this.name,
    required this.complexity,
    this.tags = const [],
    this.badges = const [],
  });

  static Quest? fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "name": String name,
          "complexity": String complexity,
          // "tags": List<String> tags,
          // "badges": List<String> badges,
        }) {
      return Quest(
        name: name,
        complexity: complexity,
        // tags: tags,
        // badges: badges,
      );
    }
    return null;
  }
}

/// Displays a list of SampleItems.
class SampleItemListView extends HookWidget {
  const SampleItemListView({
    super.key,
  });

  static const routeName = '/';
  final bool useCarousel = true;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final futureList = useMemoized(() => db.collection("quests").get().then(
        (event) =>
            event.docs.map((doc) => Quest.fromJson(doc.data())).toList()));
    final data = useFuture(futureList);
    final items = data.data;

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

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: items != null
            ? (useCarousel
                ? ActivityCarousel(
                    languageCode: 'ru',
                    activities:
                        items.map((e) => e?.name ?? 'Веселись').toList(),
                  )
                : ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'sampleItemListView',
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];

                      return ListTile(
                          title: Text(item!.name),
                          leading: const CircleAvatar(
                            // Display the Flutter Logo image asset.
                            foregroundImage:
                                AssetImage('assets/images/flutter_logo.png'),
                          ),
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
