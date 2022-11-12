import 'package:flutter/material.dart';
import 'package:my_social_media_app/resources/dimens.dart';

class ProfileImageView extends StatelessWidget {
  final String profileImage;

  const ProfileImageView({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        (profileImage != "") ? profileImage : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png",
      ),
      radius: MARGIN_LARGE,
    );
  }
}