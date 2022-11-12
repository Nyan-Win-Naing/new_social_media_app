import 'package:firebase_database/firebase_database.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/network/social_data_agent.dart';

const newsFeedPath = "newsfeed";

class RealTimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealTimeDatabaseDataAgentImpl _singleton =
      RealTimeDatabaseDataAgentImpl._internal();

  factory RealTimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealTimeDatabaseDataAgentImpl._internal();

  /// Database
  var databaseRef = FirebaseDatabase.instance.ref();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(newsFeedPath).onValue.map((event) {
      return (event.snapshot.children).map<NewsFeedVO>((element) {
        return NewsFeedVO.fromJson(
            Map<String, dynamic>.from(element.value as dynamic));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return databaseRef
        .child(newsFeedPath)
        .child(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsFeedPath).child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeedId.toString())
        .once()
        .asStream()
        .map((snapShot) {
      return NewsFeedVO.fromJson(
        Map<String, dynamic>.from(snapShot.snapshot.value as dynamic),
      );
    });
  }
}
