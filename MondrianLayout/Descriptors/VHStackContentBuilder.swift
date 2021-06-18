import UIKit

public enum _VHStackContent {

  case view(ViewBlock)
  case relative(RelativeBlock)
  case spacer(SpacerBlock)
  case vStack(VStackBlock)
  case hStack(HStackBlock)
  case zStack(ZStackBlock)
  case background(BackgroundBlock)
  case overlay(OverlayBlock)

}

public protocol StackItemType {
  var content: _VHStackContent { get }
  init(content: _VHStackContent)
}

public struct _VStackItem: StackItemType {

  public let content: _VHStackContent
  public var alignSelf: VStackBlock.HorizontalAlignment?

  public init(content: _VHStackContent) {
    self.content = content
  }

}

public struct _HStackItem: StackItemType {

  public let content: _VHStackContent
  public var alignSelf: HStackBlock.VerticalAlignment?

  public init(content: _VHStackContent) {
    self.content = content
  }
}

extension Array where Element : StackItemType {

  public func spacingBefore(_ spacing: CGFloat) -> Self {
    return [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)))
    ] + self
  }

  public func spacingAfter(_ spacing: CGFloat) -> Self {
    return self + [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false)))
    ]
  }

  func optimized() -> [Element] {

    var spacing: CGFloat = 0
    var expands: Bool = false

    /**

     __X__X___X__

     _X_X_X

     */

    var array: [Element] = []

    for element in self {

      if case .spacer(let spaceBlock) = element.content {

        spacing += spaceBlock.minLength
        expands = spaceBlock.expands ? true : expands

      } else {

        if spacing > 0 || expands {
          array.append(.init(content: .spacer(.init(minLength: spacing, expands: expands))))
        }
        array.append(element)

        spacing = 0
        expands = false
      }

    }

    if spacing > 0 || expands {
      array.append(.init(content: .spacer(.init(minLength: spacing, expands: expands))))
    }

    return array

  }
}

public protocol _VHStackItemContentConvertible {
  var vhStackItemContent: _VHStackContent { get }
}

extension _VHStackItemContentConvertible {

  public func alignSelf(_ alignment: VStackBlock.HorizontalAlignment) -> _VStackItem {
    var item = _VStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

  public func alignSelf(_ alignment: HStackBlock.VerticalAlignment) -> _HStackItem {
    var item = _HStackItem(content: vhStackItemContent)
    item.alignSelf = alignment
    return item
  }

  public func spacingBefore(_ spacing: CGFloat) -> [_VStackItem] {
    return [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false))),
      .init(content: self.vhStackItemContent),
    ]
  }

  public func spacingAfter(_ spacing: CGFloat) -> [_VStackItem] {
    return [
      .init(content: self.vhStackItemContent),
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false))),
    ]
  }

  public func spacingBefore(_ spacing: CGFloat) -> [_HStackItem] {
    return [
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false))),
      .init(content: self.vhStackItemContent),
    ]
  }

  public func spacingAfter(_ spacing: CGFloat) -> [_HStackItem] {
    return [
      .init(content: self.vhStackItemContent),
      .init(content: .spacer(SpacerBlock(minLength: spacing, expands: false))),
    ]
  }

}

extension ViewBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .view(self)
  }
}

extension RelativeBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .relative(self)
  }
}

extension VStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .vStack(self)
  }
}

extension HStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .hStack(self)
  }
}

extension ZStackBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .zStack(self)
  }
}

extension BackgroundBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .background(self)
  }
}

extension OverlayBlock: _VHStackItemContentConvertible {
  public var vhStackItemContent: _VHStackContent {
    return .overlay(self)
  }
}

@_functionBuilder
public enum VStackContentBuilder {
  public typealias Component = _VStackItem

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    views.flatMap { $0 }.map { .init(content: .view(.init($0)))}
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [.init(content: .view(.init(view)))]
  }

  public static func buildExpression(_ item: Component) -> [Component] {
    return [item]
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> [Component] {
    return [.init(content: source.vhStackItemContent)]
  }

  public static func buildExpression(_ source: [_VHStackItemContentConvertible]...) -> [Component] {
    source.flatMap { $0 }.map { .init(content: $0.vhStackItemContent) }
  }

  public static func buildExpression(_ source: [Component]...) -> [Component] {
    source.flatMap { $0 }
  }

  public static func buildExpression(_ spacer: SpacerBlock) -> [Component] {
    return [.init(content: .spacer(spacer))]
  }

}

@_functionBuilder
public enum HStackContentBuilder {
  public typealias Component = _HStackItem

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    views.flatMap { $0 }.map { .init(content: .view(.init($0)))}
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [.init(content: .view(.init(view)))]
  }

  public static func buildExpression(_ item: Component) -> [Component] {
    return [item]
  }

  public static func buildExpression<Source: _VHStackItemContentConvertible>(_ source: Source) -> [Component] {
    return [.init(content: source.vhStackItemContent)]
  }

  public static func buildExpression(_ source: [_VHStackItemContentConvertible]...) -> [Component] {
    source.flatMap { $0 }.map { .init(content: $0.vhStackItemContent) }
  }

  public static func buildExpression(_ source: [Component]...) -> [Component] {
    source.flatMap { $0 }
  }

  public static func buildExpression(_ spacer: SpacerBlock) -> [Component] {
    return [.init(content: .spacer(spacer))]
  }
}
