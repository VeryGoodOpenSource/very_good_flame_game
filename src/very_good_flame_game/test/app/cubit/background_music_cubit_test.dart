import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/gen/assets.gen.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _FakeSource extends Fake implements AssetSource {}

void main() {
  group('BackgroundMusicCubit', () {
    late AudioPlayer player;

    setUp(() {
      player = _MockAudioPlayer();
    });

    setUpAll(() {
      registerFallbackValue(ReleaseMode.release);
      registerFallbackValue(_FakeSource());
    });

    blocTest<BackgroundMusicCubit, bool>(
      'play',
      setUp: () {
        when(() => player.dispose()).thenAnswer((_) async {});
        when(() => player.setReleaseMode(any())).thenAnswer((_) async {});
        when(() => player.setVolume(any())).thenAnswer((_) async {});
        when(() => player.setSource(any())).thenAnswer((_) async {});
        when(() => player.resume()).thenAnswer((_) async {});
      },
      build: () => BackgroundMusicCubit(player),
      act: (cubit) => cubit.play(),
      expect: () => [true],
      verify: (_) {
        verify(() => player.dispose()).called(1);
        verify(
          () => player.setReleaseMode(any(that: equals(ReleaseMode.loop))),
        ).called(1);
        verify(() => player.setVolume(any())).called(1);
        verify(
          () => player.setSource(
            any(
              that: isA<AssetSource>().having(
                (source) => source.path,
                'path',
                equals(Assets.audio.background),
              ),
            ),
          ),
        ).called(1);
        verify(() => player.resume()).called(1);
      },
    );

    blocTest<BackgroundMusicCubit, bool>(
      'pause',
      setUp: () => when(() => player.pause()).thenAnswer((_) async {}),
      build: () => BackgroundMusicCubit(player),
      act: (cubit) => cubit.pause(),
      expect: () => [false],
      verify: (_) => verify(() => player.pause()).called(1),
    );
  });
}
