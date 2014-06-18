library size2d;

import 'dart:math';

import 'object_manager.dart';


abstract class CustomInt2DSize {
  int _width, _height;

  int get intDiameter => max(_width, _height);
  set intDiameter(int value) {
    _width = value;
  }

  int get intWidth => _width;
  set intWidth(int value) {
    _width = value;
  }
  int get intHeight => _height;
  set intHeight(int value) {
    _height = value;
  }

  void manageSize(AbstractObjectManager manager) {
    _width = manager.intEntry("width", _width);
    _height = manager.intEntry("height", _height);
  }

  void setIntSize(int width, int height) {
    _width = width;
    _height = height;
  }
}


abstract class CustomDouble2DSize {
  double _width, _height;

  double get radius => 0.5 * max(_width, _height);
  set radius(double value) {
    _width = 2.0 * value;
    _height = 2.0 * value;
  }

  double get width => _width;
  set width(double value) {
    _width = value;
  }
  double get height => _height;
  set height(double value) {
    _height = value;
  }

  void manageSize(AbstractObjectManager manager) {
    _width = manager.doubleEntry("width", _width);
    _height = manager.doubleEntry("height", _height);
  }

  void setSize(double width, double height) {
    _width = width;
    _height = height;
  }
}
