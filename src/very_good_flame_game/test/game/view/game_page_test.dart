import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GamePage', () {
    testWidgets('renders GameView', (tester) async {
      await tester.pumpApp(const GamePage());
      expect(find.byType(GameView), findsOneWidget);
    });
  });

  group('GameView', () {
    testWidgets('tapping the volume icon toggles the mute state', (tester) async {
      await tester.pumpApp(const Material(child: GameView()));

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.volume_off));
      await tester.pump();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });
}
