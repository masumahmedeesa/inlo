import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Profile with ChangeNotifier {
  final String id;
  final String name;
  final String nid;
  final String dob;
  final String image;
  final bool verify;
  final String imagePath;
  final String userEmail;
  final String userId;
  

  Profile(
      {@required this.id,
      @required this.name,
      @required this.nid,
      @required this.dob,
      @required this.image,
      @required this.imagePath,
      @required this.userEmail,
      @required this.userId,
      this.verify = false});
}
