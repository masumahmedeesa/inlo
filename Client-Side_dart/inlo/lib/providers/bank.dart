import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Bank with ChangeNotifier {
  final String id;
  final String address;
  final String category;
  final String description;
  final String image;
  final String knownAs;
  final String origin;
  final String stockCode;
  final String swiftCode;
  final String type;
  final String services;
  bool isFavorite;

  Bank({
    @required this.id,
    @required this.address,
    @required this.category,
    @required this.description,
    @required this.image,
    @required this.knownAs,
    @required this.origin,
    @required this.stockCode,
    @required this.swiftCode,
    @required this.type,
    @required this.services,
    this.isFavorite = false,
  });

  void _setValue(bool v) {
    isFavorite = v;
    notifyListeners();
  }

  Future<void> favouriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = "https://microinloan.firebaseio.com/bankinfo/$id.json";
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavourite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setValue(oldStatus);
      }
    } catch (error) {
      _setValue(oldStatus);
    }
  }


}