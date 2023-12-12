// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/cache.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class _FakeAssetSource extends Fake implements AssetSource {}

class _MockImages extends Mock implements Images {}

class _MockAppLocalizations extends Mock implements AppLocalizations {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _VeryGoodFlameGame extends VeryGoodFlameGame {
  _VeryGoodFlameGame({
    required super.l10n,
    required super.effectPlayer,
    required super.textStyle,
    required super.images,
  });

  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final l10n = _MockAppLocalizations();
  final audioPlayer = _MockAudioPlayer();
  final images = _MockImages();
  final flameTester = FlameTester(
    () => _VeryGoodFlameGame(
      l10n: l10n,
      effectPlayer: audioPlayer,
      textStyle: const TextStyle(),
      images: images,
    ),
  );

  Future<Image> fakeImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1, 1),
      Paint()..color = const Color(0xFF000000),
    );
    final picture = recorder.endRecording();
    return picture.toImage(1, 1);
  }

  group('TappingBehavior', () {
    late final Image image;

    setUpAll(() async {
      registerFallbackValue(_FakeAssetSource());

      image = await fakeImage();

      when(() => l10n.counterText(any())).thenReturn('counterText');
      when(() => audioPlayer.play(any())).thenAnswer((_) async {});
      when(() => images.fromCache(any())).thenReturn(image);
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
