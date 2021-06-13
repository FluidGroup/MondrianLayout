import UIKit

#if swift(>=5.4)
@resultBuilder
public enum StackElementBuilder {
}
#else
@_functionBuilder
public enum StackElementBuilder {
}
#endif

extension StackElementBuilder {

  @_disfavoredOverload
  public static func buildBlock(_ components: VHStackElement...) -> [VHStackElement] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> VHStackElement {
    return .view(.init(view))
  }

  public static func buildExpression(_ spacer: StackSpacer) -> VHStackElement {
    return .spacer(spacer)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> VHStackElement {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: VStackConstraint) -> VHStackElement {
    return .vStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> VHStackElement {
    return .view(view)
  }
}
