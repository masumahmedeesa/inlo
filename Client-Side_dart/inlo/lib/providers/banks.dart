import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../models/http_exception.dart';
import './bank.dart';

class Banks with ChangeNotifier {
  List<Bank> _items = [];
  List<Bank> _searchitems = [];

  List<Bank> get items {
    return [..._items];
  }

  List<Bank> get search {
    return [..._searchitems];
  }

  List<Bank> get favoruiteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Bank findById(String id) {
    return _items.firstWhere((bankn) => bankn.id == id);
  }

  Future<void> getBankSetBank() async {
    final url = "https://microinloan.firebaseio.com/bankinfo.json";
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Bank> loadedBank = [];
      extractedData.forEach((bankId, bankData) {
        loadedBank.add(Bank(
          id: bankId,
          address: bankData['address'],
          category: bankData['category'],
          description: bankData['description'],
          image: bankData['image'],
          knownAs: bankData['knownAs'],
          origin: bankData['origin'],
          stockCode: bankData['stockCode'],
          swiftCode: bankData['swiftCode'],
          type: bankData['type'],
          services: bankData['services'],
          isFavorite: bankData['isFavourite'],
        ));
      });
      _items = loadedBank;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

  Future<void> getSearchBank(String text, {clearExisting = false}) async {
    print('in getSearch');
    if(clearExisting){
      _searchitems = [];
    }
    final url = "https://microinloan.firebaseio.com/bankinfo.json";
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Bank> loadedBank = [];
      print('loaded e search');
      extractedData.forEach((bankId, bankData) {
        loadedBank.add(Bank(
          id: bankId,
          address: bankData['address'],
          category: bankData['category'],
          description: bankData['description'],
          image: bankData['image'],
          knownAs: bankData['knownAs'],
          origin: bankData['origin'],
          stockCode: bankData['stockCode'],
          swiftCode: bankData['swiftCode'],
          services: bankData['services'],
          type: bankData['type'],
          isFavorite: bankData['isFavourite'],
        ));
      });
      print('in getSearch1');
      print(loadedBank.length);
      print(text);
      print('bhai brother');
      print(loadedBank[0].stockCode.toLowerCase());
      // _searchitems = loadedBank;

      _searchitems = loadedBank.where((Bank bank){
        return bank.stockCode.toLowerCase().contains(text.toLowerCase());
      }).toList();

      print('in getSearch2 ... last');
      print(_searchitems.length);
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

}
