import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questi/src/http/http_repository.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/http/http_client_factory.dart'
    if (dart.library.js_interop) 'src/http/http_client_factory_web.dart'
    as http_factory;

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    ProviderScope(
      overrides: [
        httpRepositoryProvider.overrideWithValue(http_factory.httpClient()),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  );
}
