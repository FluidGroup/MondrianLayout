import UIKit

#if swift(>=5.4)
@resultBuilder
public enum ZStackElementBuilder {
}
#else
@_functionBuilder
public enum ZStackElementBuilder {
}
#endif

extension ZStackElementBuilder {

  public typealias Component = _ZStackElement

  @_disfavoredOverload
  public static func buildBlock(_ components: _ZStackElement...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
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

  public static func buildExpression(_ view: ViewConstraint) -> Component {
    return .view(view)
  }
}

