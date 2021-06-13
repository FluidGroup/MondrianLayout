import UIKit

public enum _VHStackContent {

  case view(ViewConstraint)
  case spacer(StackSpacer)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
}

#if swift(>=5.4)
@resultBuilder
public enum VHStackContentBuilder {
}
#else
@_functionBuilder
public enum VHStackElementBuilder {
}
#endif

extension VHStackContentBuilder {

  @_disfavoredOverload
  public static func buildBlock(_ components: _VHStackContent...) -> [_VHStackContent] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> _VHStackContent {
    return .view(.init(view))
  }

  public static func buildExpression(_ spacer: StackSpacer) -> _VHStackContent {
    return .spacer(spacer)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> _VHStackContent {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: VStackConstraint) -> _VHStackContent {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: ZStackConstraint) -> _VHStackContent {
    return .zStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> _VHStackContent {
    return .view(view)
  }
}
