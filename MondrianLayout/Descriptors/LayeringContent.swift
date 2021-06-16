import UIKit

public protocol _LayeringContentConvertible {
  var _layeringContent: _LayeringContent { get }
}

public indirect enum _LayeringContent {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case relative(RelativeConstraint)
  case overlay(OverlayConstraint)
  case background(BackgroundConstraint)
}

extension _LayeringContentConvertible {

  public func background(_ view: UIView) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .view(view.viewConstraint))
  }

  public func background(_ constraint: ViewConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .view(constraint))
  }

  public func background(_ constraint: RelativeConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .relative(constraint))
  }

  public func background(_ constraint: VStackConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .vStack(constraint))
  }

  public func background(_ constraint: HStackConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .hStack(constraint))
  }

  public func background(_ constraint: ZStackConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .zStack(constraint))
  }

  public func background(_ constraint: BackgroundConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .background(constraint))
  }


  public func background(_ constraint: OverlayConstraint) -> BackgroundConstraint {
    return .init(content: _layeringContent, backgroundContent: .overlay(constraint))
  }

  public func overlay(_ view: UIView) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .view(view.viewConstraint))
  }

  public func overlay(_ constraint: ViewConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .view(constraint))
  }

  public func overlay(_ constraint: RelativeConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .relative(constraint))
  }

  public func overlay(_ constraint: VStackConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .vStack(constraint))
  }

  public func overlay(_ constraint: HStackConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .hStack(constraint))
  }

  public func overlay(_ constraint: ZStackConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .zStack(constraint))
  }

  public func overlay(_ constraint: OverlayConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .overlay(constraint))
  }

  public func overlay(_ constraint: BackgroundConstraint) -> OverlayConstraint {
    return .init(content: _layeringContent, overlayContent: .background(constraint))
  }
}

@_functionBuilder
public enum _LayeringContentBuilder {
  public typealias Component = _LayeringContent

  @_disfavoredOverload
  public static func buildBlock(_ components: Component...) -> [Component] {
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

  public static func buildExpression(_ background: BackgroundConstraint) -> Component {
    return .background(background)
  }

  public static func buildExpression(_ overlay: OverlayConstraint) -> Component {
    return .overlay(overlay)
  }
}
