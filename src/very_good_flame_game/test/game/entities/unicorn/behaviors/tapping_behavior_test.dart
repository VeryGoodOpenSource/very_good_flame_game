// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(TestGame.new);

  group('TappingBehavior', () {
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
        expect(unicorn.animation.currentIndex, equals(1));
        expect(unicorn.isAnimationPlaying(), equals(true));
      },
    );
  });
}
