import 'dart:html';

import "quadtree.dart";
import "shape.dart";
import "corner.dart";
import "diameter.dart";


const cellSize = 16;
CanvasElement canvas = new CanvasElement();
CanvasRenderingContext2D context = canvas.context2D;
QuadTree tree;


class Cell extends AbstractInt2DShape with CustomInt2DCorner
    , UnitDiameter {
  Cell(int x, int y){
    this.setIntCorner(x, y);
  }
}


void main() {
  canvas.width = 512;
  canvas.height = 512;
  document.body.append(canvas);
  canvas.onClick.listen((MouseEvent e) {
    Cell shape = new Cell((e.offset.x.toDouble() / cellSize).floor()
        , (e.offset.y.toDouble() / cellSize).floor());
    if(tree == null) {
      tree = new QuadTree(shape.intLeftX, shape.intTopY, 2);
    }
    tree.insertShape(shape);
    render();
  });
  canvas.onMouseMove.listen((MouseEvent e) {
    render();
    int x = (e.offset.x.toDouble() / cellSize).floor();
    int y = (e.offset.y.toDouble() / cellSize).floor();
    context.strokeRect(x * cellSize + 1, y * cellSize + 1
        , cellSize - 2, cellSize - 2);
  });
}

void render() {
  context
    ..setFillColorRgb(0, 0, 0)
    ..fillRect(0, 0, canvas.width, canvas.height)
    ..setFillColorRgb(255, 255, 255)
    ..setStrokeColorRgb(255, 255, 255);
  
  if(tree != null) {
    tree.applyFunction(null, (Abstract2DShape shape) {
      context.fillRect(shape.intLeftX * cellSize + 2
          , shape.intTopY * cellSize + 2, cellSize - 4, cellSize - 4);
    });
    
    tree.applyFunctionToNodes(null, (QuadTreeNode node) {
      int size = cellSize * node.intDiameter;
      context.strokeRect(node.intLeftX * cellSize, node.intTopY * cellSize
          , size, size);
    });
  }  
  context
    ..closePath()
    ..fill()
    ..stroke();
}