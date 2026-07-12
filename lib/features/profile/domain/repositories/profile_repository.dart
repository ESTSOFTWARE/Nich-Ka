import 'dart:io';
import '../entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser> getCurrentUser();
  Future<String> uploadProfileImage(File file);
  Future<ProfileUser> updateProfile({String? name, String? lastName});
}
