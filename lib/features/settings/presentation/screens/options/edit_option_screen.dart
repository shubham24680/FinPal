import 'package:finpal/app/app.dart';

class EditOptionScreen extends StatelessWidget {
  const EditOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Edit Option"),
      body: Column(
        children: [
          CustomTypography(text: "Edit Option", fontType: FontType.body1Medium),
        ],
      ),
    );
  }
}