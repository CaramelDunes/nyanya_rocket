
import 'package:nyanya_rocket/widgets/game_view/cat_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/mouse_drawer.dart';

class SynchronousController {
  double _speed = 1.0;
  double _moveTime = 0.0;

  void addGlobalTime(double elapsed) {
    _moveTime += _speed * elapsed;
    // MouseDrawer.setAnim(_moveTime);
    // CatDrawer.setAnim(_moveTime);
  }
}
