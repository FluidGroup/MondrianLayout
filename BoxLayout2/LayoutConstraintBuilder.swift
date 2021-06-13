import UIKit

#if swift(>=5.4)
@resultBuilder
public enum LayoutConstraintBuilder {
}
#else
@_functionBuilder
public enum LayoutConstraintBuilder {
}
#endif

extension LayoutConstraintBuilder {

  public static func buildBlock<Component: ConstraintLayoutElementType>(
    _ component: Component
  ) -> Component {
    component
  }

  @_disfavoredOverload
  public static func buildBlock(_ components: ConstraintLayoutElementType...) -> MultipleElements {
    fatalError()
  }

  public static func buildExpression(_ expression: UIView) -> SingleElement {
    fatalError()
  }

 public static func buildExpression<Component: ConstraintLayoutElementType>(
    _ component: Component
  ) -> Component {
    component
  }

}

public protocol ConstraintLayoutElementType {

}
