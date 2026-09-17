import 'package:finpal/app/app.dart';

enum SplashScreenType { splash, redirecting }

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.type = SplashScreenType.splash});

  final SplashScreenType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: _buildMainWidgets(),
    );
  }

  Widget _buildMainWidgets() {
    return switch (type) {
      SplashScreenType.redirecting => Center(
        child: CustomImage(
          imageUrl: AppImages.splash,
          imageType: ImageType.local,
          height: 160.w,
        ),
      ),
      _ => Center(
        child: CustomImage(
          imageUrl: AppImages.splash,
          imageType: ImageType.local,
          height: 160.w,
        ),
      ),
    };
  }
}
