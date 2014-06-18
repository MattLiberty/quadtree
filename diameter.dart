library diameter2d;

import 'object_manager.dart';


abstract class UnitDiameter {
  int get intDiameter => 1;
      set intDiameter(int value) {}

  int get intWidth => 1;
      set intWidth(int value) {}
  int get intHeight => 1;
      set intHeight(int value) {}
      
  double get radius => 0.5;
         set radius(double value) {}
  double get diameter => 1.0;
         set diameter(double value) {}

  double get width => 1.0;
         set width(double value) {}
  double get height => 1.0;
         set height(double value) {}

  void manageSize(AbstractObjectManager manager) {}
}


abstract class CustomIntDiameter {
  int _diameter;

  int get intDiameter => _diameter;
      set intDiameter(int value) {_diameter = value;}

  int get intWidth => _diameter;
      set intWidth(int value) {_diameter = value;}
  int get intHeight => _diameter;
      set intHeight(int value) {_diameter = value;}
  
  void setIntDiameter(int diameter) {
    _diameter = diameter;
  }
  
  void manageSize(AbstractObjectManager manager) {
    _diameter = manager.intEntry("diameter", _diameter);
  }
}