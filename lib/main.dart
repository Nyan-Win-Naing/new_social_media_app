import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_social_media_app/data/models/authentication_model_impl.dart';
import 'package:my_social_media_app/fcm/fcm_service.dart';
import 'package:my_social_media_app/pages/login_page.dart';
import 'package:my_social_media_app/pages/news_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForMessages();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authenticationModel = AuthenticationModelImpl();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (_authenticationModel.isLoggedIn())
          ? const NewsFeedPage()
          : const LoginPage(),
    );
  }
}
