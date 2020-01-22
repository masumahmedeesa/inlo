import 'package:flutter/foundation.dart';

class ApproveList with ChangeNotifier {
  final String id;
  final String userId;
  final String loanId;
  final String bankId;
  final String loanName;
  final String stockCode;
  final String userName;
  final String userEmail;
  final String salary;
  final String property;

  ApproveList({
    @required this.id,
    @required this.userId,
    @required this.loanId,
    @required this.bankId,
    @required this.loanName,
    @required this.stockCode,
    @required this.userName,
    @required this.userEmail,
    @required this.salary,
    @required this.property,
  });
}
