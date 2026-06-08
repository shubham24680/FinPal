import 'package:finpal/app/app.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CustomImage(
          imageUrl: AppImages.splash,
          imageType: ImageType.local,
          height: 160.w,
        ),
      ),
    );
  }
}
