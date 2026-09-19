import 'package:flip_clock/app/flip_clock_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review_platform_interface/in_app_review_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FakeInAppReviewPlatform extends InAppReviewPlatform {
  bool openStoreListingCalled = false;
  String? capturedAppStoreId;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<void> requestReview() async {}

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    openStoreListingCalled = true;
    capturedAppStoreId = appStoreId;
  }
}

void main() {
  late FakeInAppReviewPlatform fakeInAppReview;

  setUp(() {
    fakeInAppReview = FakeInAppReviewPlatform();
    InAppReviewPlatform.instance = fakeInAppReview;

    PackageInfo.setMockInitialValues(
      appName: 'FlipClock',
      packageName: 'com.bytekeeperlabs.flip_clock',
      version: '1.0.0',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  testWidgets(
    'FlipClock renders and opens settings with app version and rate the app',
    (tester) async {
      await tester.pumpWidget(const FlipClockApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('24-hour mode'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('About'), 300);
      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Rate the app'), findsOneWidget);
      expect(find.text('Rate us on the Play Store.'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);

      await tester.tap(find.text('Rate the app'));
      await tester.pumpAndSettle();

      expect(fakeInAppReview.openStoreListingCalled, isTrue);
      expect(
        fakeInAppReview.capturedAppStoreId,
        'com.bytekeeperlabs.flipClock',
      );
    },
  );
}
