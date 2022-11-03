// Copyright (c) {{current_year}}, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{project_name.snakeCase()}}/loading/loading.dart';

class MockPreloadCubit extends MockCubit<PreloadState> implements PreloadCubit {
}

class MockAudioCache extends Mock implements AudioCache {}
