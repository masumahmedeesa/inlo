import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../models/http_exception.dart';
import './loan.dart';
// import './approveModel.dart';

class Loans with ChangeNotifier {
  // List<ApproveList> _approves = [];
  // List<ApproveList> get apprs {
  //   return [..._approves];
  // }

  List<Loan> _items = [
    // Loan(
    //   id: '1',
    //   title: 'Dutch Bangla',
    //   description: 'We are giving high loan',
    //   currency: 456.89,
    //   imageUrl: 'https://dummyimage.com/600x400/2abd47/fff&text=masum',
    // ), eesha@eesha.com
  ];

  List<Loan> _searchitems = [];
  List<Loan> _approveditems = [];

  List<Loan> get items {
    return [..._items];
  }

  List<Loan> get search {
    return [..._searchitems];
  }

  List<Loan> get approvedReq {
    return [..._approveditems];
  }

  List<Loan> get favoruiteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Loan> getLoans(String code) {
    return _items.where((Loan item) {
      return item.stockCode == code;
    }).toList();
  }

  // void showFavourite(){
  //   _showFavourites = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavourites = false;
  //   notifyListeners();
  // }

  Loan findById(String id) {
    return _items.firstWhere((loann) => loann.id == id);
  }

  Future<void> getLoanSetLoan() async {
    print('in loans');
    final url = "https://microinloan.firebaseio.com/loans.json";
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Loan> loadedLoan = [];
      extractedData.forEach((loanId, loanData) {
        loadedLoan.add(Loan(
          id: loanId,
          bankId: loanData['bankId'],
          conditions: loanData['conditions'],
          description: loanData['description'],
          eligibility: loanData['eligibility'],
          interestRate: loanData['interestRate'],
          loanAmount: loanData['loanAmount'],
          name: loanData['name'],
          stockCode: loanData['stockCode'],
          tenure: loanData['tenure'],
          isFavorite: loanData['isFavourite'],
        ));
      });
      print('pore');
      print(loadedLoan.length);
      _items = loadedLoan;
      // .where((Loan loan){
      //   return loan.stockCode.toLowerCase().contains(code.toLowerCase());
      // });
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

  Future<void> getSearchLoan(String text, {clearExisting = false}) async {
    print('in getSearch');
    if (clearExisting) {
      _searchitems = [];
    }
    final url = "https://microinloan.firebaseio.com/loans.json";
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Loan> loadedLoan = [];
      extractedData.forEach((loanId, loanData) {
        loadedLoan.add(Loan(
          id: loanId,
          bankId: loanData['bankId'],
          conditions: loanData['conditions'],
          description: loanData['description'],
          eligibility: loanData['eligibility'],
          interestRate: loanData['interestRate'],
          loanAmount: loanData['loanAmount'],
          name: loanData['name'],
          stockCode: loanData['stockCode'],
          tenure: loanData['tenure'],
          isFavorite: loanData['isFavourite'],
        ));
      });
      print('in getSearch1');
      print(loadedLoan.length);
      print(text);
      print('bhai brother');
      print(loadedLoan[0].stockCode.toLowerCase());
      // _searchitems = loadedBank;

      _searchitems = loadedLoan.where((Loan loan) {
        return loan.name.toLowerCase().contains(text.toLowerCase());
      }).toList();

      print('in getSearch2 ... last');
      print(_searchitems.length);
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

  // Future<void> getApprove(String userId) async {
  //   print('in approve');
  //   final url = "https://microinloan.firebaseio.com/approved.json";
  //   try {
  //     final response = await http.get(url);
  //     // print(json.decode(response.body));
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     print(extractedData);
  //     final List<ApproveList> loadedApp = [];
  //     extractedData.forEach((loanId, loanData) {
  //       loadedApp.add(ApproveList(
  //         id: loanId,
  //         loanId: loanData['loanId'],
  //         userId: loanData['userId'],
  //         bankId: loanData['bankId'],
  //       ));
  //     });
  //     print('pore');
  //     print(loadedApp.length);
  //     _approves = loadedApp.where((ApproveList list) {
  //       return list.userId == userId;
  //     }).toList();
  //     // _approveditems = loadedApp.where(test)
  //     print(_approves.length);
  //     print('approve paisi');
  //     // print(_items.length);
  //     print('hi hi ');
  //     print(_approves[0].loanId);
  //     print('fuck');
  //     notifyListeners();
  //   } catch (error) {
  //     // throw (error);
  //   }
  // }

// 11 number video from http request e async chara kora ase
  // Future<void> addLoan(Loan loanId) async {
  //   const url = "https://microinloan.firebaseio.com/loans.json";
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'title': loanId.title,
  //         'description': loanId.description,
  //         'currency': loanId.currency,
  //         'imageUrl': loanId.imageUrl,
  //         'isFavourite': loanId.isFavorite,
  //       }),
  //     );

  //     final newLoan = Loan(
  //       // id: DateTime.now().toString(),
  //       id: json.decode(response.body)['name'],
  //       title: loanId.title,
  //       description: loanId.description,
  //       currency: loanId.currency,
  //       imageUrl: loanId.imageUrl,
  //     );
  //     _items.add(newLoan);
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateLoan(String id, Loan loan) async {
  //   final index = _items.indexWhere((loanId) => loanId.id == id);
  //   if (index >= 0) {
  //     final url = "https://microinloan.firebaseio.com/loans/$id.json";
  //     await http.patch(url,
  //         body: json.encode({
  //           'title': loan.title,
  //           'description': loan.description,
  //           'currency': loan.currency,
  //           'imageUrl': loan.imageUrl,
  //         }));
  //     _items[index] = loan;
  //     notifyListeners();
  //   } else {
  //     print("FUCK");
  //   }
  // }

  // Future<void> deleteLoan(String id) async {
  //   final url = "https://microinloan.firebaseio.com/loans/$id.json";
  //   final existingLoanIndex = _items.indexWhere((loanId) => loanId.id == id);
  //   var existingLoan = _items[existingLoanIndex];
  //   _items.removeAt(existingLoanIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);

  //   if (response.statusCode >= 400) {
  //     _items.insert(existingLoanIndex, existingLoan);
  //     notifyListeners();
  //     throw HttpException("Can't Delete");
  //   }
  //   existingLoan = null;
  //   // _items.removeWhere((loanId) => loanId.id == id);
  // }

}
