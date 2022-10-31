import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  late BackgroundMusicCubit backgroundMusicCubit;

  setUp(() {
    backgroundMusicCubit = MockBackgroundMusicCubit();
    when(() => backgroundMusicCubit.state).thenReturn(false);
    when(() => backgroundMusicCubit.play()).thenAnswer((_) async {});
    when(() => backgroundMusicCubit.pause()).thenAnswer((_) async {});
  });

  group('GamePage', () {
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
          backgroundMusicCubit: backgroundMusicCubit,
        );

        await tester.tap(find.byType(FloatingActionButton));

        await tester.pump();
        await tester.pump();

        verify(() => backgroundMusicCubit.play()).called(1);

        expect(find.byType(GamePage), findsOneWidget);
      });
    });

    testWidgets('renders GameView', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(const GamePage());
        expect(find.byType(GameView), findsOneWidget);
      });
    });
  });

  group('GameView', () {
    testWidgets('tapping the volume icon when it is un-muted, mute it',
        (tester) async {
      final volumeCubit = MockVolumeCubit();
      when(() => volumeCubit.state).thenReturn(false);
      when(volumeCubit.mute).thenAnswer((_) async {});

      final game = TestGame();
      await tester.pumpApp(
        Material(child: GameView(game: game)),
        volumeCubit: volumeCubit,
        backgroundMusicCubit: backgroundMusicCubit,
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.volume_off));
      await tester.pump();

      verify(volumeCubit.mute).called(1);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('tapping the volume icon when it is muted, un-mute it',
        (tester) async {
      final volumeCubit = MockVolumeCubit();
      when(() => volumeCubit.state).thenReturn(true);
      when(volumeCubit.unmute).thenAnswer((_) async {});

      final game = TestGame();
      await tester.pumpApp(
        Material(child: GameView(game: game)),
        volumeCubit: volumeCubit,
        backgroundMusicCubit: backgroundMusicCubit,
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);

      await tester.tap(find.byIcon(Icons.volume_off));
      await tester.pump();

      verify(volumeCubit.unmute).called(1);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });
  });
}
