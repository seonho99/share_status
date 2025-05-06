// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottom_sheet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BottomSheetState {

 int get month; int get day; int get hour; int get minute; FilterColor get selectedColor; String get message; int get maxMessageLength;
/// Create a copy of BottomSheetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottomSheetStateCopyWith<BottomSheetState> get copyWith => _$BottomSheetStateCopyWithImpl<BottomSheetState>(this as BottomSheetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottomSheetState&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&(identical(other.message, message) || other.message == message)&&(identical(other.maxMessageLength, maxMessageLength) || other.maxMessageLength == maxMessageLength));
}


@override
int get hashCode => Object.hash(runtimeType,month,day,hour,minute,selectedColor,message,maxMessageLength);

@override
String toString() {
  return 'BottomSheetState(month: $month, day: $day, hour: $hour, minute: $minute, selectedColor: $selectedColor, message: $message, maxMessageLength: $maxMessageLength)';
}


}

/// @nodoc
abstract mixin class $BottomSheetStateCopyWith<$Res>  {
  factory $BottomSheetStateCopyWith(BottomSheetState value, $Res Function(BottomSheetState) _then) = _$BottomSheetStateCopyWithImpl;
@useResult
$Res call({
 int month, int day, int hour, int minute, FilterColor selectedColor, String message, int maxMessageLength
});




}
/// @nodoc
class _$BottomSheetStateCopyWithImpl<$Res>
    implements $BottomSheetStateCopyWith<$Res> {
  _$BottomSheetStateCopyWithImpl(this._self, this._then);

  final BottomSheetState _self;
  final $Res Function(BottomSheetState) _then;

/// Create a copy of BottomSheetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? day = null,Object? hour = null,Object? minute = null,Object? selectedColor = null,Object? message = null,Object? maxMessageLength = null,}) {
  return _then(BottomSheetState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,selectedColor: null == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as FilterColor,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,maxMessageLength: null == maxMessageLength ? _self.maxMessageLength : maxMessageLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


// dart format on
