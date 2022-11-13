import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_social_media_app/data/vos/news_feed_vo.dart';
import 'package:my_social_media_app/data/vos/user_vo.dart';
import 'package:my_social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:my_social_media_app/network/social_data_agent.dart';

/// News Feed Collection
const newsFeedCollection = "newsfeed";
const usersCollection = "users";
const fileUplaodRef = "uploads";

class CloudFirestoreDataAgentImpl extends SocialDataAgent {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  /// Auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return _fireStore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<NewsFeedVO>((document) {
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) =>
            NewsFeedVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  @override
  UserVO getLoggedInUser() {
    return UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName,
    );
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future logout() {
    return auth.signOut();
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
        email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) =>
    credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      print("User ID set block works........");
      newUser.id = user?.uid ?? "";
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return _fireStore
        .collection(usersCollection)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }
}
