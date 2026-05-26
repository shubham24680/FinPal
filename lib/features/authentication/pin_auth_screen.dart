import 'package:finpal/app/app.dart';

class PinAuthScreen extends StatelessWidget {
  const PinAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTypography(text: "Pin Auth", fontType: FontType.h1Bold),
      ),
    );
  }
}
