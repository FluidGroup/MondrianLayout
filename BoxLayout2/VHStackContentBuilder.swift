import UIKit

public enum _VHStackContent {

  case view(ViewConstraint)
  case relative(RelativeConstraint)
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

  public typealias Component = _VHStackContent

  @_disfavoredOverload
  public static func buildBlock(_ components: Component...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
  }

  public static func buildExpression(_ spacer: StackSpacer) -> Component {
    return .spacer(spacer)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> Component {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: VStackConstraint) -> Component {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: ZStackConstraint) -> Component {
    return .zStack(stack)
  }

  public static func buildExpression(_ stack: RelativeConstraint) -> Component {
    return .relative(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> _VHStackContent {
    return .view(view)
  }
}
