import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/referral_repository.dart';
import '../domain/referral_model.dart';

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  return ReferralRepository();
});

final userReferralsProvider =
    StreamProvider.family<List<ReferralModel>, String>((ref, userId) {
  return ref.watch(referralRepositoryProvider).watchUserReferrals(userId);
});
