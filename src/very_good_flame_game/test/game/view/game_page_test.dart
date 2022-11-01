import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/loading/cubit/cubit.dart';

import '../../helpers/helpers.dart';

class _FakeAssetSource extends Fake implements AssetSource {}

void main() {
  group('GamePage', () {
    late PreloadCubit preloadCubit;
    late AudioPlayer audioPlayer;

    setUp(() {
      preloadCubit = MockPreloadCubit();
      when(() => preloadCubit.audio).thenReturn(AudioCache());

      audioPlayer = MockAudioPlayer();
      when(audioPlayer.dispose).thenAnswer((_) async {});
      when(() => audioPlayer.setReleaseMode(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setSource(any())).thenAnswer((_) async {});
      when(audioPlayer.resume).thenAnswer((_) async {});
      when(audioPlayer.pause).thenAnswer((_) async {});
    });

    setUpAll(() {
      registerFallbackValue(_FakeAssetSource());
      registerFallbackValue(ReleaseMode.loop);
    });

    testWidgets('is routable', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.of(context).push(GamePage.route()),
              ),
            ),
          ),
          preloadCubit: preloadCubit,
          audioPlayer: audioPlayer,
        );

        await tester.tap(find.byType(FloatingActionButton));

        await tester.pump();
        await tester.pump();

        expect(find.byType(GamePage), findsOneWidget);
      });
    });

    testWidgets('renders GameView', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          const GamePage(),
          preloadCubit: preloadCubit,
          audioPlayer: audioPlayer,
        );
        expect(find.byType(GameView), findsOneWidget);
      });
    });
  });

  group('GameView', () {
    late BackgroundMusicCubit backgroundMusicCubit;
    late VolumeCubit volumeCubit;

    setUp(() {
      backgroundMusicCubit = MockBackgroundMusicCubit();
      when(() => backgroundMusicCubit.state).thenReturn(false);
      when(backgroundMusicCubit.play).thenAnswer((_) async {});
      when(backgroundMusicCubit.pause).thenAnswer((_) async {});

      volumeCubit = MockVolumeCubit();
      whenListen(volumeCubit, const Stream<bool>.empty(), initialState: false);
    });

    testWidgets('toggles mute button correctly', (tester) async {
      final controller = StreamController<bool>();
      whenListen(volumeCubit, controller.stream, initialState: false);

      final game = TestGame();
      await tester.pumpApp(
        Material(child: GameView(game: game)),
        volumeCubit: volumeCubit,
        backgroundMusicCubit: backgroundMusicCubit,
      );

      expect(find.byIcon(Icons.volume_off), findsOneWidget);

      controller.add(true);
      await tester.pump();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);

      controller.add(false);
      await tester.pump();

      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets('calls correct method based on state', (tester) async {
      final controller = StreamController<bool>();
      when(volumeCubit.mute).thenAnswer((_) async {});
      when(volumeCubit.unmute).thenAnswer((_) async {});
      whenListen(volumeCubit, controller.stream, initialState: false);

      final game = TestGame();
      await tester.pumpApp(
        Material(child: GameView(game: game)),
        volumeCubit: volumeCubit,
        backgroundMusicCubit: backgroundMusicCubit,
      );

      await tester.tap(find.byIcon(Icons.volume_off));
      controller.add(true);
      await tester.pump();
      verify(volumeCubit.mute).called(1);
      verifyNever(volumeCubit.unmute);

      await tester.tap(find.byIcon(Icons.volume_up));
      controller.add(true);
      await tester.pump();
      verifyNever(volumeCubit.mute);
      verify(volumeCubit.unmute).called(1);
    });
  });
}
