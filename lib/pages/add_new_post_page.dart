import 'package:flutter/material.dart';
import 'package:my_social_media_app/blocs/add_new_post_bloc.dart';
import 'package:my_social_media_app/resources/dimens.dart';
import 'package:my_social_media_app/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

class AddNewPostPage extends StatelessWidget {
  final int? newsFeedId;

  const AddNewPostPage({
    Key? key,
    this.newsFeedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsFeedId: newsFeedId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Container(
            margin: const EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: const Text(
              "Add New Post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: MARGIN_XLARGE,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(
            top: MARGIN_XLARGE,
          ),
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                ProfileImageAndNameView(),
                SizedBox(
                  height: MARGIN_LARGE,
                ),
                AddNewPostTextFieldView(),
                SizedBox(
                  height: MARGIN_MEDIUM,
                ),
                PostDescriptionErrorView(),
                SizedBox(
                  height: MARGIN_LARGE,
                ),
                PostButtonView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {
  const PostDescriptionErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isAddNewPostError,
        child: const Text(
          "Post should not be empty",
          style: TextStyle(
            color: Colors.red,
            fontSize: TEXT_REGULAR,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PostButtonView extends StatelessWidget {
  const PostButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => GestureDetector(
        onTap: () {
          bloc.onTapAddNewPost().then((value) {
            Navigator.pop(context);
          });
        },
        child: Container(
          width: double.infinity,
          height: MARGIN_XXLARGE,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              MARGIN_LARGE,
            ),
          ),
          child: const Center(
            child: Text(
              "POST",
              style: TextStyle(
                color: Colors.white,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImageAndNameView extends StatelessWidget {
  const ProfileImageAndNameView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Row(
        children: [
          ProfileImageView(
            profileImage: bloc.profilePicture ?? "",
          ),
          const SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
          Text(
            bloc.userName ?? "",
            style: const TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewPostTextFieldView extends StatelessWidget {
  const AddNewPostTextFieldView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => SizedBox(
        height: ADD_NEW_POST_TEXTFIELD_HEIGHT,
        child: TextField(
          maxLines: 24,
          controller: TextEditingController(text: bloc.newPostDescription),
          onChanged: (text) {
            bloc.onNewPostTextChanged(text);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                MARGIN_MEDIUM,
              ),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            hintText: "What's on your mind?",
          ),
        ),
      ),
    );
  }
}