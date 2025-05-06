// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Status {

 String get name; DateTime get statusTime; FilterColor get colorStatus; String get statusMessage;
/// Create a copy of Status
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusCopyWith<Status> get copyWith => _$StatusCopyWithImpl<Status>(this as Status, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Status&&(identical(other.name, name) || other.name == name)&&(identical(other.statusTime, statusTime) || other.statusTime == statusTime)&&(identical(other.colorStatus, colorStatus) || other.colorStatus == colorStatus)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode => Object.hash(runtimeType,name,statusTime,colorStatus,statusMessage);

@override
String toString() {
  return 'Status(name: $name, statusTime: $statusTime, colorStatus: $colorStatus, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class $StatusCopyWith<$Res>  {
  factory $StatusCopyWith(Status value, $Res Function(Status) _then) = _$StatusCopyWithImpl;
@useResult
$Res call({
 String name, DateTime statusTime, FilterColor colorStatus, String statusMessage
});




}
/// @nodoc
class _$StatusCopyWithImpl<$Res>
    implements $StatusCopyWith<$Res> {
  _$StatusCopyWithImpl(this._self, this._then);

  final Status _self;
  final $Res Function(Status) _then;

/// Create a copy of Status
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? statusTime = null,Object? colorStatus = null,Object? statusMessage = null,}) {
  return _then(Status(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,statusTime: null == statusTime ? _self.statusTime : statusTime // ignore: cast_nullable_to_non_nullable
as DateTime,colorStatus: null == colorStatus ? _self.colorStatus : colorStatus // ignore: cast_nullable_to_non_nullable
as FilterColor,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


// dart format on
