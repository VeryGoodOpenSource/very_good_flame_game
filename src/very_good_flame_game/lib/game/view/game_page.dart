import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) {
            return BackgroundMusicCubit(context.read<AudioPlayer>());
          },
        ),
        BlocProvider(
          lazy: false,
          create: (context) => VolumeCubit(context.read<AudioPlayer>()),
        ),
      ],
      child: const Scaffold(
        body: SafeArea(child: GameView()),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key, this.game});

  final FlameGame? game;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FlameGame? _game;

  late final BackgroundMusicCubit _backgroundMusicCubit;

  @override
  void initState() {
    super.initState();
    _backgroundMusicCubit = context.read<BackgroundMusicCubit>()..play();
  }

  @override
  void dispose() {
    _backgroundMusicCubit.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _game ??= widget.game ?? VeryGoodFlameGame(l10n: context.l10n);
    return Stack(
      children: [
        Positioned.fill(child: GameWidget(game: _game!)),
        Align(
          alignment: Alignment.topRight,
          child: BlocBuilder<VolumeCubit, bool>(
            builder: (context, muted) {
              return IconButton(
                icon: Icon(muted ? Icons.volume_up : Icons.volume_off),
                onPressed: () async {
                  if (muted) {
                    return context.read<VolumeCubit>().unmute();
                  }
                  return context.read<VolumeCubit>().mute();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
