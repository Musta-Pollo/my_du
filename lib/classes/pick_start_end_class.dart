import 'dart:math' as math;

import 'package:divelit_task/extensions/datetime_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_start_end_class.freezed.dart';

enum SliderMode {
  /// Means that when the user started to drag the slider,
  /// the start time was before now. And the end time will be changed on drag
  startBeforeNow,

  /// Means that when the user started to drag the slider,
  /// the start time was after now. And the start time will be changed on drag
  startAfterNow,

  /// Means that the slider is not active
  nothing;
}

@freezed
class PickStartEndClass with _$PickStartEndClass {
  factory PickStartEndClass({
    required DateTime start,
    required DateTime end,
    @Default(SliderMode.nothing) SliderMode sliderMode,
  }) = _PickStartEndClass;

  PickStartEndClass._();

  String get desc {
    final now = DateTime.now().truncateToMinute;
    final isStartBeforeNow = start.isBefore(now);
    final d = switch ((
      sliderMode,
      isStartBeforeNow,
    )) {
      (SliderMode.nothing, true) => "By dragging you will move the end time",
      (SliderMode.nothing, false) => "By dragging you will move the start time",
      (SliderMode.startBeforeNow, _) => "You are moving the end time",
      (SliderMode.startAfterNow, _) => "You are moving the start time",
    };
    return d;
  }

  Duration get duration => end.difference(start);

  double get percentage {
    final now = DateTime.now().truncateToMinute;

    if (start.isBefore(now)) {
      final diff = start.difference(now).abs();
      final endDiff = end.difference(start).abs();
      final res = diff.inMicroseconds / endDiff.inMicroseconds;
      // Just in case
      return math.min(1.0, res);
    }
    return 0.0;
  }
}
