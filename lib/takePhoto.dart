import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TakePhoto extends StatefulWidget {
  const TakePhoto({super.key});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;

  Future pickImageFromGallery() async{
    final XFile? inputImage = await _picker.pickImage(source: ImageSource.gallery);
    if(inputImage != null){
      setState(() {
        selectedImage = inputImage;
      });
    }
  }

  Future pickImageFromCamera() async{
    final XFile? inputImage = await _picker.pickImage(source: ImageSource.camera);
    if(inputImage != null){
      setState(() {
        selectedImage = inputImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick Image from Gallery",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                pickImageFromGallery();
              },
            ),
            MaterialButton(
              color: Colors.red,
              child: const Text(
                "Take Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                pickImageFromCamera();
              },
            ),

            selectedImage != null ? Image.file( File(selectedImage!.path), width: 200, height: 200, fit: BoxFit.cover,) : Container(),
          ],
        ),
      ),
    );
  }
}
