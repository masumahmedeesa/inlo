import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;

  AddressTag(this.address);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[50], width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Text(
        address,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
    );
  }
}
