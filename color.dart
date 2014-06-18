library color;

import "dart:html";

class Color {
  static final Color white = new Color(255, 255, 255);
  static final Color black = new Color(0, 0, 0);

  int r, g, b;

  Color(this.r, this.g, this.b);

  Color.grey(int intensity): this(intensity, intensity, intensity);

  void setFillColor(CanvasRenderingContext2D context){
    context.setFillColorRgb(r, g, b);
  }

  void setStrokeColor(CanvasRenderingContext2D context){
    context.setStrokeColorRgb(r, g, b);
  }
}