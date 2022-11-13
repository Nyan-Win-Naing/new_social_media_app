import 'package:flutter/foundation.dart';
import 'package:my_social_media_app/data/models/authentication_model.dart';
import 'package:my_social_media_app/data/models/authentication_model_impl.dart';
import 'package:my_social_media_app/data/models/social_model.dart';
import 'package:my_social_media_app/data/models/social_model_impl.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {

  List<NewsFeedVO>? newsFeed;

  final SocialModel _mSocialModel = SocialModelImpl();
  final AuthenticationModel _mAuthenticationModel = AuthenticationModelImpl();

  bool isDisposed = false;

  NewsFeedBloc() {
    _mSocialModel.getNewsFeed().listen((newsFeedList) {
      newsFeed = newsFeedList;
      if(!isDisposed) {
        notifyListeners();
      }
    });
  }

  void onTapDeletePost(int postId) async {
    await _mSocialModel.deletePost(postId);
  }

  Future onTapLogout() {
    return _mAuthenticationModel.logOut();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}