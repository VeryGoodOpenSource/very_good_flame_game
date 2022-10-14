import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/gen/assets.gen.dart';
import 'package:very_good_flame_game/loading/loading.dart';

class _MockImages extends Mock implements Images {}

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreloadCubit', () {
    test('can be instantiated', () {
      expect(
        PreloadCubit(_MockImages(), _MockAudioCache()),
        isA<PreloadCubit>(),
      );
    });

    test('can be instantiated with images', () {
      final images = _MockImages();
      final audio = _MockAudioCache();

      expect(PreloadCubit(images, audio).images, images);
    });

    test('can be instantiated with initial state', () {
      final preloadCubit = PreloadCubit(
        _MockImages(),
        _MockAudioCache(),
      );

      expect(preloadCubit.state, const PreloadState.initial());
    });

    group('loadSequentially', () {
      late Images images;
      late AudioCache audio;

      blocTest<PreloadCubit, PreloadState>(
        'loads assets',
        setUp: () {
          images = _MockImages();
          when(
            () => images.loadAll([Assets.images.unicornAnimation.path]),
          ).thenAnswer((invocation) => Future.value(<Image>[]));

          audio = _MockAudioCache();
          when(() => audio.loadAll([Assets.audio.background])).thenAnswer(
            (invocation) async => [Uri.parse(Assets.audio.background)],
          );
        },
        build: () => PreloadCubit(images, audio),
        act: (bloc) => bloc.loadSequentially(),
        expect: () => [
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals(''))
              .having((s) => s.totalCount, 'totalCount', equals(2)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(0)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isTrue)
              .having((s) => s.loadedCount, 'loadedCount', equals(2)),
        ],
        verify: (bloc) {
          verify(() => audio.loadAll([Assets.audio.background])).called(1);
          verify(() => images.loadAll([Assets.images.unicornAnimation.path]))
              .called(1);
        },
      );
    });
  });
}
