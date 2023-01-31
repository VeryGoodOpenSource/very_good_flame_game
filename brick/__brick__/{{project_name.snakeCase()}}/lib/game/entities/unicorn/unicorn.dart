import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/game/entities/unicorn/behaviors/tapping_behavior.dart';
import 'package:{{project_name.snakeCase()}}/gen/assets.gen.dart';

class Unicorn extends PositionedEntity with HasGameRef {
  Unicorn({
    required super.position,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(32),
          behaviors: [
            TappingBehavior(),
          ],
        );

  @visibleForTesting
  Unicorn.test({
    required super.position,
    super.behaviors,
  }) : super(size: Vector2.all(32));

  SpriteAnimation? _animation;

  @visibleForTesting
  SpriteAnimation get animation => _animation!;

  @override
  Future<void> onLoad() async {
    _animation = await gameRef.loadSpriteAnimation(
      Assets.images.unicornAnimation.path,
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    resetAnimation();
    animation.onComplete = resetAnimation;

    await add(SpriteAnimationComponent(animation: _animation, size: size));
  }

  /// Set the animation to the first frame by tricking the animation
  /// into thinking it finished the last frame.
  void resetAnimation() {
    animation
      ..currentIndex = _animation!.frames.length - 1
      ..update(0.1)
      ..currentIndex = 0;
  }

  /// Plays the animation.
  void playAnimation() => animation.reset();

  /// Returns whether the animation is playing or not.
  bool isAnimationPlaying() => !animation.isFirstFrame;
}
