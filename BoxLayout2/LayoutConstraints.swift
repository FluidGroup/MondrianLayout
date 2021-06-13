
import UIKit

public struct SingleElement: ConstraintLayoutElementType {

  private let view: UIView

  public init(view: UIView) {
    self.view = view
  }
}

public struct MultipleElements: ConstraintLayoutElementType {

  public init() {

  }
  
}

public struct VStackConstraint<Content: ConstraintLayoutElementType>: ConstraintLayoutElementType {

  public init(
    @LayoutConstraintBuilder content: () -> Content
  ) {
    content()
  }

}

public struct HStackConstraint<Content: ConstraintLayoutElementType>: ConstraintLayoutElementType {

  public init(
    @LayoutConstraintBuilder content: () -> Content
  ) {
    content()
  }

}

public struct ZStackConstraint<Content: ConstraintLayoutElementType>: ConstraintLayoutElementType {

  public init(
    @LayoutConstraintBuilder content: () -> Content
  ) {
    content()
  }

}
