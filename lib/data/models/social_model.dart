import 'package:my_social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<void> addNewPost(String description);
  Future<void> editPost(NewsFeedVO newsFeed);
  Future<void> deletePost(int postId);
}