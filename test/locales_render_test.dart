import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pudim_music/l10n/delegates.dart';
import 'package:pudim_music/l10n/l10n.dart';

/// Guards the build 8-11 gray screens: material_ui widgets need material_ui's own
/// MaterialLocalizations. With the wrong delegate list, every language but English threw
/// "No MaterialLocalizations found" and release builds showed gray boxes instead of screens.
void main() {
  for (final locale in L10n.supportedLocales) {
    testWidgets('Material widgets render in ${locale.toLanguageTag()}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(context.l10n.loginTitle)),
              body: Column(
                children: [
                  const TextField(decoration: InputDecoration(labelText: 'x')),
                  IconButton(
                    tooltip: context.l10n.commonClose,
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                  ),
                  const BackButton(),
                  TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const AlertDialog(content: Text('ok')),
                    ),
                    child: const Text('open'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        MaterialLocalizations.of(tester.element(find.byType(TextField))),
        isNotNull,
      );
      expect(find.byType(ErrorWidget), findsNothing);
    });
  }
}
