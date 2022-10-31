import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/app/app.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VolumeCubit', () {
    test('can be instantiated', () {
      expect(
        VolumeCubit(_MockAudioPlayer()),
        isA<VolumeCubit>(),
      );
    });

    late AudioPlayer player;

    setUp(() {
      player = _MockAudioPlayer();
    });

    blocTest<VolumeCubit, bool>(
      'mute',
      setUp: () => when(() => player.setVolume(any())).thenAnswer((_) async {}),
      build: () => VolumeCubit(player),
      act: (cubit) => cubit.mute(),
      expect: () => [true],
      verify: (_) {
        verify(() => player.setVolume(any(that: equals(0)))).called(1);
      },
    );

    blocTest<VolumeCubit, bool>(
      'unmute',
      setUp: () => when(() => player.setVolume(any())).thenAnswer((_) async {}),
      build: () => VolumeCubit(player),
      act: (cubit) => cubit.unmute(),
      expect: () => [false],
      verify: (_) {
        verify(() => player.setVolume(any(that: equals(1)))).called(1);
      },
    );
  });
}
