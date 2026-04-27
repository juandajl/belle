import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

enum AccountType { personal, business }

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    String? username,
    String? photoUrl,
    String? bio,
    @Default(AccountType.personal) AccountType type,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) double totalEarnings,
    @Default(0) int totalClicks,
    String? referralCode,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      username: data['username'] as String?,
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      type: AccountType.values.byName(
        data['type'] as String? ?? AccountType.personal.name,
      ),
      followersCount: data['followersCount'] as int? ?? 0,
      followingCount: data['followingCount'] as int? ?? 0,
      totalEarnings: (data['totalEarnings'] as num?)?.toDouble() ?? 0,
      totalClicks: data['totalClicks'] as int? ?? 0,
      referralCode: data['referralCode'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'username': username,
        'photoUrl': photoUrl,
        'bio': bio,
        'type': type.name,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'totalEarnings': totalEarnings,
        'totalClicks': totalClicks,
        'referralCode': referralCode,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  bool get hasCompletedOnboarding =>
      username != null && username!.trim().isNotEmpty;
}
