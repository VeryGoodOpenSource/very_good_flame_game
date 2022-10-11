import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flame/cache.dart';
import 'package:flutter/widgets.dart';
import 'package:very_good_flame_game/gen/assets.gen.dart';
import 'package:very_good_flame_game/loading/loading.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit(this.images, this.audio) : super(const PreloadState.initial());

  final Images images;
  final AudioCache audio;

  /// Load items sequentially allows display of what is being loaded
  Future<void> loadSequentially() async {
    final phases = <PreloadPhase>[
      PreloadPhase('audio', () => audio.loadAll([Assets.audio.background])),
      PreloadPhase(
        'images',
        () => images.loadAll([Assets.images.unicornAnimation.path]),
      ),
    ];

    emit(state.startLoading(phases.length));
    for (final phase in phases) {
      emit(state.onStartPhase(phase.label));
      // Throttle phases to take at least 1/5 seconds
      await Future.wait([
        Future.delayed(Duration.zero, phase.start),
        Future<void>.delayed(const Duration(milliseconds: 200)),
      ]);
      emit(state.onFinishPhase());
    }
  }
}

@immutable
class PreloadPhase {
  const PreloadPhase(this.label, this.start);

  final String label;
  final ValueGetter<Future<void>> start;
}
