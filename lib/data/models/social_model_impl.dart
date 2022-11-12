import 'dart:ffi';

import 'package:my_social_media_app/data/models/social_model.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:my_social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel {

  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  SocialDataAgent mDataAgent = RealTimeDatabaseDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Nyan Win Naing",
      postImage: "",
      description: description,
      profilePicture: "http://1.bp.blogspot.com/-bWTWg8Liw08/T3a4-R6-f5I/AAAAAAAAApw/fqviR8pguug/w1200-h630-p-k-no-nu/Logo-Of-Tom-and-Jerry-Wallpaper.jpg",
    );
    return mDataAgent.addNewPost(newPost);
  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed) {
    return mDataAgent.addNewPost(newsFeed);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return mDataAgent.getNewsFeedById(newsFeedId);
  }

}