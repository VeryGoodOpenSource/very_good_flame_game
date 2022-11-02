import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({required AudioCache audioCache})
      : effectPlayer = AudioPlayer()..audioCache = audioCache,
        bgm = Bgm(audioCache: audioCache),
        super(const AudioState());

  AudioCubit.test({
    required this.effectPlayer,
    required this.bgm,
  }) : super(const AudioState());

  final AudioPlayer effectPlayer;

  final Bgm bgm;

  void changeVolume(double volume) {
    effectPlayer.setVolume(volume);
    bgm.audioPlayer.setVolume(volume);
    if (!isClosed) {
      emit(state.copyWith(volume: volume));
    }
  }

  void mute() => changeVolume(0);

  void unmute() => changeVolume(1);

  @override
  Future<void> close() {
    effectPlayer.dispose();
    bgm.dispose();
    return super.close();
  }
}

class AudioState extends Equatable {
  const AudioState({this.volume = 1});
  final double volume;

  AudioState copyWith({double? volume}) {
    return AudioState(volume: volume ?? this.volume);
  }

  @override
  List<Object> get props => [volume];
}
