import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}
