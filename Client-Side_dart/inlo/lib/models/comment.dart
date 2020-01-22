import 'package:flutter/material.dart';

class Comment {
  final String id;
  final String commentBox;
  final String userId;
  final String ideaId;
  final String userName;
  final String image;
  final bool isApproved;

  Comment(
      {@required this.id,
      @required this.commentBox,
      @required this.userId,
      @required this.ideaId,
      @required this.userName,
      @required this.image,
      this.isApproved = false});
}
