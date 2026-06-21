import '../entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser> getCurrentUser();
}
