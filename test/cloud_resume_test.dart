import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/audio/player.dart';

// Resume on another device: a device takes the panel's state only when it is newer than what it
// already sent or took, and only when another device sent it.
void main() {
  test('newer state from another device is taken', () {
    expect(
      takeOverCloudState(updated: 20, seen: 10, device: 'b', me: 'a'),
      isTrue,
    );
  });
  test('own state is not taken back', () {
    expect(
      takeOverCloudState(updated: 20, seen: 10, device: 'a', me: 'a'),
      isFalse,
    );
  });
  test('state already seen is ignored', () {
    expect(
      takeOverCloudState(updated: 10, seen: 10, device: 'b', me: 'a'),
      isFalse,
    );
  });
  test('empty panel (updated 0) is ignored', () {
    expect(
      takeOverCloudState(updated: 0, seen: 0, device: null, me: 'a'),
      isFalse,
    );
  });
}
