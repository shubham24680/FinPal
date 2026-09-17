import 'package:finpal/app/app.dart';

class ProfileProgress {
  final List<ProfileContentModel> steps;
  const ProfileProgress({required this.steps});

  int get current {
    final index = steps.indexWhere((s) => !s.isCompleted);
    return index == -1 ? steps.length - 1 : index;
  }
  int get completed => steps.where((s) => s.isCompleted).length;
  int get total => steps.length;
  double get fraction => total == 0 ? 0 : completed / total;
  int get percent => (fraction * 100).round();
  bool get isComplete => completed == total;
}
