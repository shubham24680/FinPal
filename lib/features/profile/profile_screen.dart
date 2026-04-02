import 'package:finpal/app/app.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.sidePadding),
        child: Column(
          children: [
            CustomTypography(text: "Profile", fontType: FontType.h1Bold),
          ],
        ),
      ),
    );
  }
}
