import 'dart:math';
import 'dart:ui';

import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/spacing.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/rendering/functions/sub_sup.dart';
import 'package:catex/src/rendering/rendering.dart';

class RenderGroup extends RenderNode {
  RenderGroup(CaTeXContext context) : super(context);

  /// Positions the children in a row and positions
  /// them about a common center line vertically.
  @override
  void configure() {
    var height = .0, width = .0;

    // Find out the height that is needed first.
    for (final child in children) {
      height = max(
        height,
        sizeChildNode(child).height,
      );
    }

    RenderNode previousChild;
    var subSupTopOverflow = .0, subSupBottomOverflow = .0;
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
              (height - size.height) / 2,
          dyShifted = dy + _subSupAddend(child);

      // Symbols can cause extra spacing and
      // interact with characters in that way.
      var symbolSpacing = .0;
      if (previousChild != null) {
        symbolSpacing = pixelSpacingFromCharacters(
          previous: previousChild.context.input,
          current: child.context.input,
          fontSize: context.textSize,
        );
      }

      child.positionNode(Offset(
        width + symbolSpacing,
        dyShifted,
      ));
      width += size.width + symbolSpacing;

      if (child is RenderSubSup) {
        if (CharacterCategory.superscript.matches(child.context.input)) {
          subSupTopOverflow = max(subSupTopOverflow, -dyShifted);
        } else {
          subSupBottomOverflow =
              max(subSupBottomOverflow, (dyShifted + size.height) - height);
        }
      }

      previousChild = child;
    }

    // If there is an overflow at the top, all children need to be bumped
    // down by that overflow again.
    if (subSupTopOverflow > 0) {
      for (final child in children) {
        child.positionNode(
            child.parentData.offset + Offset(0, subSupTopOverflow));
      }
    }

    renderSize = Size(
      width,
      height + subSupTopOverflow + subSupBottomOverflow,
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
