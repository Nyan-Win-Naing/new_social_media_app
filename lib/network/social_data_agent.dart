import 'dart:io';

import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/data/vos/user_vo.dart';

abstract class SocialDataAgent {
  /// News Feed
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(NewsFeedVO newPost);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<String> uploadFileToFirebase(File image);

  /// Authentication
  Future registerNewUser(UserVO newUser);
  Future login(String email, String password);
  bool isLoggedIn();
  UserVO getLoggedInUser();
  Future logout();
}