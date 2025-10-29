import 'dart:io';

import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() async {
    await setUpInversionOfControl();
  });

  tearDown(() async {
    await inject.reset();
  });

  group('Profile Page Tests', () {
    testWidgets('should compare profile page to a golden', (tester) async {
      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('profile_button')));
      await tester.pumpAndSettle();

      //Validate that the profile page is displayed
      expect(find.text('Roman Štěpka'), findsOneWidget);

      //Perform a golden test to check the profile picture of my cat is as expected
      final profilePicture = find.byKey(const ValueKey('profile_picture_container'));
      expect(profilePicture, findsOneWidget);
      await expectLater(
        profilePicture,
        matchesGoldenFile('goldens/profile_picture.png'),
      );
    });
  });
}
