import 'package:flutter/foundation.dart';
import 'package:my_social_media_app/data/models/social_model.dart';
import 'package:my_social_media_app/data/models/social_model_impl.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;

  /// For Edit Mode
  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  /// Model
  final SocialModel _model = SocialModelImpl();

  AddNewPostBloc({int? newsFeedId}) {
    if(newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if(newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isAddNewPostError = false;
      if(isInEditMode) {
        return _editNewsFeedPost();
      } else {
        return _createNewNewsFeedPost();
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
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      newPostDescription = newsFeed.description ?? "";
      mNewsFeed = newsFeed;
      _notifySafely();
    });
  }

  void _prepopulateDataForAddNewPost() {
    userName = "Nyan Win Naing";
    profilePicture = "http://1.bp.blogspot.com/-bWTWg8Liw08/T3a4-R6-f5I/AAAAAAAAApw/fqviR8pguug/w1200-h630-p-k-no-nu/Logo-Of-Tom-and-Jerry-Wallpaper.jpg";
    _notifySafely();
  }

  void _notifySafely() {
    if(!isDisposed) {
      notifyListeners();
    }
  }

  Future _editNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;
    if(mNewsFeed != null) {
      return _model.editPost(mNewsFeed!);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription);
  }


}