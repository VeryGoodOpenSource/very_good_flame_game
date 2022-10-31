// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {}

class _VeryGoodFlameGame extends VeryGoodFlameGame {
  _VeryGoodFlameGame({required super.l10n});

  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final l10n = _MockAppLocalizations();
  when(() => l10n.counterText(any())).thenAnswer(
    (invocation) => 'counterText: ${invocation.positionalArguments[0]}',
  );

  final flameTester = FlameTester(
    () => _VeryGoodFlameGame(l10n: l10n),
  );

  group('CounterComponent', () {
    flameTester.test('has all components', (game) async {
      final component = CounterComponent(position: Vector2.all(1));
      await game.ensureAdd(component);

      expect(component.text, isNotNull);
    });

    flameTester.test('changes text count correctly', (game) async {
      final component = CounterComponent(position: Vector2.all(1));
      await game.ensureAdd(component);

      expect(component.text.text, equals(''));
      game.counter = 1;
      game.update(0.1);
      expect(component.text.text, equals('counterText: 1'));

      game.counter = 2;
      game.update(0.1);
      expect(component.text.text, equals('counterText: 2'));
    });
  });
}
