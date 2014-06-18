library center2d;

import 'object_manager.dart';


abstract class ZeroDouble2DCenter {
  double get centerX => 0.0;
         set centerX(double value) {}
  double get centerY => 0.0;
         set centerY(double value) {}
  double get leftX => -0.5 * width;
         set leftX(double value) {}
  double get topY => -0.5 * height;
         set topY(double value) {}
  double get rightX => 0.5 * width;
         set rightX(double value) {}
  double get bottomY => 0.5 * height;
         set bottomY(double value) {}

  double get width;
  double get height;

  void managePosition(AbstractObjectManager manager) {}
}


abstract class CustomDouble2DCenter {
  double _x, _y;

  double get centerX => _x;
         set centerX(double value) {_x = value;}
  double get centerY => _y;
         set centerY(double value) {_y = value;}
  double get leftX => _x - 0.5 * width;
         set leftX(double value) {_x = value + 0.5 * width;}
  double get topY => _y - 0.5 * height;
         set topY(double value) {_y = value + 0.5 * height;}
  double get rightX => _x + 0.5 * width;
         set rightX(double value) {_x = value - 0.5 * width;}
  double get bottomY => _y + 0.5 * height;
         set bottomY(double value) {_y = value - 0.5 * height;}

  double get width;
  double get height;

  void setCenter(double x, double y){
    _x = x;
    _y = y;
  }

  void managePosition(AbstractObjectManager manager) {
    _x = manager.doubleEntry("x", _x);
    _y = manager.doubleEntry("y", _y);
  }
}