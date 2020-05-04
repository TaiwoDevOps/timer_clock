import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timer_clock/main.dart';
import 'package:timer_clock/utilities/custom_painter_utils.dart';

class EggTimerDialKnob extends StatefulWidget {
  final rotationPercent;

  EggTimerDialKnob({this.rotationPercent});
  @override
  _EggTimerDialKnobState createState() => _EggTimerDialKnobState();
}

class _EggTimerDialKnobState extends State<EggTimerDialKnob> {
  File _image;
  @override
  void initState() {
    print('Image -----$_image');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(
              rotationPercent: widget.rotationPercent, //this is 25 percent
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.5),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GRADIENT_BOTTOM, GRADIENT_TOP],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1.0,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                )
              ]),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                width: 1.5,
                color: Colors.grey,
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: selectCamera,
                child: Transform(
                    transform:
                        Matrix4.rotationZ(2 * pi * widget.rotationPercent),
                    alignment: Alignment.center,
                    child: _image == null
                        ? Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              _image,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future getImageLibrary() async {
    try {
      var gallery = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 700);
      if (gallery == null) return;
      setState(() {
        _image = gallery;
      });
    } catch (e) {
      throw Exception('Something went wrong $e');
    }
  }

  Future cameraImage() async {
    try {
      var image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 700);
      if (image == null) return;
      print(image);
      setState(() {
        _image = image;
      });
    } catch (e) {
      throw Exception('Something went wrong $e');
    }
  }

  void resetImageNone() {
    setState(() {
      _image = null;
    });
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          // lastSelectedValue = value;
        });
      }
    });
  }

// study widget, form inputs image
// scoped-model connected product
  selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: const Text(
          'Stay motivated 😋',
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Snap and Use'),
            onPressed: () {
              Navigator.pop(context, 'Snap and Use');
              cameraImage();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Upload from library'),
            onPressed: () {
              Navigator.pop(context, 'Upload from library');
              getImageLibrary();
            },
          ),
          _image != null
              ? CupertinoActionSheetAction(
                  child: const Text('Reset to Icon'),
                  onPressed: () {
                    Navigator.pop(context, 'Reset to Icon');
                    resetImageNone();
                  },
                )
              : Container(),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }
}
