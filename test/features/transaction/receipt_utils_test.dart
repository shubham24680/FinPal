import 'dart:io';

import 'package:finpal/features/transaction/data/receipt_utils.dart';
import 'package:finpal/features/transaction/data/transaction_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('finpal_receipt_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<File> createReceipt({
    required String name,
    required int sizeInBytes,
  }) async {
    final file = File('${tempDir.path}/$name');
    await file.writeAsBytes(List.filled(sizeInBytes, 1));
    return file;
  }

  group('ReceiptUtils', () {
    test('validateReceipt accepts png files within size limit', () async {
      final file = await createReceipt(name: 'receipt.png', sizeInBytes: 1024);

      expect(ReceiptUtils.validateReceipt(file.path), isNull);
    });

    test('validateReceipt rejects unsupported file types', () async {
      final file = await createReceipt(name: 'receipt.pdf', sizeInBytes: 1024);

      expect(
        ReceiptUtils.validateReceipt(file.path),
        TransactionConstants.receiptTypeMessage,
      );
    });

    test('validateReceipt rejects files larger than 5MB', () async {
      final file = await createReceipt(
        name: 'large.jpg',
        sizeInBytes: TransactionConstants.maxReceiptSizeBytes + 1,
      );

      expect(
        ReceiptUtils.validateReceipt(file.path),
        TransactionConstants.receiptSizeMessage,
      );
    });

    test('validateReceipt rejects missing files', () {
      expect(
        ReceiptUtils.validateReceipt('${tempDir.path}/missing.png'),
        TransactionConstants.receiptNotFoundMessage,
      );
    });

    test('fileName returns basename from path', () {
      expect(
        ReceiptUtils.fileName('/tmp/folder/my-receipt.jpeg'),
        'my-receipt.jpeg',
      );
    });
  });
}
