import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VolumeCubit extends Cubit<bool> {
  VolumeCubit(this._audioPlayer) : super(false);

  final AudioPlayer _audioPlayer;

  Future<void> mute() async {
    await _audioPlayer.setVolume(0);
    if (!isClosed) {
      emit(true);
    }
  }

  Future<void> unmute() async {
    await _audioPlayer.setVolume(1);
    if (!isClosed) {
      emit(false);
    }
  }
}
