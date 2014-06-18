library custom2d;

import 'shape.dart';
import 'center.dart';
import 'corner.dart';
import 'size.dart';


class CustomInt2DBox extends AbstractInt2DShape
    with CustomInt2DCorner, CustomInt2DSize {
  CustomInt2DBox(int x, int y, int width, int height) {
    setIntCorner(x, y);
    setIntSize(width, height);
  }

  CustomInt2DBox.unit(): this(0, 0, 1, 1);
}

class CustomDouble2DBox extends AbstractDouble2DShape
    with CustomDouble2DCenter, CustomDouble2DSize {
  CustomDouble2DBox(double x, double y, double width, double height) {
    setCenter(x, y);
    setSize(width, height);
  }

  CustomDouble2DBox.unit(): this(0.0, 0.0, 1.0, 1.0);
}