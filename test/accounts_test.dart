import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/state/session.dart';

void main() {
  test('conta salva volta igual', () {
    const a = Account(
      userId: 'abc',
      userName: 'Ana',
      lan: 'http://192.168.0.2:8096',
      wan: 'https://music.example.com',
      extras: 'https://extras.example.com',
    );
    final b = Account.fromJson(a.toJson());
    expect(b.userId, 'abc');
    expect(b.userName, 'Ana');
    expect(b.lan, a.lan);
    expect(b.wan, a.wan);
    expect(b.extras, a.extras);
    expect(b.host, 'music.example.com');
  });

  test('sem endereço de fora mostra o da rede local', () {
    const a = Account(
      userId: 'x',
      userName: 'B',
      lan: 'http://10.0.0.5:8096',
      wan: '',
    );
    expect(a.host, '10.0.0.5');
    expect(Account.fromJson(a.toJson()).extras, '');
  });
}
