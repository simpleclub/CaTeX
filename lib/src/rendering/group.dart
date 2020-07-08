import 'dart:math';
import 'dart:ui';

import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/spacing.dart';
import 'package:catex/src/parsing/group.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/rendering/functions/raise_box.dart';
import 'package:catex/src/rendering/functions/sub_sup.dart';
import 'package:catex/src/rendering/rendering.dart';

/// Renders a [GroupNode].
class RenderGroup extends RenderNode {
  /// Constructs a [RenderGroup] given a [context] and a [mode].
  RenderGroup(
    CaTeXContext context,
    this.mode,
  ) : super(context);

  // todo: remove workaround soltion
  /// The [CaTeXMode] this group should be configured in.
  ///
  /// In [CaTeXMode.text], character spacing is ignored.
  final CaTeXMode mode;

  /// Positions the children in a row and positions
  /// them about a common center line vertically.
  @override
  void configure() {
    // This height is used for the initial combined height before any vertical
    // shifts are applied to child nodes.
    var initialHeight = .0;
    var width = .0;

    // Find out the height that is needed first.
    for (final child in children) {
      initialHeight = max(
        initialHeight,
        sizeChildNode(child).height,
      );
    }

    // These are used to cover w/e vertical shifts are applied to child nodes.
    var heightTopOverflow = .0, heightBottomOverflow = .0;

    RenderNode previousChild;
    // Position all children centered based on
    // the height that was retrieved before.
    // Additionally, accumulate the total width and position
    // the children horizontally based on that width.
    for (final child in children) {
      final size = child.renderSize,
          dy =
              // Divide the space that would be missing at the bottom
              // if the child was positioned at y=0 by two and
              // bump the child down by that value. This will center it.
              (initialHeight - size.height) / 2,
          dyShifted = dy + _subSupAddend(child) + _raiseBoxAddend(child);

      // Symbols can cause extra spacing and
      // interact with characters in that way.
      var symbolSpacing = .0;
      if (mode == CaTeXMode.math && previousChild != null) {
        symbolSpacing = pixelSpacingFromCharacters(
          previous: previousChild.context.input,
          current: child.context.input,
          fontSize: context.textSize,
        );
      }

      // If the current and the previous child are RenderSubSup, we can
      // assume that the previous child was sub and the current is sup.
      // In this case the current child is shifted by the width of previous
      // child to left. This way both are horizontally well aligned.
      var dxShift = .0;
      if (previousChild is RenderSubSup && child is RenderSubSup) {
        dxShift = -previousChild.renderSize.width;
      }

      child.positionNode(Offset(
        width + symbolSpacing + dxShift,
        dyShifted,
      ));
      width += size.width + symbolSpacing + dxShift;

      // todo(creativecreatorormaybenot): remove redundancies
      if (child is RenderSubSup) {
        if (CharacterCategory.superscript.matches(child.context.input)) {
          heightTopOverflow = max(heightTopOverflow, -dyShifted);
        } else {
          heightBottomOverflow = max(
              heightBottomOverflow, (dyShifted + size.height) - initialHeight);
        }
      } else if (child is RenderRaiseBox) {
        final verticalShift = child.shift;
        if (verticalShift < 0) {
          heightTopOverflow = max(heightTopOverflow, -dyShifted);
        } else {
          heightBottomOverflow = max(
              heightBottomOverflow, (dyShifted + size.height) - initialHeight);
        }
      }

      previousChild = child;
    }

    // If there is an overflow at the top, all children need to be bumped
    // down by that overflow again.
    if (heightTopOverflow > 0) {
      for (final child in children) {
        child.positionNode(
            child.parentData.offset + Offset(0, heightTopOverflow));
      }
    }

    renderSize = Size(
      width,
      initialHeight + heightTopOverflow + heightBottomOverflow,
    );
  }

  // todo: determine shift properly
  // (some system already partially setup but unsupported).
  static const _supFactor = 0.28, _subFactor = 0.238;

  /// Shift the child vertically if it is a [RenderSubSup].
  double _subSupAddend(RenderNode child) {
    if (child is RenderSubSup) {
      // Size a painter with the unmodified context (normal text size)
      // and a mock character in order to get a context for the required shift.
      final contextSize = mockCharacterSize(context);

      if (CharacterCategory.superscript.matches(child.context.input)) {
        return -contextSize.height * _supFactor;
      } else {
        return contextSize.height * _subFactor;
      }
    }
    return 0;
  }

  double _raiseBoxAddend(RenderNode child) {
    if (child is RenderRaiseBox) {
      return child.shift;
    }
    return 0;
  }

  @override
  void render(Canvas canvas) {
    for (final child in children) {
      paintChildNode(child);
    }
  }
}

/// Returns the size for a mock character in the given [context].
Size mockCharacterSize(CaTeXContext context) {
  return (TypesetPainter(context.copyWith(
    input: 'O',
  ))
        ..layout())
      .size;
}
