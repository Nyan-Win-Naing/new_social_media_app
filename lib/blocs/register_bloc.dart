import 'package:flutter/foundation.dart';
import 'package:my_social_media_app/data/models/authentication_model.dart';
import 'package:my_social_media_app/data/models/authentication_model_impl.dart';

class RegisterBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  String userName = "";
  bool isDisposed = false;

  /// Model
  final AuthenticationModel _model = AuthenticationModelImpl();

  Future onTapRegister() {
    _showLoading();
    return _model
        .register(email, userName, password)
        .whenComplete(() => _hideLoading());
  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
  }

  void onUserNameChanged(String userName) {
    this.userName = userName;
  }

  void _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}