import 'dart:io';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Image_Capture extends StatefulWidget {
  @override
  _Image_CaptureState createState() => _Image_CaptureState();
}

class _Image_CaptureState extends State<Image_Capture> {
  File imageFile;
  Future<void> _pickImage(ImageSource source) async{ 
    File selected=await ImagePicker.pickImage(source: source, maxHeight: 400, maxWidth: 300);
    setState(() {
      imageFile=selected;
    });
  }

  Future<void> _cropImage() async {
    File cropped=await ImageCropper.cropImage(
      sourcePath: imageFile.path,

      toolbarColor: Colors.purple,
      toolbarWidgetColor: Colors.white,
      toolbarTitle: 'Crop'
      );
      setState(() {
        imageFile=cropped ?? imageFile;
      });


  }


  void clear(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(children: <Widget>[

          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: (){
              _pickImage(ImageSource.camera,);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: (){
              _pickImage(ImageSource.gallery);
            },
          )
        ],),
      ),
      body: ListView(children: <Widget>[
        if(imageFile!=null)...[
            Image.file(imageFile),

            Row(children: <Widget>[
              FlatButton(
                child: Icon(Icons.crop),
                onPressed: (){
                  _cropImage();
                },
              ),
              FlatButton(
                child: Icon(Icons.clear),
                onPressed: (){
                  clear();
                },
              ),
            ],),
            Uploder(file: imageFile,)
        ]
        
      ],),
    );
  }
}