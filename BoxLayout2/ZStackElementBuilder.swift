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

  @_disfavoredOverload
  public static func buildBlock(_ components: _ZStackElement...) -> [_ZStackElement] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> _ZStackElement {
    return .view(.init(view))
  }
  
  public static func buildExpression(_ stack: HStackConstraint) -> _ZStackElement {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: VStackConstraint) -> _ZStackElement {
    return .vStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> _ZStackElement {
    return .view(view)
  }
}

