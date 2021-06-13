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
    return MultipleElements(components: components)
  }

  public static func buildExpression<View: UIView>(_ view: View) -> SingleElement<View> {
    return SingleElement(view: view)
  }

 public static func buildExpression<Component: ConstraintLayoutElementType>(
    _ component: Component
  ) -> Component {
    component
  }

}

public enum Edge {
  case element(ConstraintLayoutElementType)
  case elements([ConstraintLayoutElementType])
}

public protocol ConstraintLayoutElementType {

}
