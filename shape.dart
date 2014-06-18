library shape2d;

import 'object_manager.dart';
import 'color.dart';


abstract class Abstract2DShape implements Serializable {
  double get centerX;
         set centerX(double value);
  double get centerY;
         set centerY(double value);

  double get radius;
         set radius(double value);
  double get diameter;
         set diameter(double value);

  double get width;
         set width(double value);
  double get height;
         set height(double value);

  double get leftX;
         set leftX(double value);
  double get rightX;
         set rightX(double value);
  double get topY;
         set topY(double value);
  double get bottomY;
         set bottomY(double value);


  int get intCenterX;
      set intCenterX(int value);
  int get intCenterY;
      set intCenterY(int value);

  int get intRadius;
      set intRadius(int value);
  int get intDiameter;
      set intDiameter(int value);

  int get intWidth;
      set intWidth(int value);
  int get intHeight;
      set intHeight(int value);

  int get intLeftX;
      set intLeftX(int value);
  int get intRightX;
      set intRightX(int value);
  int get intTopY;
      set intTopY(int value);
  int get intBottomY;
      set intBottomY(int value);


  Color get color => Color.white;


  bool intersect(Abstract2DShape shape);
  bool overlap(Abstract2DShape shape);

  void manage(AbstractObjectManager manager) {
    managePosition(manager);
    manageSize(manager);
  }

  void managePosition(AbstractObjectManager manager);
  void manageSize(AbstractObjectManager manager);
}


abstract class AbstractDouble2DShape extends Abstract2DShape {
  double get diameter => 2.0 * radius;
         set diameter(double value) {radius = 0.5 * value;}

  int get intRadius => radius.toInt();
      set intRadius(int value) {radius = value.toDouble();}
  int get intDiameter => diameter.toInt();
      set intDiameter(int value) {diameter = value.toDouble();}

  int get intCenterX => centerX.toInt();
      set intCenterX(int value) {centerX = value.toDouble();}
  int get intCenterY => centerY.toInt();
      set intCenterY(int value) {centerY = value.toDouble();}

  int get intWidth => centerX.toInt();
      set intWidth(int value) {width = value.toDouble();}
  int get intHeight => centerY.toInt();
      set intHeight(int value) {height = value.toDouble();}

  int get intLeftX => leftX.toInt();
      set intLeftX(int value) {leftX = value.toDouble();}
  int get intRightX => rightX.toInt();
      set intRightX(int value) {rightX = value.toDouble();}
  int get intTopY => topY.toInt();
      set intTopY(int value) {topY = value.toDouble();}
  int get intBottomY => bottomY.toInt();
      set intBottomY(int value) {bottomY = value.toDouble();}


  bool intersect(Abstract2DShape shape) {
    return (leftX >= shape.rightX || rightX <= shape.leftX
        || topY >= shape.bottomY || bottomY <= shape.topY) ? false : true;
  }

  bool overlap(Abstract2DShape shape) {
    return (leftX >= shape.leftX && rightX <= shape.rightX
        && topY >= shape.topY && bottomY <= shape.bottomY) ? true : false;
  }
}


abstract class AbstractInt2DShape extends Abstract2DShape {
  double get centerX => intCenterX.toDouble();
         set centerX(double value) {
           intLeftX = (value - 0.5 * intWidth).toInt();
         }
  double get centerY => intCenterY.toDouble();
         set centerY(double value) {
           intTopY = (value - 0.5 * intHeight).toInt();
         }

  double get radius => intRadius.toDouble();
         set radius(double value) {intDiameter = 2 * value.toInt();}
  double get diameter => 2.0 * radius;
         set diameter(double value) {intDiameter = value.toInt();}

  double get width => intWidth.toDouble();
         set width(double value) {intWidth = value.toInt();}
  double get height => intHeight.toDouble();
         set height(double value) {intHeight = value.toInt();}

  double get leftX => intLeftX.toDouble();
         set leftX(double value) {intLeftX = value.toInt();}
  double get rightX => intRightX.toDouble();
         set rightX(double value) {intRightX = value.toInt();}
  double get topY => intTopY.toDouble();
         set topY(double value) {intTopY = value.toInt();}
  double get bottomY => intBottomY.toDouble();
         set bottomY(double value) {intBottomY = value.toInt();}


  int get intRadius => intDiameter ~/ 2;
      set intRadius(int value) {intDiameter = 2 * value;}

  int get intCenterX => intLeftX + intWidth ~/ 2;
      set intCenterX(int value) {intLeftX = value - intWidth ~/ 2;}
  int get intCenterY => intCenterY + intHeight ~/ 2;
      set intCenterY(int value) {intLeftX = value - intHeight ~/ 2;}

  int get intRightX => intLeftX + intWidth;
      set intRightX(int value) {intLeftX = value - intWidth;}
  int get intBottomY => intTopY + intHeight;
      set intBottomY(int value) {intTopY = value - intHeight;}


  bool intersect(Abstract2DShape shape) {
    return (intLeftX >= shape.rightX || rightX <= shape.intLeftX
        || intTopY >= shape.intBottomY || intBottomY <= shape.intTopY)
        ? false : true;
  }

  bool overlap(Abstract2DShape shape) {
    return (intLeftX >= shape.intLeftX && rightX <= shape.rightX
        && intTopY >= shape.intTopY && intBottomY <= shape.intBottomY)
        ? true : false;
  }
}