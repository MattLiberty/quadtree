library radius2d;

import 'object_manager.dart';


abstract class ZeroDouble2DRadius {
  double get radius => 0.0;
         set radius(double value) {}

  double get width => 0.0;
         set width(double value) {}
  double get height => 0.0;
         set height(double value) {}

  void manageSize(AbstractObjectManager manager) {}
}


abstract class CustomDouble2DRadius {
  double _radius;

  double get radius => _radius;
         set radius(double value) {_radius = value;}

  double get width => _radius * 2.0;
         set width(double value) {_radius = 0.5 * value;}
  double get height => _radius * 2.0;
         set height(double value) {_radius = 0.5 * value;}

  void manageSize(AbstractObjectManager manager) {
    _radius = manager.doubleEntry("radius", _radius);
  }
}