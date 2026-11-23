import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/state/updater.dart';

void main() {
  test('downloads only a newer build than the running one', () {
    expect(updateWanted(13, 12, null), isTrue);
    expect(updateWanted(12, 12, null), isFalse);
    expect(updateWanted(11, 12, null), isFalse);
  });

  test('a build already downloaded is not fetched again, a newer one is', () {
    expect(updateWanted(13, 12, 13), isFalse);
    expect(updateWanted(14, 12, 13), isTrue);
  });
}
