import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_social_media_app/data/models/social_model.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:my_social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:my_social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  SocialDataAgent mDataAgent = RealTimeDatabaseDataAgentImpl();
  // SocialDataAgent mDataAgent = CloudFirestoreDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description, File? imageFile) {
    if (imageFile != null) {
      return mDataAgent
          .uploadFileToFirebase(imageFile)
          .then((downloadUrl) => craftNewsFeedVO(description, downloadUrl))
          .then((newPost) => mDataAgent.addNewPost(newPost));
    } else {
      return craftNewsFeedVO(description, "")
          .then((newPost) => mDataAgent.addNewPost(newPost));
    }
  }

  Future<NewsFeedVO> craftNewsFeedVO(String description, String imageUrl) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Nyan Win Naing",
      postImage: imageUrl,
      description: description,
      profilePicture:
          "http://1.bp.blogspot.com/-bWTWg8Liw08/T3a4-R6-f5I/AAAAAAAAApw/fqviR8pguug/w1200-h630-p-k-no-nu/Logo-Of-Tom-and-Jerry-Wallpaper.jpg",
    );
    return Future.value(newPost);
  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed, File? imageFile, String uploadedImageUrl) {
    if(imageFile != null) {
      print("Image File Block works...........");
      return mDataAgent
          .uploadFileToFirebase(imageFile)
          .then((downloadUrl) => craftNewsFeedVOForEdit(newsFeed, downloadUrl))
          .then((newsFeedPost) => mDataAgent.addNewPost(newsFeedPost));
    } else if(uploadedImageUrl.isNotEmpty) {
      print("Uploaded Image Url Block works...........");
      return craftNewsFeedVOForEdit(newsFeed, uploadedImageUrl)
          .then((newsFeedPost) => mDataAgent.addNewPost(newsFeedPost));
    } else {
      print("No Image Block works...........");
      return craftNewsFeedVOForEdit(newsFeed, "")
          .then((newsFeedPost) => mDataAgent.addNewPost(newsFeedPost));
    }
    // return mDataAgent.addNewPost(newsFeed);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return mDataAgent.getNewsFeedById(newsFeedId);
  }

  Future<NewsFeedVO> craftNewsFeedVOForEdit(NewsFeedVO newsFeedVo, String imageUrl) {
    newsFeedVo.postImage = imageUrl;
    return Future.value(newsFeedVo);
  }
}
