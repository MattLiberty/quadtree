library corner2d;

import 'object_manager.dart';


abstract class Zero2DCorner {
  double get leftX => 0.0;
         set leftX(double value) {}
  double get topY => 0.0;
         set topY(double value) {}
      
  int get intLeftX => 0;
      set intLeftX(int value) {}
  int get intTopY => 0;
      set intTopY(int value) {}

  void managePosition(AbstractObjectManager manager) {}
}


abstract class CustomInt2DCorner {
  int _x, _y;

  int get intLeftX => _x;
      set intLeftX(int value) {_x = value;}
  int get intTopY => _y;
      set intTopY(int value) {_y = value;}

  void managePosition(AbstractObjectManager manager) {
    _x = manager.intEntry("x", _x);
    _y = manager.intEntry("y", _y);
  }

  void setIntCorner(int x, int y){
    _x = x;
    _y = y;
  }
}


abstract class CustomDouble2DCorner {
  double _x, _y;

  double get leftX => _x;
         set leftX(double value) {_x = value;}
  double get topY => _y;
         set topY(double value) {_y = value;}
  double get rightX => _x + width;
         set rightX(double value) {_x = value - width;}
  double get bottomY => _y + height;
         set bottomY(double value) {_y = value - height;}
  double get centerX => _x + 0.5 * width;
         set centerX(double value) {_x = value - 0.5 * width;}
  double get centerY => _y + 0.5 * height;
         set centerY(double value) {_y = value - 0.5 * height;}

  double get width;
  double get height;

  void managePosition(AbstractObjectManager manager) {
    _x = manager.doubleEntry("x", _x);
    _y = manager.doubleEntry("y", _y);
  }

  void setIntCorner(double x, double y){
    _x = x;
    _y = y;
  }
}