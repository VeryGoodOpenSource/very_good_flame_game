import 'package:equatable/equatable.dart';
import 'package:very_good_flame_game/loading/loading.dart';

/// State for [PreloadCubit].
class PreloadState extends Equatable {
  /// Create a [PreloadState] with initial conditions.
  const PreloadState.initial()
      : totalCount = 0,
        loadedCount = 0,
        currentLabel = '';

  const PreloadState._update(
    this.loadedCount,
    this.currentLabel,
    this.totalCount,
  );

  /// The total count of load phases to be completed
  final int totalCount;

  /// The count of load phases that were completed so far
  final int loadedCount;

  /// A description of what is being loaded
  final String currentLabel;

  double get progress => totalCount == 0 ? 0 : loadedCount / totalCount;

  bool get isComplete => progress == 1.0;

  PreloadState startLoading(int totalCount) {
    return PreloadState._update(0, '', totalCount);
  }

  PreloadState onStartPhase(String label) {
    return PreloadState._update(
      loadedCount,
      label,
      totalCount,
    );
  }

  PreloadState onFinishPhase() {
    return PreloadState._update(
      loadedCount + 1,
      currentLabel,
      totalCount,
    );
  }

  @override
  List<Object?> get props => [
        totalCount,
        loadedCount,
        currentLabel,
      ];
}
