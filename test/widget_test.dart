import 'package:flutter_test/flutter_test.dart';
import 'package:nich_ka/app.dart';

void main() {
  test('App instantiates without error', () {
    const app = App();
    expect(app, isA<App>());
  });
}
