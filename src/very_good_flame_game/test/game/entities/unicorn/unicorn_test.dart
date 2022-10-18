// ignore_for_file: cascade_invocations

import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(TestGame.new);

  group('Unicorn', () {
    flameTester.test('has all behaviors', (game) async {
      final unicorn = Unicorn(position: Vector2.all(1));
      await game.ensureAdd(unicorn);

      expect(unicorn.findBehavior<TappingBehavior>(), isNotNull);
    });

    flameTester.test('loads correctly', (game) async {
      final unicorn = Unicorn(position: Vector2.all(1));
      await game.ensureAdd(unicorn);

      expect(unicorn.isAnimationPlaying(), equals(false));
    });

    group('animation', () {
      flameTester.test('plays animation', (game) async {
        final unicorn = Unicorn.test(position: Vector2.all(1));
        await game.ensureAdd(unicorn);

        unicorn.playAnimation();
        expect(unicorn.animation.currentIndex, equals(0));

        game.update(0.1);

        expect(unicorn.animation.currentIndex, equals(1));
        expect(unicorn.isAnimationPlaying(), equals(true));
      });

      flameTester.test(
        'reset animation back to frame one and stops it',
        (game) async {
          final unicorn = Unicorn.test(position: Vector2.all(1));
          await game.ensureAdd(unicorn);

          unicorn.playAnimation();
          game.update(0.1);
          expect(unicorn.animation.currentIndex, equals(1));
          expect(unicorn.isAnimationPlaying(), equals(true));

          unicorn.resetAnimation();
          expect(unicorn.isAnimationPlaying(), equals(false));
          expect(unicorn.animation.currentIndex, equals(0));

          game.update(0.1);
          expect(unicorn.animation.currentIndex, equals(0));
          expect(unicorn.isAnimationPlaying(), equals(false));
        },
      );
    });
  });
}
