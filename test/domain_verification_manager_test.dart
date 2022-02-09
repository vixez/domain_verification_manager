import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('domain_verification_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getIsSupported':
          return true;
        case 'getDomainStateVerified':
          return [];
        case 'getDomainStateSelected':
          return [];
        case 'getDomainStateNone':
          return [];
      }
      return [];
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getIsSupported', () async {
    expect(await DomainVerificationManager.isSupported, true);
  });

  test('getDomainStateVerified', () async {
    expect(await DomainVerificationManager.domainStageSelected, []);
  });

  test('getDomainStateSelected', () async {
    expect(await DomainVerificationManager.domainStageSelected, []);
  });

  test('getDomainStateNone', () async {
    expect(await DomainVerificationManager.domainStageSelected, []);
  });
}
