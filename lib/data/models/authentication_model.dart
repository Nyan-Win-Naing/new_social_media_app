import 'package:my_social_media_app/data/vos/user_vo.dart';

abstract class AuthenticationModel {
  Future<void> login(String email, String password);
  Future<void> register(String email, String userName, String password);
  bool isLoggedIn();
  UserVO getLoggedInUser();
  Future<void> logOut();
}