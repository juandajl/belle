// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PostItem {
  String get id => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get shopUrl => throw _privateConstructorUsedError;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostItemCopyWith<PostItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostItemCopyWith<$Res> {
  factory $PostItemCopyWith(PostItem value, $Res Function(PostItem) then) =
      _$PostItemCopyWithImpl<$Res, PostItem>;
  @useResult
  $Res call({
    String id,
    double x,
    double y,
    String? name,
    String? brand,
    double? price,
    String currency,
    String? shopUrl,
  });
}

/// @nodoc
class _$PostItemCopyWithImpl<$Res, $Val extends PostItem>
    implements $PostItemCopyWith<$Res> {
  _$PostItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? name = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? currency = null,
    Object? shopUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            shopUrl: freezed == shopUrl
                ? _value.shopUrl
                : shopUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostItemImplCopyWith<$Res>
    implements $PostItemCopyWith<$Res> {
  factory _$$PostItemImplCopyWith(
    _$PostItemImpl value,
    $Res Function(_$PostItemImpl) then,
  ) = __$$PostItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double x,
    double y,
    String? name,
    String? brand,
    double? price,
    String currency,
    String? shopUrl,
  });
}

/// @nodoc
class __$$PostItemImplCopyWithImpl<$Res>
    extends _$PostItemCopyWithImpl<$Res, _$PostItemImpl>
    implements _$$PostItemImplCopyWith<$Res> {
  __$$PostItemImplCopyWithImpl(
    _$PostItemImpl _value,
    $Res Function(_$PostItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? name = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? currency = null,
    Object? shopUrl = freezed,
  }) {
    return _then(
      _$PostItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        shopUrl: freezed == shopUrl
            ? _value.shopUrl
            : shopUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PostItemImpl extends _PostItem {
  const _$PostItemImpl({
    required this.id,
    required this.x,
    required this.y,
    this.name,
    this.brand,
    this.price,
    this.currency = 'USD',
    this.shopUrl,
  }) : super._();

  @override
  final String id;
  @override
  final double x;
  @override
  final double y;
  @override
  final String? name;
  @override
  final String? brand;
  @override
  final double? price;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? shopUrl;

  @override
  String toString() {
    return 'PostItem(id: $id, x: $x, y: $y, name: $name, brand: $brand, price: $price, currency: $currency, shopUrl: $shopUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.shopUrl, shopUrl) || other.shopUrl == shopUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, x, y, name, brand, price, currency, shopUrl);

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostItemImplCopyWith<_$PostItemImpl> get copyWith =>
      __$$PostItemImplCopyWithImpl<_$PostItemImpl>(this, _$identity);
}

abstract class _PostItem extends PostItem {
  const factory _PostItem({
    required final String id,
    required final double x,
    required final double y,
    final String? name,
    final String? brand,
    final double? price,
    final String currency,
    final String? shopUrl,
  }) = _$PostItemImpl;
  const _PostItem._() : super._();

  @override
  String get id;
  @override
  double get x;
  @override
  double get y;
  @override
  String? get name;
  @override
  String? get brand;
  @override
  double? get price;
  @override
  String get currency;
  @override
  String? get shopUrl;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostItemImplCopyWith<_$PostItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get authorUsername => throw _privateConstructorUsedError;
  String? get authorPhotoUrl => throw _privateConstructorUsedError;
  String get mediaUrl => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  List<String> get hashtags => throw _privateConstructorUsedError;
  List<PostItem> get items => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  int get savesCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? authorUsername,
    String? authorPhotoUrl,
    String mediaUrl,
    MediaType mediaType,
    String? caption,
    List<String> hashtags,
    List<PostItem> items,
    int likesCount,
    int commentsCount,
    int savesCount,
    DateTime createdAt,
  });
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? authorUsername = freezed,
    Object? authorPhotoUrl = freezed,
    Object? mediaUrl = null,
    Object? mediaType = null,
    Object? caption = freezed,
    Object? hashtags = null,
    Object? items = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? savesCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorUsername: freezed == authorUsername
                ? _value.authorUsername
                : authorUsername // ignore: cast_nullable_to_non_nullable
                      as String?,
            authorPhotoUrl: freezed == authorPhotoUrl
                ? _value.authorPhotoUrl
                : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaUrl: null == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as MediaType,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            hashtags: null == hashtags
                ? _value.hashtags
                : hashtags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PostItem>,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentsCount: null == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            savesCount: null == savesCount
                ? _value.savesCount
                : savesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
    _$PostModelImpl value,
    $Res Function(_$PostModelImpl) then,
  ) = __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? authorUsername,
    String? authorPhotoUrl,
    String mediaUrl,
    MediaType mediaType,
    String? caption,
    List<String> hashtags,
    List<PostItem> items,
    int likesCount,
    int commentsCount,
    int savesCount,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
    _$PostModelImpl _value,
    $Res Function(_$PostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? authorUsername = freezed,
    Object? authorPhotoUrl = freezed,
    Object? mediaUrl = null,
    Object? mediaType = null,
    Object? caption = freezed,
    Object? hashtags = null,
    Object? items = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? savesCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$PostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorUsername: freezed == authorUsername
            ? _value.authorUsername
            : authorUsername // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorPhotoUrl: freezed == authorPhotoUrl
            ? _value.authorPhotoUrl
            : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaUrl: null == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as MediaType,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        hashtags: null == hashtags
            ? _value._hashtags
            : hashtags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PostItem>,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentsCount: null == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        savesCount: null == savesCount
            ? _value.savesCount
            : savesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PostModelImpl extends _PostModel {
  const _$PostModelImpl({
    required this.id,
    required this.userId,
    this.authorUsername,
    this.authorPhotoUrl,
    required this.mediaUrl,
    this.mediaType = MediaType.photo,
    this.caption,
    final List<String> hashtags = const <String>[],
    final List<PostItem> items = const <PostItem>[],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.savesCount = 0,
    required this.createdAt,
  }) : _hashtags = hashtags,
       _items = items,
       super._();

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? authorUsername;
  @override
  final String? authorPhotoUrl;
  @override
  final String mediaUrl;
  @override
  @JsonKey()
  final MediaType mediaType;
  @override
  final String? caption;
  final List<String> _hashtags;
  @override
  @JsonKey()
  List<String> get hashtags {
    if (_hashtags is EqualUnmodifiableListView) return _hashtags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hashtags);
  }

  final List<PostItem> _items;
  @override
  @JsonKey()
  List<PostItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final int savesCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, authorUsername: $authorUsername, authorPhotoUrl: $authorPhotoUrl, mediaUrl: $mediaUrl, mediaType: $mediaType, caption: $caption, hashtags: $hashtags, items: $items, likesCount: $likesCount, commentsCount: $commentsCount, savesCount: $savesCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorPhotoUrl, authorPhotoUrl) ||
                other.authorPhotoUrl == authorPhotoUrl) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other._hashtags, _hashtags) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.savesCount, savesCount) ||
                other.savesCount == savesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    authorUsername,
    authorPhotoUrl,
    mediaUrl,
    mediaType,
    caption,
    const DeepCollectionEquality().hash(_hashtags),
    const DeepCollectionEquality().hash(_items),
    likesCount,
    commentsCount,
    savesCount,
    createdAt,
  );

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);
}

abstract class _PostModel extends PostModel {
  const factory _PostModel({
    required final String id,
    required final String userId,
    final String? authorUsername,
    final String? authorPhotoUrl,
    required final String mediaUrl,
    final MediaType mediaType,
    final String? caption,
    final List<String> hashtags,
    final List<PostItem> items,
    final int likesCount,
    final int commentsCount,
    final int savesCount,
    required final DateTime createdAt,
  }) = _$PostModelImpl;
  const _PostModel._() : super._();

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get authorUsername;
  @override
  String? get authorPhotoUrl;
  @override
  String get mediaUrl;
  @override
  MediaType get mediaType;
  @override
  String? get caption;
  @override
  List<String> get hashtags;
  @override
  List<PostItem> get items;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  int get savesCount;
  @override
  DateTime get createdAt;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
