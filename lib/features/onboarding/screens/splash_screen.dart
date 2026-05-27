import 'package:finpal/app/app.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: CustomImage(
          imageType: ImageType.local,
          imageUrl: AppImages.splash,
        ),
      ),
    );
  }
}
