import '../../domain/entities/profile_user.dart';
import '../states/ui_state.dart';

class ProfileState {
  final UiState<ProfileUser> profileState;
  final bool isUploading;
  final bool isSaving;
  final String? uploadError;
  final bool editingInfo;
  final String dialCode;

  const ProfileState({
    this.profileState = const UiIdle(),
    this.isUploading = false,
    this.isSaving = false,
    this.uploadError,
    this.editingInfo = false,
    this.dialCode = '+52',
  });

  ProfileUser? get user => switch (profileState) {
    UiSuccess<ProfileUser> s => s.data,
    _ => null,
  };

  bool get isGoogleLinked => true;

  static const Object _keep = Object();

  ProfileState copyWith({
    UiState<ProfileUser>? profileState,
    bool? isUploading,
    bool? isSaving,
    Object? uploadError = _keep,
    bool? editingInfo,
    String? dialCode,
  }) => ProfileState(
    profileState: profileState ?? this.profileState,
    isUploading: isUploading ?? this.isUploading,
    isSaving: isSaving ?? this.isSaving,
    uploadError: identical(uploadError, _keep)
        ? this.uploadError
        : uploadError as String?,
    editingInfo: editingInfo ?? this.editingInfo,
    dialCode: dialCode ?? this.dialCode,
  );
}
