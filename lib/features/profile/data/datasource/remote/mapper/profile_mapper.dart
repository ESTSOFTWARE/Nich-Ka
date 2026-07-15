import '../../../../domain/entities/profile_user.dart';
import '../model/dto/response/user_profile_dto.dart';

class ProfileMapper {
  const ProfileMapper._();

  static ProfileUser fromUserProfileDto(UserProfileDto dto) {
    String memberSince = '';
    if (dto.createdAt != null) {
      try {
        final date = DateTime.parse(dto.createdAt!);
        memberSince = '${date.day} ${_monthName(date.month)} ${date.year}';
      } catch (_) {
        memberSince = dto.createdAt!;
      }
    }

    return ProfileUser(
      firstName: dto.name,
      lastName: dto.lastName,
      email: dto.email,
      role: dto.role,
      circuit: '',
      memberSince: memberSince,
      profileImage: dto.profileImage,
      dialCode: dto.dialCode,
      phoneNumber: dto.phoneNumber,
      description: dto.description,
    );
  }

  static String _monthName(int month) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return months[month - 1];
  }
}
