import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('domain_verification_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getDomainStateSelected', () async {
    expect(await DomainVerificationManager.domainStageSelected, '42');
  });

  test('getDomainStateNone', () async {
    expect(await DomainVerificationManager.domainStageSelected, '42');
  });

  test('getDomainStateSelected', () async {
    expect(await DomainVerificationManager.domainStageSelected, '42');
  });
}
