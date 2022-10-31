import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_flame_game/gen/assets.gen.dart';

class BackgroundMusicCubit extends Cubit<bool> {
  BackgroundMusicCubit(AudioPlayer audioPlayer)
      : bgm = Bgm()..audioPlayer = audioPlayer,
        super(false);

  final Bgm bgm;

  Future<void> play() async {
    await bgm.play(Assets.audio.background);
    emit(true);
  }

  Future<void> pause() async {
    await bgm.pause();
    emit(false);
  }
}
