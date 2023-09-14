// ignore_for_file: cascade_invocations

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class _FakeAssetSource extends Fake implements AssetSource {}

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
  final audioPlayer = _MockAudioPlayer();
  final flameTester = FlameTester(
    () => _VeryGoodFlameGame(
      l10n: l10n,
      effectPlayer: audioPlayer,
      textStyle: const TextStyle(),
    ),
  );

  group('TappingBehavior', () {
    setUpAll(() {
      registerFallbackValue(_FakeAssetSource());
    });

    setUp(() {
      when(() => l10n.counterText(any())).thenReturn('counterText');

      when(() => audioPlayer.play(any())).thenAnswer((_) async {});
    });

    flameTester.testGameWidget(
      'when tapped, starts playing the animation',
      setUp: (game, tester) async {
        await game.ensureAdd(
          Unicorn.test(
            position: Vector2.zero(),
            behaviors: [TappingBehavior()],
          ),
        );
      },
      verify: (game, tester) async {
        await tester.tapAt(Offset.zero);

        /// Flush long press gesture timer
        game.pauseEngine();
        await tester.pumpAndSettle();
        game.resumeEngine();

        game.update(0.1);

        final unicorn = game.firstChild<Unicorn>()!;
        expect(unicorn.animationTicker.currentIndex, equals(1));
        expect(unicorn.isAnimationPlaying(), equals(true));

        verify(() => audioPlayer.play(any())).called(1);
      },
    );
  });
}
