// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_flame_game/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(const App());

      // FIXME: this is needed because of the preload cubit, can we do it better?
      await tester.pumpAndSettle(const Duration(seconds: 400));
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
