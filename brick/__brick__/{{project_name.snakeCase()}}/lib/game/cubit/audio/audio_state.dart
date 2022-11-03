// Copyright (c) {{current_year}}, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'audio_cubit.dart';

class AudioState extends Equatable {
  const AudioState({this.volume = 1});
  final double volume;

  AudioState copyWith({double? volume}) {
    return AudioState(volume: volume ?? this.volume);
  }

  @override
  List<Object> get props => [volume];
}
