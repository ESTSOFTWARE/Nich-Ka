import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/session/current_user_avatar.dart';
import '../../data/datasource/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/upload_profile_image_use_case.dart';
import '../states/ui_state.dart';
import 'profile_state.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  final ImagePicker _picker = ImagePicker();
  final nameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  late final GetProfileUseCase _getProfile;
  late final UploadProfileImageUseCase _uploadImage;

  @override
  ProfileState build() {
    final repo = ProfileRepositoryImpl(
      ProfileRemoteDataSource(HttpClient.instance),
    );
    _getProfile = GetProfileUseCase(repo);
    _uploadImage = UploadProfileImageUseCase(repo);
    ref.onDispose(() {
      nameCtrl.dispose();
      lastNameCtrl.dispose();
      phoneCtrl.dispose();
      descriptionCtrl.dispose();
    });
    Future.microtask(loadProfile);
    return const ProfileState();
  }

  void setDialCode(String v) => state = state.copyWith(dialCode: v);

  void startEditing() {
    final u = state.user;
    if (u == null) return;
    nameCtrl.text = u.firstName;
    lastNameCtrl.text = u.lastName;
    phoneCtrl.text = u.phoneNumber ?? '';
    descriptionCtrl.text = u.description ?? '';
    state = state.copyWith(dialCode: u.dialCode ?? '+52', editingInfo: true);
  }

  void cancelEditing() =>
      state = state.copyWith(editingInfo: false, uploadError: null);

  Future<void> loadProfile() async {
    state = state.copyWith(profileState: const UiLoading());
    try {
      final u = await _getProfile();
      CurrentUserAvatar.instance.value = u.profileImage;
      state = state.copyWith(profileState: UiSuccess(u));
    } catch (e) {
      state = state.copyWith(
        profileState: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<bool> saveEditing() async {
    state = state.copyWith(isSaving: true, uploadError: null);
    try {
      final repo = ProfileRepositoryImpl(
        ProfileRemoteDataSource(HttpClient.instance),
      );
      // El backend exige dial_code y phone_number JUNTOS o ambos omitidos.
      final phone = phoneCtrl.text.trim();
      final updated = await repo.updateProfile(
        name: nameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        dialCode: phone.isEmpty ? null : state.dialCode,
        phoneNumber: phone.isEmpty ? null : phone,
        description: descriptionCtrl.text.trim().isEmpty
            ? null
            : descriptionCtrl.text.trim(),
      );
      CurrentUserAvatar.instance.value = updated.profileImage;
      state = state.copyWith(
        profileState: UiSuccess(updated),
        editingInfo: false,
        isSaving: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        uploadError: e.toString().replaceFirst('Exception: ', ''),
        isSaving: false,
      );
      return false;
    }
  }

  Future<void> pickAndUploadPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    state = state.copyWith(isUploading: true, uploadError: null);
    try {
      final url = await _uploadImage(File(picked.path));
      CurrentUserAvatar.instance.value = url;
      final current = state.user;
      if (current != null) {
        state = state.copyWith(
          profileState: UiSuccess(
            ProfileUser(
              firstName: current.firstName,
              lastName: current.lastName,
              email: current.email,
              role: current.role,
              circuit: current.circuit,
              memberSince: current.memberSince,
              profileImage: url,
              dialCode: current.dialCode,
              phoneNumber: current.phoneNumber,
              description: current.description,
            ),
          ),
          isUploading: false,
        );
      } else {
        state = state.copyWith(isUploading: false);
      }
    } catch (e) {
      state = state.copyWith(
        uploadError: e.toString().replaceFirst('Exception: ', ''),
        isUploading: false,
      );
    }
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
