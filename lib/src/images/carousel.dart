import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../activities/activity_status.dart';
import '../http/http_repository.dart';
import '../quests/quest.dart';

class ActivityCarouselLoader extends ConsumerWidget {
  final List<Quest> activities;
  final String? languageCode;
  const ActivityCarouselLoader({
    super.key,
    required this.activities,
    this.languageCode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActivityCarousel(
      activities: activities,
      languageCode: languageCode,
      client: ref.watch(httpRepositoryProvider),
    );
  }
}

class ActivityCarousel extends HookWidget {
  final List<Quest> activities;
  final String? languageCode;
  final http.Client client;

  const ActivityCarousel({
    super.key,
    required this.activities,
    this.languageCode,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final apiKey = const String.fromEnvironment('PIXABAY_API_KEY');
    final languageCode =
        this.languageCode ?? Localizations.localeOf(context).languageCode;

    Future<Map<String, String>> fetchActivityImages() async {
      Map<String, String> activityImages = {};
      if (apiKey.isEmpty) {
        return Map.fromEntries(activities.map((activity) =>
            MapEntry(activity.key, 'https://via.placeholder.com/150')));
      }

      for (final activity in activities) {
        final response = await client.get(
          Uri.parse(
              //    'https://api.imagga.com/v2/categories/personal_photos?language=$languageCode&search=$activity'),
              'https://pixabay.com/api/?key=$apiKey&q=${activity.search}&image_type=photo&lang=$languageCode&per_page=10'),
          // headers: {
          //   'Authorization':
          //       'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
          // },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['hits'].isNotEmpty) {
            activityImages[activity.key] = data['hits'][0]['webformatURL'];
          } else {
            activityImages[activity.key] =
                'https://via.placeholder.com/150'; // Fallback image
          }
        } else {
          activityImages[activity.key] =
              'https://via.placeholder.com/150'; // Fallback image
        }
      }

      return activityImages;
    }

    final futureImages = useMemoized(fetchActivityImages, [activities]);
    final snapshot = useFuture(futureImages);

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error fetching images'));
    } else {
      final activityImages = snapshot.data ?? {};
      return CarouselSlider(
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          autoPlay: true,
        ),
        items: activities.map((activity) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: activityImages[activity.key]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        activity.displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ActivityStatus(quest: activity),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }
}
