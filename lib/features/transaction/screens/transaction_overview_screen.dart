import 'package:finpal/app/app.dart';

class TransactionOverviewScreen extends StatelessWidget {
  const TransactionOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Transaction Overview"),
    );
  }
}
