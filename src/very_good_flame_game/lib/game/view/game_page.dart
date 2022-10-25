import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:very_good_flame_game/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: GameView()),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key, this.game});

  final Game? game;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late Game _game;

  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _game = widget.game ?? VeryGoodFlameGame();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GameWidget(game: _game)),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(_muted ? Icons.volume_up : Icons.volume_off),
            onPressed: () => setState(() => _muted = !_muted),
          ),
        ),
      ],
    );
  }
}
