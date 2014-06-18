import "shape.dart";
import "custom.dart";


abstract class Abstract2DSpacePartitioningSystem<S extends Abstract2DShape> {
  void insertShape(S shape);

  void removeShape(S shape);

  void moveShape(S shape, void movement(S shape));
}


class QuadTree<S extends Abstract2DShape>
    extends Abstract2DSpacePartitioningSystem<S>{
  QuadTreeNode<S> root;

  QuadTree(int x, int y, int size) {
    assert(size >= 2);
    root = new QuadTreeNode<S>(x, y, size, null, this);
  }

  QuadTreeNode<S> findNode(S shape) => root.findNode(shape);

  S findShape(S shape) => root.findShape(shape);
  S findShapeByRegionCoords(int x, int y, int width, int height)
      => root.findShapeByRegionCoords(x, y, width, height);

  void insertShape(S shape) {
    root.insertShape(shape);
  }

  void removeShape(S shape) {
    root.removeShape(shape);
  }

  void moveShape(S shape, void movement(S shape)) {
    root.moveShape(shape, movement);
  }

  void applyFunction(Abstract2DShape region, void func(S shape)) {
    root.applyFunction(region, func);
  }
  
  void applyFunctionToNodes(Abstract2DShape region
                            , void func(QuadTreeNode<S> node)) {
    root.applyFunctionToNodes(region, func);
  }
}


class QuadTreeNode<S extends Abstract2DShape> extends CustomInt2DBox {
  QuadTreeNode _parent;
  QuadTree _system;
  final List<QuadTreeNode> _children = new List<QuadTreeNode>(4);
  final List<S> _shapes = new List<S>();

  QuadTreeNode(int x, int y, int size, this._parent, this._system)
      : super(x, y, size, size);

  QuadTreeNode<S> findNode(S shape) {
    if(shape.leftX < intLeftX || shape.rightX > intRightX
        || shape.topY < intTopY || shape.bottomY > intBottomY ) {
      if(_parent == null) {
        int x = shape.leftX < intLeftX ? 1 : 0;
        int y = shape.topY < intTopY ? 1 : 0;
        _parent = new QuadTreeNode(intLeftX - intDiameter * x
            , intTopY - intDiameter * y, intDiameter * 2, null, _system);
        _parent._children[x + y * 2] = this;
      }
      _system.root = _parent;
      return _parent.findNode(shape);
    }
    return _findNode(shape);
  }

  QuadTreeNode<S> _findNode(S shape) {
    while(intDiameter > 2) {
      int posX = (shape.leftX < intLeftX + intRadius) ? 0 : 1;
      if(posX == 0 && shape.rightX > intLeftX + intRadius) break;
      int posY = (shape.topY < intTopY + intRadius) ? 0 : 1;
      if(posY == 0 && shape.bottomY > intTopY + intRadius) break;

      int pos = posX + posY * 2;
      QuadTreeNode<S> child = _children[pos];
      if(child == null) {
        child = new QuadTreeNode<S>(intLeftX + posX * intRadius
            , intTopY + posY * intRadius, intRadius, this, _system);
        _children[pos] = child;
      }
      return child._findNode(shape);
    }
    return this;
  }

  final serviceShape = new CustomInt2DBox.unit();
  S findShapeByRegionCoords(int x, int y, int width, int height) {
    serviceShape.setCornerCoords(x, y);
    serviceShape.setSize(width, height);
    return findShape(serviceShape);
  }

  S findShape(Abstract2DShape shape) {
    QuadTreeNode<S> node = findNode(shape);
    for(S nodeShape in node._shapes) {
      if(shape.intLeftX == nodeShape.intLeftX
          && shape.intTopY == nodeShape.intTopY
          && shape.intWidth == nodeShape.intWidth
          && shape.intHeight == nodeShape.intHeight
          ) return nodeShape;
    }
    return null;
  }

  void insertShape(S shape) {
    findNode(shape)._shapes.add(shape);
  }

  void removeShape(S shape) {
    findNode(shape)._shapes.remove(shape);
  }

  void moveShape(S shape, void movement(S shape)) {
    QuadTreeNode<S> node = findNode(shape);
    node.removeShape(shape);
    movement(shape);
    node.insertShape(shape);
  }

  void applyFunction(Abstract2DShape region, void func(S shape)) {
    if(region == null || region.overlap(this)) {
      _applyFunction(func);
    } else if (region.intersect(this)) {
      for(S nodeShape in _shapes) {
        if(region.intersect(nodeShape)) func(nodeShape);
      }
      for(int pos = 0; pos < 4; pos++) {
        QuadTreeNode<S> child = _children[pos];
        if(child != null) child.applyFunction(region, func);
      }
    }
  }

  void _applyFunction(void func(S shape)) {
    for(S nodeShape in _shapes) func(nodeShape);
    for(int pos = 0; pos < 4; pos++) {
      QuadTreeNode<S> child = _children[pos];
      if(child != null) child._applyFunction(func);
    }
  }
  
  void applyFunctionToNodes(Abstract2DShape region
                            , void func(QuadTreeNode<S> node)) {
    if(region == null || region.overlap(this)) {
      _applyFunctionToNodes(func);
    } else if (region.intersect(this)) {
      for(int pos = 0; pos < 4; pos++) {
        QuadTreeNode<S> child = _children[pos];
        if(child != null) child.applyFunctionToNodes(region, func);
      }
    }
  }
  
  void _applyFunctionToNodes(void func(QuadTreeNode<S> node)) { 
    func(this);
    for(int pos = 0; pos < 4; pos++) {
      QuadTreeNode<S> child = _children[pos];
      if(child != null) child._applyFunctionToNodes(func);
    }
  }
}
