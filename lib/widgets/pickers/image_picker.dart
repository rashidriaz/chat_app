import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File image) setImageFunction;
  UserImagePicker(this.setImageFunction);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          backgroundImage:
          _pickedImage == null ? null : FileImage(_pickedImage),
          radius: 50,
          backgroundColor: Theme
              .of(context)
              .accentColor,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.black87,
          ),
          height: 35,
          width: 37,
          child: IconButton(
            padding: EdgeInsets.fromLTRB(2, 1, 0, 0),
            alignment: Alignment.center,
            icon: Icon(
              Icons.edit_rounded,
              color: Colors.white,
            ),
            onPressed: () => _showDialog(context),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: source, imageQuality: 50);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
      widget.setImageFunction(pickedImageFile);
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose an Option'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton.icon(
                  icon: Icon(Icons.camera_alt_rounded),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  label: Text("Take a picture"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  label: Text("Choose from gallery"),
                ),
              ],
            ),
          );
        });
  }
}
