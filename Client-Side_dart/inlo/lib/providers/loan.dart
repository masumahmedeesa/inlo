import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Loan with ChangeNotifier {
  final String id;
  final String conditions;
  final String description;
  final String eligibility;
  final String interestRate;
  final String loanAmount;
  final String name;
  final String stockCode;
  final String bankId;
  final String tenure;
  bool isFavorite;

  Loan({
    @required this.id,
    @required this.conditions,
    @required this.description,
    @required this.eligibility,
    @required this.interestRate,
    @required this.loanAmount,
    @required this.name,
    @required this.stockCode,
    @required this.bankId,
    @required this.tenure,
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
    final url = "https://microinloan.firebaseio.com/loans/$id.json";
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
