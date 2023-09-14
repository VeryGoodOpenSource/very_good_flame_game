// ignore_for_file: cascade_invocations

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _VeryGoodFlameGame extends VeryGoodFlameGame {
  _VeryGoodFlameGame({
    required super.l10n,
    required super.effectPlayer,
    required super.textStyle,
  });

  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final l10n = _MockAppLocalizations();
  _VeryGoodFlameGame createFlameGame() {
    return _VeryGoodFlameGame(
      l10n: l10n,
      effectPlayer: _MockAudioPlayer(),
      textStyle: const TextStyle(),
    );
  }

  group('Unicorn', () {
    setUp(() {
      when(() => l10n.counterText(any())).thenReturn('counterText');
    });

    testWithGame(
      'has all behaviors',
      createFlameGame,
      (game) async {
        final unicorn = Unicorn(position: Vector2.all(1));
        await game.ensureAdd(unicorn);

        expect(unicorn.findBehavior<TappingBehavior>(), isNotNull);
      },
    );

    testWithGame(
      'loads correctly',
      createFlameGame,
      (game) async {
        final unicorn = Unicorn(position: Vector2.all(1));
        await game.ensureAdd(unicorn);

        expect(unicorn.isAnimationPlaying(), equals(false));
      },
    );

    group('animation', () {
      testWithGame(
        'plays animation',
        createFlameGame,
        (game) async {
          final unicorn = Unicorn.test(position: Vector2.all(1));
          await game.ensureAdd(unicorn);

          unicorn.playAnimation();
          expect(unicorn.animationTicker.currentIndex, equals(0));

          game.update(0.1);

          expect(unicorn.animationTicker.currentIndex, equals(1));
          expect(unicorn.isAnimationPlaying(), equals(true));
        },
      );

      testWithGame(
        'reset animation back to frame one and stops it',
        createFlameGame,
        (game) async {
          final unicorn = Unicorn.test(position: Vector2.all(1));
          await game.ensureAdd(unicorn);

          unicorn.playAnimation();
          game.update(0.1);
          expect(unicorn.animationTicker.currentIndex, equals(1));
          expect(unicorn.isAnimationPlaying(), equals(true));

          unicorn.resetAnimation();
          expect(unicorn.isAnimationPlaying(), equals(false));
          expect(unicorn.animationTicker.currentIndex, equals(0));

          game.update(0.1);
          expect(unicorn.animationTicker.currentIndex, equals(0));
          expect(unicorn.isAnimationPlaying(), equals(false));
        },
      );
    });
  });
}
