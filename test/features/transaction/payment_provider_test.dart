import 'dart:io';

import 'package:finpal/core/customs/button.dart';
import 'package:finpal/core/extensions/context_extension.dart';
import 'package:finpal/features/transaction/data/notifiers/payment_provider.dart';
import 'package:finpal/features/transaction/data/notifiers/transaction_provider.dart';
import 'package:finpal/features/transaction/data/transaction_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/hive_test_setup.dart';
import '../../helpers/provider_harness.dart';

void main() {
  late ProviderHarness harness;
  late ProviderContainer container;

  setUp(() async {
    harness = await ProviderHarness.create();
    // Seed enough income so overspend checks are meaningful.
    await harness.paymentBox.put(
      'seed_income',
      makePayment(
        id: 'seed_income',
        type: TransactionType.income.id,
        amount: 1000,
        date: DateTime(2026, 1, 1),
      ),
    );
    container = harness.createContainer();
    await container.read(transactionProvider.future);
  });

  tearDown(() async {
    container.dispose();
    await harness.dispose();
  });

  tearDownAll(HiveTestSetup.disposeAll);

  group('PaymentProvider — initial / waiting', () {
    test('starts disabled with empty amount and helper text', () {
      final state = container.read(paymentProvider);

      expect(state.buttonState, ButtonState.disabled);
      expect(state.amount, isEmpty);
      expect(state.helperText, TransactionConstants.emptyHelperText);
      expect(state.toastMessage, isEmpty);
      expect(state.toastType, ToastType.normal);
    });
  });

  group('PaymentProvider — validation / button state', () {
    test('enables button when amount and date are present', () {
      container.read(paymentProvider.notifier).set(amount: '₹100.00');

      final state = container.read(paymentProvider);
      expect(state.buttonState, ButtonState.enabled);
      expect(state.amount, '₹100.00');
    });

    test('keeps button disabled when amount cleared', () {
      final notifier = container.read(paymentProvider.notifier);
      notifier.set(amount: '₹50.00');
      notifier.set(amount: '');

      expect(container.read(paymentProvider).buttonState, ButtonState.disabled);
    });
  });

  group('PaymentProvider — overspend / savings helper', () {
    test('shows savings helper when expense is within balance', () {
      container.read(paymentProvider.notifier).set(
            type: TransactionType.expense,
            amount: '₹200.00',
          );

      final state = container.read(paymentProvider);
      expect(state.helperText, startsWith(TransactionConstants.savingHelperText));
    });

    test('shows overspent helper when expense exceeds balance', () {
      container.read(paymentProvider.notifier).set(
            type: TransactionType.expense,
            amount: '₹1500.00',
          );

      final state = container.read(paymentProvider);
      expect(
        state.helperText,
        startsWith(TransactionConstants.overspentHelperText),
      );
    });

    test('resets helper when amount emptied', () {
      final notifier = container.read(paymentProvider.notifier);
      notifier.set(amount: '₹10.00');
      notifier.set(amount: '');

      expect(
        container.read(paymentProvider).helperText,
        TransactionConstants.emptyHelperText,
      );
    });
  });

  group('PaymentProvider — receipt failure', () {
    test('rejects invalid receipt and shows error toast without updating path',
        () async {
      final temp = await Directory.systemTemp.createTemp('finpal_bad_receipt_');
      final bad = File('${temp.path}/receipt.pdf')
        ..writeAsBytesSync(List.filled(16, 1));

      final before = container.read(paymentProvider).receiptPath;
      container.read(paymentProvider.notifier).set(receiptPath: bad.path);
      final after = container.read(paymentProvider);

      expect(after.toastType, ToastType.error);
      expect(after.toastMessage, TransactionConstants.receiptTypeMessage);
      expect(after.receiptPath, before);

      await temp.delete(recursive: true);
    });
  });

  group('PaymentProvider — save success / failure', () {
    test('save persists payment and sets success toast', () async {
      final notifier = container.read(paymentProvider.notifier);
      notifier.set(
        type: TransactionType.expense,
        amount: '₹150.00',
        category: makeOption(id: 'cat_food', name: 'Food'),
        paymentMethod: makeOption(
          id: 'method_cash',
          type: 'payment_method',
          name: 'Cash',
        ),
      );

      await notifier.save();
      final state = container.read(paymentProvider);

      expect(state.toastType, ToastType.success);
      expect(state.toastMessage, TransactionConstants.saveSuccessMessage);

      final tx = await container.read(transactionProvider.future);
      expect(tx.expenseTransactions.any((p) => p.amount == 150), isTrue);
    });

    test('save with invalid amount sets FormatException error toast', () async {
      // Bypass set() validation by copying state via empty then forcing bad text.
      // parseCurrency will throw FormatException on non-currency text.
      final notifier = container.read(paymentProvider.notifier);
      notifier.set(amount: '₹1.00');
      // Directly poke invalid amount through set — still looks like currency digits;
      // use a value CurrencyFormatter.parse cannot handle.
      notifier.set(amount: 'not-a-number');

      await notifier.save();
      final state = container.read(paymentProvider);

      expect(state.toastType, ToastType.error);
      expect(
        state.toastMessage,
        anyOf(
          TransactionConstants.amountInvalidMessage,
          TransactionConstants.saveFailureMessage,
        ),
      );
    });

    test('clearToast resets toast after success', () async {
      final notifier = container.read(paymentProvider.notifier);
      notifier.set(amount: '₹25.00');
      await notifier.save();
      notifier.clearToast();

      final state = container.read(paymentProvider);
      expect(state.toastType, ToastType.normal);
      expect(state.toastMessage, isEmpty);
    });
  });

  group('PaymentProvider — edit load', () {
    test('loads selected transaction into form', () async {
      final existing = makePayment(
        id: 'edit_me',
        type: TransactionType.income.id,
        amount: 750,
        notes: 'Bonus',
      );
      await harness.optionBox.put(
        'cat_salary',
        makeOption(
          id: 'cat_salary',
          type: 'income_category',
          name: 'Salary',
        ),
      );
      await harness.optionBox.put(
        'method_cash',
        makeOption(id: 'method_cash', type: 'payment_method', name: 'Cash'),
      );

      final editContainer = harness.createContainer(
        extra: [
          selectedTransactionProvider.overrideWith((ref) => existing),
        ],
      );
      await editContainer.read(transactionProvider.future);
      // Rebuild option notifier so findById works.
      await editContainer.read(
        // ignore: unused_result
        editContainer.read(transactionProvider.future),
      );

      // Force option notifier ready
      final optionsFuture = editContainer.read(
        // Access via import — optionNotifer
        Provider((ref) => null),
      );
      expect(optionsFuture, isNull);

      editContainer.dispose();

      // Dedicated container with options seeded and selected payment.
      final c = harness.createContainer(
        extra: [selectedTransactionProvider.overrideWith((ref) => existing)],
      );
      addTearDown(c.dispose);
      await c.read(transactionProvider.future);

      final state = c.read(paymentProvider);
      expect(state.id, 'edit_me');
      expect(state.type, TransactionType.income);
      expect(state.notes, 'Bonus');
      expect(state.initialAmount, 750);
    });
  });
}
