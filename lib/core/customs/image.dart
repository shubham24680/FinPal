import 'package:finpal/app/app.dart';
import 'package:finpal/core/extensions/gesture_extenstion.dart';

enum ImageType { local, svgLocal }

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    this.imageType = ImageType.local,
    this.imageUrl,
    this.borderRadius = BorderRadius.zero,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.height,
    this.width,
    this.onClick,
    this.color,
  });

  final ImageType imageType;
  final String? imageUrl;
  final BorderRadius borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final void Function()? onClick;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final image = switch (imageType) {
      ImageType.svgLocal => SvgPicture.asset(
        imageUrl ?? AppSvgs.arrowLeft,
        colorFilter:
            (color != null) ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
      ),
      ImageType.local => Image.asset(
        imageUrl ?? AppImages.placeholderImage,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
      ),
    };

    if (onClick == null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: image,
    ).onTap(event: onClick);
  }
}
