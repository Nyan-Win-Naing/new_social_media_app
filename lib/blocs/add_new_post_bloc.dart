import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:my_social_media_app/data/models/authentication_model.dart';
import 'package:my_social_media_app/data/models/authentication_model_impl.dart';
import 'package:my_social_media_app/data/models/social_model.dart';
import 'package:my_social_media_app/data/models/social_model_impl.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/data/vos/user_vo.dart';
import 'package:my_social_media_app/remote_config/firebase_remote_configuration.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  UserVO? _loggedInUser;

  Color themeColor = Colors.black;

  /// Image
  File? chosenImageFile;
  bool isLoading = false;

  /// For Edit Mode
  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  String uploadedPostImageUrl = "";
  NewsFeedVO? mNewsFeed;

  /// Model
  final SocialModel _model = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  /// Remote Configs
  final FirebaseRemoteConfiguration _firebaseRemoteConfiguration = FirebaseRemoteConfiguration();

  AddNewPostBloc({int? newsFeedId}) {
    _loggedInUser = _authenticationModel.getLoggedInUser();
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }

    /// Firebase
    _sendAnalyticsData(addNewPostScreenReached, null);
    _getRemoteConfigAndChangeTheme();
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafely();
      isAddNewPostError = false;
      if (isInEditMode) {
        return _editNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(
              editPostAction, {postId : mNewsFeed?.id.toString() ?? ""});
        });
      } else {
        return _createNewNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
      // return _model.addNewPost(newPostDescription);
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeed) {
      // print("News Feed Object is $newsFeed");
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      uploadedPostImageUrl = newsFeed.postImage ?? "";
      newPostDescription = newsFeed.description ?? "";
      mNewsFeed = newsFeed;
      _notifySafely();
    });
  }

  void _prepopulateDataForAddNewPost() {
    userName = _loggedInUser?.userName ?? "";
    profilePicture =
        "http://1.bp.blogspot.com/-bWTWg8Liw08/T3a4-R6-f5I/AAAAAAAAApw/fqviR8pguug/w1200-h630-p-k-no-nu/Logo-Of-Tom-and-Jerry-Wallpaper.jpg";
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future _editNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;
    if (mNewsFeed != null) {
      return _model.editPost(mNewsFeed!, chosenImageFile, uploadedPostImageUrl);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription, chosenImageFile);
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;
    _notifySafely();
  }

  void onTapDeleteImage() {
    chosenImageFile = null;
    uploadedPostImageUrl = "";
    _notifySafely();
  }

  /// Analytics
  void _sendAnalyticsData(String name, Map<String, String>? parameters) async {
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  void _getRemoteConfigAndChangeTheme() {
    themeColor = _firebaseRemoteConfiguration.getThemeColorFromRemoteConfig();
    _notifySafely();
  }
}
