import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:{{project_name.snakeCase()}}/game/game.dart';

class CounterComponent extends PositionComponent
    with HasGameRef<VeryGoodFlameGame> {
  CounterComponent({
    required super.position,
  }) : super(anchor: Anchor.center);

  late final TextComponent text;

  @override
  Future<void> onLoad() async {
    await add(
      text = TextComponent(
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 4,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    text.text = gameRef.l10n.counterText(gameRef.counter);
  }
}
