import 'dart:io';

import 'package:my_social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<void> addNewPost(String description, File? imageFile);
  Future<void> editPost(NewsFeedVO newsFeed, File? imageFile, String uploadedImageUrl);
  Future<void> deletePost(int postId);
}
