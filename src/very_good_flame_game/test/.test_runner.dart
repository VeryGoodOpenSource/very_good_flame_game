// GENERATED CODE - DO NOT MODIFY BY HAND
// Consider adding this file to your .gitignore.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';


import 'loading/cubit/preload/preload_state_test.dart' as loading_cubit_preload_preload_state_test_dart;
import 'loading/cubit/preload/preload_cubit_test.dart' as loading_cubit_preload_preload_cubit_test_dart;
import 'loading/view/loading_page_test.dart' as loading_view_loading_page_test_dart;
import 'app/view/app_test.dart' as app_view_app_test_dart;
import 'title/view/title_page_test.dart' as title_view_title_page_test_dart;

void main() {
  goldenFileComparator = _TestOptimizationAwareGoldenFileComparator();
  group('loading_cubit_preload_preload_state_test_dart', loading_cubit_preload_preload_state_test_dart.main);
  group('loading_cubit_preload_preload_cubit_test_dart', loading_cubit_preload_preload_cubit_test_dart.main);
  group('loading_view_loading_page_test_dart', loading_view_loading_page_test_dart.main);
  group('app_view_app_test_dart', app_view_app_test_dart.main);
  group('title_view_title_page_test_dart', title_view_title_page_test_dart.main);
}


class _TestOptimizationAwareGoldenFileComparator extends LocalFileComparator {
  final List<String> goldenFilePaths;

  _TestOptimizationAwareGoldenFileComparator()
      : goldenFilePaths = _goldenFilePaths,
        super(_testFile);

  static Uri get _testFile {
    final basedir =
        (goldenFileComparator as LocalFileComparator).basedir.toString();
    return Uri.parse("$basedir/.test_runner.dart");
  }

  static List<String> get _goldenFilePaths =>
      Directory.fromUri((goldenFileComparator as LocalFileComparator).basedir)
          .listSync(recursive: true, followLinks: true)
          .whereType<File>()
          .map((file) => file.path)
          .where((path) => path.endsWith('.png'))
          .toList();

  @override
  Uri getTestUri(Uri key, int? version) {
    final keyString = key.path;
    return Uri.parse(goldenFilePaths
        .singleWhere((goldenFilePath) => goldenFilePath.endsWith(keyString)));
  }
}
