import 'package:finpal/app/app.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.sidePadding),
        child: Column(
          children: [
            CustomTypography(text: "Transaction", fontType: FontType.h1Bold),
          ],
        ),
      ),
    );
  }
}
