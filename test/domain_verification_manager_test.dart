import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('domain_verification_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
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
