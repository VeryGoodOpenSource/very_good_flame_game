import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/gen/assets.gen.dart';
import 'package:very_good_flame_game/loading/loading.dart';

class MockImages extends Mock implements Images {}

class MockAudioCache extends Mock implements AudioCache {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreloadCubit', () {
    test('can be instantiated', () {
      expect(
        PreloadCubit(MockImages(), MockAudioCache()),
        isA<PreloadCubit>(),
      );
    });

    test('can be instantiated with images', () {
      final images = MockImages();
      final audio = MockAudioCache();

      expect(PreloadCubit(images, audio).images, images);
    });

    test('can be instantiated with initial state', () {
      final preloadCubit = PreloadCubit(
        MockImages(),
        MockAudioCache(),
      );

      expect(preloadCubit.state, const PreloadState.initial());
    });

    group('loadSequentially', () {
      testWidgets('should load assets', (tester) async {
        final images = MockImages();
        when(
          () => images.loadAll([Assets.images.unicornAnimation.path]),
        ).thenAnswer((Invocation invocation) => Future.value(<Image>[]));

        final audio = MockAudioCache();
        when(() => audio.loadAll([Assets.audio.background])).thenAnswer(
          (Invocation invocation) async => [Uri.parse(Assets.audio.background)],
        );

        final cubit = PreloadCubit(images, audio);

        final future = cubit.loadSequentially();

        // Each phase is called in the next tick, so we need to settle first.
        await tester.pumpAndSettle(const Duration(microseconds: 1));

        verify(() => audio.loadAll([Assets.audio.background])).called(1);
        expect(cubit.state.isComplete, false);
        expect(cubit.state.currentLabel, 'audio');
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        verify(() => images.loadAll([Assets.images.unicornAnimation.path]))
            .called(1);
        expect(cubit.state.isComplete, false);
        expect(cubit.state.currentLabel, 'images');

        await future;

        expect(cubit.state.isComplete, true);
      });
    });
  });
}
