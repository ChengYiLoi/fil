import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader {
  final File file;
  final String id;
  Uploader({@required this.file, @required this.id});
  Future uploadImage() async {
    String fileName = 'markerImages/$id';
    // uploads the file to FB storage
    FirebaseStorage.instance.ref().child(fileName).putFile(file);
    print('image uploaded');
  }
}
