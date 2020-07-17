import 'dart:math';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/exception.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:flutter/rendering.dart';

// todo(creativecreatorormaybenot): use a single render object class for all
// todo| nodes and create a custom class that has the configuration and
// todo| rendering method + the necessary properties. This ensures that every
// todo| node uses only the correct members.
// todo| https://github.com/simpleclub/CaTeX/issues/41
/// Abstract class for all render nodes.
///
/// A sub class should implement [configure] and [render].
abstract class RenderNode<P extends NodeParentData> extends RenderBox
    with
        ContainerRenderObjectMixin<RenderNode, P>,
        RenderBoxContainerDefaultsMixin<RenderNode, P> {
  /// Constructs a [RenderNode] from a [context].
  RenderNode(this.context);

  /// Context for this node that stores all necessary information
  /// for rendering the node.
  final CaTeXContext context;

  /// Handles sizing of the render node.
  ///
  /// This is the step when [TextPainter] et al.
  /// are created, which is necessary for sizing.
  ///
  /// Furthermore, all children have to be sized using
  /// their [RenderNode.sizeNode] method and positioned using
  /// their [RenderNode.positionNode] method. This render node
  /// has to declare its size using [renderSize].
  ///
  /// I would have loved to call this `size` instead,
  /// however, [RenderBox.size] prevents it :/
  ///
  /// This is called from [performLayout].
  void configure();

  /// Renders this node.
  ///
  /// The [canvas] is translated to the position of this node.
  /// Use [paintChildNode] to paint the children.
  ///
  /// [configure] will always be called before [render], but not every time.
  ///
  /// This is called from [paint].
  void render(Canvas canvas);

  /// Sizes this render node and returns its size.
  ///
  /// This should be used in [configure] when sizing children.
  /// It calls [RenderBox.layout] with no constraints
  /// (see [RenderTree.performLayout]) and configures the [renderSize].
  Size sizeChildNode(RenderNode child) {
    assert(constraints != null, 'Do no call sizeChildNode on a child.');
    child._renderSize = null;
    child.layout(constraints);
    return child.renderSize;
  }

  /// Positions this render node.
  ///
  /// This should be called in [configure] on children to position them.
  void positionNode(Offset offset) {
    parentData.offset = offset;

    // Ignoring use_setters_to_change_properties does not work. Hence,
    // this unnecessary statement makes the linter think that this method
    // does more than change the property. The tree shaker will remove it
    // anyway.
    // ignore: unnecessary_statements
    Null;
  }

  /// Allows to paint a child node in [render].
  void paintChildNode(RenderNode child) {
    _context.paintChild(child, child.parentData.offset);
  }

  /// List of child [RenderNode]s.
  List<RenderNode> children;

  Size _renderSize;

  /// The size that CaTeX determines for this node.
  Size get renderSize => _renderSize;

  set renderSize(Size value) {
    assert(_renderSize == null,
        'Only assign the size once every configuration call.');

    if (value == _renderSize) return;
    _renderSize = value;
  }

  @override
  set size(Size value) {
    assert(false, 'Assign to renderSize to size a render node.');
    super.size = value;
  }

  @override
  void setupParentData(RenderNode child) {
    if (child.parentData is! NodeParentData) {
      child.parentData = NodeParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    parentData.context = context;
  }

  @override
  NodeParentData get parentData => super.parentData as NodeParentData;

  @override
  bool get sizedByParent => false;

  /// Absorbs every hit immediately without
  /// performing hit detection or handling.
  ///
  /// This is because CaTeX does not respond to hit events.
  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) => true;

  @override
  void performLayout() {
    children = [];

    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData as P;

      children.add(child);

      child = parentData.nextSibling;
    }

    assert(_renderSize == null, 'Use sizeChildNode to size children.');
    configure();
    assert(_renderSize != null,
        'Render nodes need to set renderSize in configure.');

    super.size = Size(
      min(constraints.biggest.width,
          max(constraints.smallest.width, _renderSize.width)),
      min(constraints.biggest.height,
          max(constraints.smallest.height, _renderSize.height)),
    );
  }

  PaintingContext _context;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Save the context and offset during render to enable [paintChild].
    _context = context;
    render(canvas);
    _context = null;

    canvas.restore();
  }
}

/// Mixin for render nodes that are created from a [SingleChildNode].
///
/// Provides easy access to the [child] and by default also
/// implements [RenderNode.configure] and [RenderNode.paint] by simply
/// delegating it to the child without modification.
mixin SingleChildRenderNodeMixin<P extends NodeParentData> on RenderNode<P> {
  RenderNode get child => children[0];

  @override
  void configure() {
    renderSize = sizeChildNode(child);
  }

  @override
  void render(Canvas canvas) {
    paintChildNode(child);
  }
}

class NodeParentData extends ContainerBoxParentData<RenderNode> {
  CaTeXContext _context;

  CaTeXContext get context {
    assert(_context != null,
        'A render node must assign a non-null context in attach.');
    return _context;
  }

  set context(CaTeXContext value) {
    assert(value != null);

    if (value == _context) return;
    _context = value;
  }
}

/// Renders the node tree, inserting a repaint boundary between the nodes
/// and the rest of the widget tree and also tells the compositor to cache it.
class RenderTree extends RenderBox with RenderObjectWithChildMixin<RenderNode> {
  /// Constructs [RenderTree].
  RenderTree(CaTeXContext context)
      : assert(context != null),
        _context = context;

  CaTeXContext _context;

  CaTeXContext get context => _context;

  set context(CaTeXContext value) {
    if (_context == value) return;

    _context = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! NodeParentData) {
      child.parentData = NodeParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  RenderNode<NodeParentData> get child => super.child;

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) => true;

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    // Do not visit the tree for semantic information. The configuration for
    // the whole tree is applied in [describeSemanticsConfiguration].
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config
      ..isSemanticBoundary = true
      ..isMergingSemanticsOfDescendants = true
      ..isReadOnly = true
      ..textDirection = TextDirection.ltr
      ..label = _context.input;
  }

  static const _commonLayoutExceptionSuffix = 'for CaTeX to take up '
      'or decreasing the context size to make the output smaller '
      '(note that CaTeX ignores this error on purpose, i.e. CaTeX simply '
      'clips the output, which probably provides the best user experience, '
      'however, *you* should **not ignore** this error. It means that your '
      'user will not be able to see the whole CaTeX output. Additionally, '
      'note that the overflow is still rendered, just clipped. Thus, having '
      'an overflow is not optimal for performance.)';

  Size _treeSize;

  /// Does a mock layout pass and returns the size the tree would need to be
  /// painted without clipping.
  Size _computeIntrinsicDimensions() {
    /// Not considering the width as the only effect of that would be throwing
    /// the exception about clipping. That exception will then be thrown again
    /// during the actual layout phase - so we can just ignore the constraints
    /// here as they will not alter the _treeSize.
    layout(const BoxConstraints());
    return _treeSize;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(height >= 0);
    return _computeIntrinsicDimensions().width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(height >= 0);
    return _computeIntrinsicDimensions().width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(width >= 0);
    return _computeIntrinsicDimensions().height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(width >= 0);
    return _computeIntrinsicDimensions().height;
  }

  @override
  void performLayout() {
    child.parentData.offset = Offset.zero;

    child._renderSize = null;
    // We do not care about the constraints for the children. If the
    // tree turns out to take up too much space, we will simply clip it
    // and inform the developer that there is not enough space.
    child.layout(constraints);
    _treeSize = child.renderSize;

    size = Size(
      min(constraints.maxWidth, max(constraints.minWidth, _treeSize.width)),
      min(constraints.maxHeight, max(constraints.minHeight, _treeSize.height)),
    );

    // Throwing the exceptions here will make sure that the developer can
    // see that the rendered output overflows and still render the result.
    // This means that effectively these exceptions do not interrupt rendering
    // at all. The output is simply clipped.
    if (_treeSize.width > constraints.maxWidth &&
        _treeSize.height > constraints.maxHeight) {
      throw RenderingException(
        reason: 'Tree exceeds both the width constraint (actual: '
            '${_treeSize.width}; constraint: ${constraints.maxWidth}) '
            'and the height constraint (actual: ${_treeSize.height}; '
            'constraint: ${constraints.maxHeight}); '
            'the output will be clipped - consider providing '
            'larger width and height constraints $_commonLayoutExceptionSuffix',
        input: child.context.input,
      );
    }
    if (_treeSize.width > constraints.maxWidth) {
      throw RenderingException(
        reason: 'Tree exceeds the width constraint (actual: '
            '${_treeSize.width}; constraint: ${constraints.maxWidth}); '
            'the output will be clipped - consider providing a larger '
            'width constraint $_commonLayoutExceptionSuffix',
        input: child.context.input,
      );
    } else if (_treeSize.height > constraints.maxHeight) {
      throw RenderingException(
        reason: 'Tree exceeds the height constraint '
            '(actual: ${_treeSize.height}; constraint: '
            '${constraints.maxHeight}); the output will be clipped - consider '
            'providing a larger height constraint '
            '$_commonLayoutExceptionSuffix',
        input: child.context.input,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Tell the compositor to cache the whole tree.
    context.setIsComplexHint();

    // Even if the tree overflows, render it anyway and clip the overflow.
    // This is a very easy solution.
    context.clipRectAndPaint(offset & size, Clip.hardEdge, null, () {
      context.paintChild(child, offset + child.parentData.offset);
    });
  }
}
