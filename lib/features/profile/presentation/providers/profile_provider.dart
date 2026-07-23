import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/network/http_client.dart';
import '../../../../core/session/current_user_avatar.dart';
import '../../data/datasource/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/upload_profile_image_use_case.dart';
import '../states/ui_state.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfile;
  final UploadProfileImageUseCase _uploadImage;
  final ImagePicker _picker = ImagePicker();

  UiState<ProfileUser> _state = const UiIdle();
  UiState<ProfileUser> get state => _state;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _uploadError;
  String? get uploadError => _uploadError;

  // ── Edición inline ────────────────────────────────────────────
  bool _editingInfo = false;
  bool get editingInfo => _editingInfo;

  final nameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String _dialCode = '+52';
  String get dialCode => _dialCode;

  void setDialCode(String v) {
    _dialCode = v;
    notifyListeners();
  }

  void startEditing() {
    final u = user;
    if (u == null) return;
    nameCtrl.text = u.firstName;
    lastNameCtrl.text = u.lastName;
    phoneCtrl.text = u.phoneNumber ?? '';
    descriptionCtrl.text = u.description ?? '';
    _dialCode = u.dialCode ?? '+52';
    _editingInfo = true;
    notifyListeners();
  }

  void cancelEditing() {
    _editingInfo = false;
    _uploadError = null;
    notifyListeners();
  }
  // ─────────────────────────────────────────────────────────────

  ProfileUser? get user => switch (_state) {
    UiSuccess<ProfileUser> s => s.data,
    _ => null,
  };

  bool get isGoogleLinked => true;

  ProfileProvider({
    GetProfileUseCase? getProfile,
    UploadProfileImageUseCase? uploadImage,
  }) : _getProfile =
           getProfile ??
           GetProfileUseCase(
             ProfileRepositoryImpl(
               ProfileRemoteDataSource(HttpClient.instance),
             ),
           ),
       _uploadImage =
           uploadImage ??
           UploadProfileImageUseCase(
             ProfileRepositoryImpl(
               ProfileRemoteDataSource(HttpClient.instance),
             ),
           ) {
    _init();
  }

  Future<void> _init() async {
    await Future.microtask(loadProfile);
  }

  void _setState(UiState<ProfileUser> state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _setState(const UiLoading());
    try {
      final u = await _getProfile();
      CurrentUserAvatar.instance.value = u.profileImage;
      _setState(UiSuccess(u));
    } catch (e) {
      _setState(UiError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<bool> saveEditing() async {
    _isSaving = true;
    _uploadError = null;
    notifyListeners();
    try {
      final repo = ProfileRepositoryImpl(
        ProfileRemoteDataSource(HttpClient.instance),
      );
      // El backend exige dial_code y phone_number JUNTOS o ambos omitidos:
      // mandar solo el dial (sin teléfono) hacía fallar todo el update,
      // incluida la descripción.
      final phone = phoneCtrl.text.trim();
      final updated = await repo.updateProfile(
        name: nameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        dialCode: phone.isEmpty ? null : _dialCode,
        phoneNumber: phone.isEmpty ? null : phone,
        description: descriptionCtrl.text.trim().isEmpty
            ? null
            : descriptionCtrl.text.trim(),
      );
      CurrentUserAvatar.instance.value = updated.profileImage;
      _setState(UiSuccess(updated));
      _editingInfo = false;
      return true;
    } catch (e) {
      _uploadError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    _isUploading = true;
    _uploadError = null;
    notifyListeners();

    try {
      final url = await _uploadImage(File(picked.path));
      CurrentUserAvatar.instance.value = url;
      final current = user;
      if (current != null) {
        _setState(
          UiSuccess(
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
        );
      }
    } catch (e) {
      _uploadError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }
}
