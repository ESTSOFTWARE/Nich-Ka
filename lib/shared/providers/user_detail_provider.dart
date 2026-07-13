import 'package:flutter/material.dart';
import '../../core/network/http_client.dart';
import '../../core/presentation/ui_state.dart';
import '../../features/class/domain/entities/class_member.dart';
import '../../features/profile/data/datasource/remote/model/dto/response/user_profile_dto.dart';
import '../../features/profile/data/datasource/remote/profile_remote_datasource.dart';
import '../components/full_screen_image_viewer.dart';

class UserDetailProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final ClassMember member;
  final ProfileRemoteDataSource _dataSource;

  UiState<UserProfileDto> _userState = const UiLoading();
  UiState<UserProfileDto> get userState => _userState;

  UserDetailProvider(this.member)
    : _dataSource = ProfileRemoteDataSource(HttpClient.instance) {
    scrollController.addListener(_onScroll);
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (member.id == 0) {
      _userState = const UiError('ID de usuario no disponible.');
      notifyListeners();
      return;
    }
    _userState = const UiLoading();
    notifyListeners();
    try {
      final dto = await _dataSource.getUserById(member.id);
      _userState = UiSuccess(dto);
    } catch (e) {
      _userState = UiError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  void openImageViewer(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, _, second) =>
            FullScreenImageViewer(imageUrl: imageUrl),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
