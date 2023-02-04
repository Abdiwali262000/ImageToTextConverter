import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";
  File? _image;
  ImagePicker imagePicker = ImagePicker();

  captureFromGallery() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);

    setState(() {
      _image;

      //Do the extract text from Image

      textFromImage();
    });
  }

  captureFromCamera() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);
    _image = File(pickedFile.path);

    setState(() {
      _image;

      textFromImage();
    });
  }

  textFromImage() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(_image);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text + " ";
          }
        }

        result += "\n\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bac1.jpeg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(width: 100.0),

            //Result Container
            Container(
              height: 280.0,
              width: 250.0,
              margin: EdgeInsets.only(top: 70.0),
              padding: EdgeInsets.only(left: 28.0, bottom: 5.0, right: 18.0),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/note1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20.0, right: 140.0),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/pin.png',
                          height: 240.0,
                          width: 240.0,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        captureFromGallery();
                      },
                      onLongPress: () {
                        captureFromCamera();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 140.0,
                                height: 192.0,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 240.0,
                                height: 200.0,
                                child: Icon(
                                  Icons.camera_front,
                                  size: 100.0,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
