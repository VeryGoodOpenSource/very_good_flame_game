// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/game/game.dart';

import 'package:very_good_flame_game/title/title.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TitlePage', () {
    testWidgets('renders TitleView', (tester) async {
      await tester.pumpApp(const TitlePage());
      expect(find.byType(TitleView), findsOneWidget);
    });
  });

  group('TitleView', () {
    testWidgets('renders start button', (tester) async {
      await tester.pumpApp(const TitleView());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('starts the game when start button is tapped', (tester) async {
      await tester.pumpApp(const TitleView());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(GamePage), findsOneWidget);
    });
  });
}
