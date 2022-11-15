import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_social_media_app/blocs/text_detection_bloc.dart';
import 'package:my_social_media_app/resources/dimens.dart';
import 'package:my_social_media_app/utils/extensions.dart';
import 'package:my_social_media_app/widgets/primary_button_view.dart';
import 'package:provider/provider.dart';

class TextDetectionPage extends StatelessWidget {
  const TextDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextDetectionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 200,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                SizedBox(width: MARGIN_MEDIUM),
                Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: MARGIN_XLARGE,
                ),
                SizedBox(width: MARGIN_SMALL),
                Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: TEXT_REGULAR_2X,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<TextDetectionBloc>(
                  builder: (context, bloc, child) {
                    return Visibility(
                      visible: bloc.chosenImageFile != null,
                      child: Image.file(
                        bloc.chosenImageFile ?? File(""),
                        width: 300,
                        height: 300,
                      ),
                    );
                  },
                ),
                SizedBox(height: MARGIN_LARGE),
                Consumer<TextDetectionBloc>(
                  builder: (context, bloc, child) => GestureDetector(
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.gallery)
                          .then((pickedImageFile) async {
                        var bytes = await pickedImageFile?.readAsBytes();
                        bloc.onImageChosen(
                          File(pickedImageFile?.path ?? ""),
                          bytes ?? Uint8List(0),
                        );
                      }).catchError((error) {
                        showSnackBarWithMessage(
                            context, "Image Cannot be picked");
                      });
                    },
                    child: const PrimaryButtonView(
                      label: "Choose Image",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
