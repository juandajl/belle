// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReferralModel {
  String get id => throw _privateConstructorUsedError;
  String get referrerUserId => throw _privateConstructorUsedError;
  String get clickedByUserId => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get shopUrl => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  String? get itemBrand => throw _privateConstructorUsedError;
  double? get itemPrice => throw _privateConstructorUsedError;
  String? get itemCurrency => throw _privateConstructorUsedError;
  bool get converted => throw _privateConstructorUsedError;
  double get earnings => throw _privateConstructorUsedError;
  DateTime get clickedAt => throw _privateConstructorUsedError;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralModelCopyWith<ReferralModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralModelCopyWith<$Res> {
  factory $ReferralModelCopyWith(
    ReferralModel value,
    $Res Function(ReferralModel) then,
  ) = _$ReferralModelCopyWithImpl<$Res, ReferralModel>;
  @useResult
  $Res call({
    String id,
    String referrerUserId,
    String clickedByUserId,
    String postId,
    String itemId,
    String shopUrl,
    String? itemName,
    String? itemBrand,
    double? itemPrice,
    String? itemCurrency,
    bool converted,
    double earnings,
    DateTime clickedAt,
  });
}

/// @nodoc
class _$ReferralModelCopyWithImpl<$Res, $Val extends ReferralModel>
    implements $ReferralModelCopyWith<$Res> {
  _$ReferralModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerUserId = null,
    Object? clickedByUserId = null,
    Object? postId = null,
    Object? itemId = null,
    Object? shopUrl = null,
    Object? itemName = freezed,
    Object? itemBrand = freezed,
    Object? itemPrice = freezed,
    Object? itemCurrency = freezed,
    Object? converted = null,
    Object? earnings = null,
    Object? clickedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            referrerUserId: null == referrerUserId
                ? _value.referrerUserId
                : referrerUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            clickedByUserId: null == clickedByUserId
                ? _value.clickedByUserId
                : clickedByUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as String,
            shopUrl: null == shopUrl
                ? _value.shopUrl
                : shopUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemBrand: freezed == itemBrand
                ? _value.itemBrand
                : itemBrand // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemPrice: freezed == itemPrice
                ? _value.itemPrice
                : itemPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            itemCurrency: freezed == itemCurrency
                ? _value.itemCurrency
                : itemCurrency // ignore: cast_nullable_to_non_nullable
                      as String?,
            converted: null == converted
                ? _value.converted
                : converted // ignore: cast_nullable_to_non_nullable
                      as bool,
            earnings: null == earnings
                ? _value.earnings
                : earnings // ignore: cast_nullable_to_non_nullable
                      as double,
            clickedAt: null == clickedAt
                ? _value.clickedAt
                : clickedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReferralModelImplCopyWith<$Res>
    implements $ReferralModelCopyWith<$Res> {
  factory _$$ReferralModelImplCopyWith(
    _$ReferralModelImpl value,
    $Res Function(_$ReferralModelImpl) then,
  ) = __$$ReferralModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String referrerUserId,
    String clickedByUserId,
    String postId,
    String itemId,
    String shopUrl,
    String? itemName,
    String? itemBrand,
    double? itemPrice,
    String? itemCurrency,
    bool converted,
    double earnings,
    DateTime clickedAt,
  });
}

/// @nodoc
class __$$ReferralModelImplCopyWithImpl<$Res>
    extends _$ReferralModelCopyWithImpl<$Res, _$ReferralModelImpl>
    implements _$$ReferralModelImplCopyWith<$Res> {
  __$$ReferralModelImplCopyWithImpl(
    _$ReferralModelImpl _value,
    $Res Function(_$ReferralModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerUserId = null,
    Object? clickedByUserId = null,
    Object? postId = null,
    Object? itemId = null,
    Object? shopUrl = null,
    Object? itemName = freezed,
    Object? itemBrand = freezed,
    Object? itemPrice = freezed,
    Object? itemCurrency = freezed,
    Object? converted = null,
    Object? earnings = null,
    Object? clickedAt = null,
  }) {
    return _then(
      _$ReferralModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        referrerUserId: null == referrerUserId
            ? _value.referrerUserId
            : referrerUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        clickedByUserId: null == clickedByUserId
            ? _value.clickedByUserId
            : clickedByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String,
        shopUrl: null == shopUrl
            ? _value.shopUrl
            : shopUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemBrand: freezed == itemBrand
            ? _value.itemBrand
            : itemBrand // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemPrice: freezed == itemPrice
            ? _value.itemPrice
            : itemPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        itemCurrency: freezed == itemCurrency
            ? _value.itemCurrency
            : itemCurrency // ignore: cast_nullable_to_non_nullable
                  as String?,
        converted: null == converted
            ? _value.converted
            : converted // ignore: cast_nullable_to_non_nullable
                  as bool,
        earnings: null == earnings
            ? _value.earnings
            : earnings // ignore: cast_nullable_to_non_nullable
                  as double,
        clickedAt: null == clickedAt
            ? _value.clickedAt
            : clickedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ReferralModelImpl extends _ReferralModel {
  const _$ReferralModelImpl({
    required this.id,
    required this.referrerUserId,
    required this.clickedByUserId,
    required this.postId,
    required this.itemId,
    required this.shopUrl,
    this.itemName,
    this.itemBrand,
    this.itemPrice,
    this.itemCurrency,
    this.converted = false,
    this.earnings = 0,
    required this.clickedAt,
  }) : super._();

  @override
  final String id;
  @override
  final String referrerUserId;
  @override
  final String clickedByUserId;
  @override
  final String postId;
  @override
  final String itemId;
  @override
  final String shopUrl;
  @override
  final String? itemName;
  @override
  final String? itemBrand;
  @override
  final double? itemPrice;
  @override
  final String? itemCurrency;
  @override
  @JsonKey()
  final bool converted;
  @override
  @JsonKey()
  final double earnings;
  @override
  final DateTime clickedAt;

  @override
  String toString() {
    return 'ReferralModel(id: $id, referrerUserId: $referrerUserId, clickedByUserId: $clickedByUserId, postId: $postId, itemId: $itemId, shopUrl: $shopUrl, itemName: $itemName, itemBrand: $itemBrand, itemPrice: $itemPrice, itemCurrency: $itemCurrency, converted: $converted, earnings: $earnings, clickedAt: $clickedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referrerUserId, referrerUserId) ||
                other.referrerUserId == referrerUserId) &&
            (identical(other.clickedByUserId, clickedByUserId) ||
                other.clickedByUserId == clickedByUserId) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.shopUrl, shopUrl) || other.shopUrl == shopUrl) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.itemBrand, itemBrand) ||
                other.itemBrand == itemBrand) &&
            (identical(other.itemPrice, itemPrice) ||
                other.itemPrice == itemPrice) &&
            (identical(other.itemCurrency, itemCurrency) ||
                other.itemCurrency == itemCurrency) &&
            (identical(other.converted, converted) ||
                other.converted == converted) &&
            (identical(other.earnings, earnings) ||
                other.earnings == earnings) &&
            (identical(other.clickedAt, clickedAt) ||
                other.clickedAt == clickedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    referrerUserId,
    clickedByUserId,
    postId,
    itemId,
    shopUrl,
    itemName,
    itemBrand,
    itemPrice,
    itemCurrency,
    converted,
    earnings,
    clickedAt,
  );

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralModelImplCopyWith<_$ReferralModelImpl> get copyWith =>
      __$$ReferralModelImplCopyWithImpl<_$ReferralModelImpl>(this, _$identity);
}

abstract class _ReferralModel extends ReferralModel {
  const factory _ReferralModel({
    required final String id,
    required final String referrerUserId,
    required final String clickedByUserId,
    required final String postId,
    required final String itemId,
    required final String shopUrl,
    final String? itemName,
    final String? itemBrand,
    final double? itemPrice,
    final String? itemCurrency,
    final bool converted,
    final double earnings,
    required final DateTime clickedAt,
  }) = _$ReferralModelImpl;
  const _ReferralModel._() : super._();

  @override
  String get id;
  @override
  String get referrerUserId;
  @override
  String get clickedByUserId;
  @override
  String get postId;
  @override
  String get itemId;
  @override
  String get shopUrl;
  @override
  String? get itemName;
  @override
  String? get itemBrand;
  @override
  double? get itemPrice;
  @override
  String? get itemCurrency;
  @override
  bool get converted;
  @override
  double get earnings;
  @override
  DateTime get clickedAt;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralModelImplCopyWith<_$ReferralModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
