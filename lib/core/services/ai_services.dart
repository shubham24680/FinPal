import 'package:finpal/app/app.dart';

class AiServices {
  final Dio dio = Dio();
  static AiServices? _instance;
  AiServices._();
  static AiServices get instance => _instance ??= AiServices._();
}
