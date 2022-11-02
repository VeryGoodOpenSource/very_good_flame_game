import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/game/cubit/cubit.dart';

class _MockAudioCache extends Mock implements AudioCache {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockBgm extends Mock implements Bgm {}

void main() {
  group('AudioCubit', () {
    late AudioCache audioCache;
    late AudioPlayer effectPlayer;
    late Bgm bgm;
    late AudioPlayer bgmPlayer;

    setUp(() {
      audioCache = _MockAudioCache();
      effectPlayer = _MockAudioPlayer();
      bgm = _MockBgm();
      bgmPlayer = _MockAudioPlayer();
      when(() => bgm.audioPlayer).thenReturn(bgmPlayer);

      when(effectPlayer.dispose).thenAnswer((_) => Future.value());
      when(bgmPlayer.dispose).thenAnswer((_) => Future.value());
    });

    test('can be instantiated', () {
      expect(AudioCubit(audioCache: audioCache), isA<AudioCubit>());
    });

    blocTest<AudioCubit, AudioState>(
      'mute',
      setUp: () {
        when(() => effectPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => bgmPlayer.setVolume(any())).thenAnswer((_) async {});
      },
      build: () => AudioCubit.test(effectPlayer: effectPlayer, bgm: bgm),
      act: (cubit) => cubit.mute(),
      expect: () => [const AudioState(volume: 0)],
      verify: (_) {
        verify(() => effectPlayer.setVolume(any(that: equals(0)))).called(1);
        verify(() => bgmPlayer.setVolume(any(that: equals(0)))).called(1);
      },
    );

    blocTest<AudioCubit, AudioState>(
      'unmute',
      setUp: () {
        when(() => effectPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => bgmPlayer.setVolume(any())).thenAnswer((_) async {});
      },
      build: () => AudioCubit.test(effectPlayer: effectPlayer, bgm: bgm),
      act: (cubit) => cubit.unmute(),
      expect: () => [const AudioState()],
      verify: (_) {
        verify(() => effectPlayer.setVolume(any(that: equals(1)))).called(1);
        verify(() => bgmPlayer.setVolume(any(that: equals(1)))).called(1);
      },
    );
  });
}
