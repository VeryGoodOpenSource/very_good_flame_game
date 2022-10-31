import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:very_good_flame_game/app/app.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';
import 'package:very_good_flame_game/loading/loading.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    MockNavigator? navigator,
    PreloadCubit? preloadCubit,
    AudioPlayer? audioPlayer,
    BackgroundMusicCubit? backgroundMusicCubit,
    VolumeCubit? volumeCubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: audioPlayer ?? MockAudioPlayer(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: preloadCubit ?? MockPreloadCubit()),
            BlocProvider.value(
              value: backgroundMusicCubit ?? MockBackgroundMusicCubit(),
            ),
            BlocProvider.value(value: volumeCubit ?? MockVolumeCubit()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: navigator != null
                ? MockNavigatorProvider(navigator: navigator, child: widget)
                : widget,
          ),
        ),
      ),
    );
  }
}
