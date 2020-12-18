import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microsoft_authentication/microsoft_authentication.dart';

void main() {
  const MethodChannel channel = MethodChannel('microsoft_authentication');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MicrosoftAuthentication.platformVersion, '42');
  });
}
