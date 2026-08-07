import 'package:finpal/app/app.dart';

class TransactionHelperModel {
  final String icon;
  final String label;
  final String value;
  final Color? valueColor;

  TransactionHelperModel({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}