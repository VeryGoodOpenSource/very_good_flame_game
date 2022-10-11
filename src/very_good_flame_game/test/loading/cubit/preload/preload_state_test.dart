import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/loading/loading.dart';

void main() {
  group('PreloadState', () {
    test('initial', () {
      const state = PreloadState.initial();
      expect(state.totalCount, 0);
      expect(state.loadedCount, 0);
      expect(state.currentLabel, '');
    });

    test('startLoading', () {
      final state = const PreloadState.initial().startLoading(2);
      expect(state.totalCount, 2);
      expect(state.loadedCount, 0);
      expect(state.currentLabel, '');
    });

    test('onStartPhase', () {
      final state = const PreloadState.initial()
          .startLoading(2)
          .onStartPhase('some phase');
      expect(state.totalCount, 2);
      expect(state.loadedCount, 0);
      expect(state.currentLabel, 'some phase');
    });

    test('onFinishPhase', () {
      final state = const PreloadState.initial()
          .startLoading(2)
          .onStartPhase('some phase')
          .onFinishPhase();
      expect(state.totalCount, 2);
      expect(state.loadedCount, 1);
      expect(state.currentLabel, 'some phase');
    });

    group('progress', () {
      test('when not started is zero', () {
        const state = PreloadState.initial();
        expect(state.progress, 0);
      });

      test('after started', () {
        final state =
            const PreloadState.initial().startLoading(2).onFinishPhase();
        expect(state.progress, 0.5);
      });
    });

    group('isComplete', () {
      test('when not started is zero', () {
        const state = PreloadState.initial();
        expect(state.isComplete, false);
      });

      test('after started', () {
        final state =
            const PreloadState.initial().startLoading(2).onFinishPhase();
        expect(state.isComplete, false);

        final stateComplete = state.onFinishPhase();
        expect(stateComplete.isComplete, true);
      });
    });
  });
}
