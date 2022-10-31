import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/loading/loading.dart';

class MockPreloadCubit extends MockCubit<PreloadState> implements PreloadCubit {
}

class MockBackgroundMusicCubit extends MockCubit<bool>
    implements BackgroundMusicCubit {}

class MockVolumeCubit extends MockCubit<bool> implements VolumeCubit {}

class MockAudioCache extends Mock implements AudioCache {}

class MockAudioPlayer extends Mock implements AudioPlayer {}
