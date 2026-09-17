import 'dart:io';

import 'package:finpal/app/app.dart';

class ReceiptUtils {
  ReceiptUtils._();

  static String? validateReceipt(String path) {
    if (path.trim().isEmpty) return null;

    final file = File(path);
    if (!file.existsSync()) {
      return TransactionConstants.receiptNotFoundMessage;
    }

    final extension = path.split('.').last.toLowerCase();
    if (!TransactionConstants.allowedReceiptExtensions.contains(extension)) {
      return TransactionConstants.receiptTypeMessage;
    }

    final size = file.lengthSync();
    if (size > TransactionConstants.maxReceiptSizeBytes) {
      return TransactionConstants.receiptSizeMessage;
    }

    return null;
  }

  static String fileName(String path) =>
      path.replaceAll('\\', '/').split('/').last;
}
