import UIKit

public enum _VHStackContent {

  case view(ViewConstraint)
  case relative(RelativeConstraint)
  case spacer(SpaceConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case background(BackgroundConstraint)
  case overlay(OverlayConstraint)
}

public struct _VStackItem {

  public let content: _VHStackContent
  public var alignSelf: VStackConstraint.HorizontalAlignment?
}

public struct _HStackItem {

  public let content: _VHStackContent
  public var alignSelf: HStackConstraint.VerticalAlignment?

}

public protocol _VHStackItemContentConvertible {
  var vhStackItemContent: _VHStackContent { get }
}

extension _VHStackItemContentConvertible {

  public func alignSelf(_ alignment: VStackConstraint.HorizontalAlignment) -> _VStackItem {
    var item = _VStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

  public func alignSelf(_ alignment: HStackConstraint.VerticalAlignment) -> _HStackItem {
    var item = _HStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

}

extension ViewConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .view(self)
  }
}

extension RelativeConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .relative(self)
  }
}

extension VStackConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .vStack(self)
  }
}

extension HStackConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .hStack(self)
  }
}

extension ZStackConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .zStack(self)
  }
}

extension BackgroundConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .background(self)
  }
}

extension OverlayConstraint: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .overlay(self)
  }
}

@_functionBuilder
public enum VStackContentBuilder {
  public typealias Component = _VStackItem

  @_disfavoredOverload
  public static func buildBlock(_ components: Component...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .init(content: .view(.init(view)))
  }

  public static func buildExpression(_ item: Component) -> Component {
    return item
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> Component {
    return .init(content: source.vhStackItemContent)
  }

  public static func buildExpression(_ spacer: SpaceConstraint) -> Component {
    return .init(content: .spacer(spacer))
  }

}

@_functionBuilder
public enum HStackContentBuilder {
  public typealias Component = _HStackItem

  @_disfavoredOverload
  public static func buildBlock(_ components: Component...) -> [Component] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .init(content: .view(.init(view)))
  }

  public static func buildExpression(_ item: Component) -> Component {
    return item
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> Component {
    return .init(content: source.vhStackItemContent)
  }

  public static func buildExpression(_ spacer: SpaceConstraint) -> Component {
    return .init(content: .spacer(spacer))
  }

}
