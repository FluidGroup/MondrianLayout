import UIKit

public struct ZStackBlock:
  _LayoutBlockType
{

  // MARK: - Properties

  public enum XYAxisAlignment {
    /// still development
    case center
//    case top
//    case center
//    case bottom
//    case fill
  }

  public var name: String = "ZStack"

  public var _layoutBlockNode: _LayoutBlockNode {
    return .zStack(self)
  }

  public let alignment: XYAxisAlignment
  public let elements: [ZStackContentBuilder.Component]

  // MARK: - Initializers

  public init(
    alignment: XYAxisAlignment = .center,
    @ZStackContentBuilder elements: () -> [ZStackContentBuilder.Component]
  ) {
    self.alignment = alignment
    self.elements = elements()
  }

  // MARK: - Functions

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    elements.forEach { element in

      func perform(current: _LayoutElement, alignment: XYAxisAlignment) {

        var constraints: [NSLayoutConstraint]

        constraints = [
          current.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor)
            .withInternalIdentifier("ZStack.left"),
          current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor)
            .withInternalIdentifier("ZStack.top"),
          current.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor)
            .withInternalIdentifier("ZStack.right"),
          current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor)
            .withInternalIdentifier("ZStack.bottom"),

          current.widthAnchor.constraint(equalTo: parent.widthAnchor).withPriority(.fittingSizeLevel)
            .withInternalIdentifier("ZStack.width"),
          current.heightAnchor.constraint(equalTo: parent.heightAnchor).withPriority(.fittingSizeLevel)
            .withInternalIdentifier("ZStack.height"),
        ]

        switch alignment {
        case .center:

          constraints += [
            current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).withPriority(.defaultHigh)
              .withInternalIdentifier("ZStack.centerX"),
            current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).withPriority(.defaultHigh)
              .withInternalIdentifier("ZStack.cenretY"),
          ]

        }

        context.add(constraints: constraints)
      }

      switch element.node {
      case .view(let viewConstraint):

        context.register(viewConstraint: viewConstraint)

        perform(current: .init(view: viewConstraint.view), alignment: element.alignSelf ?? alignment)

      case .relative(let relativeConstraint):

        relativeConstraint.setupConstraints(parent: parent, in: context)

      case .background(let c as _LayoutBlockType),
           .overlay(let c as _LayoutBlockType),
           .vStack(let c as _LayoutBlockType),
           .hStack(let c as _LayoutBlockType):

        let newLayoutGuide = context.makeLayoutGuide(identifier: "ZStackBlock.\(c.name)")
        c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)

        perform(current: .init(layoutGuide: newLayoutGuide), alignment: element.alignSelf ?? alignment)

      case .zStack(let stackConstraint):

        stackConstraint.setupConstraints(parent: parent, in: context)

      }
    }

    // FIXME:
    //    setContentHuggingPriority(.defaultHigh, for: .horizontal)
    //    setContentHuggingPriority(.defaultHigh, for: .vertical)

  }

}

public protocol _ZStackItemConvertible {
  var _zStackItem: _ZStackItem { get }
}

public struct _ZStackItem: _ZStackItemConvertible {

  public var _zStackItem: _ZStackItem { self }

  public let node: _LayoutBlockNode
  public var alignSelf: ZStackBlock.XYAxisAlignment? = nil
}

@_functionBuilder
public enum ZStackContentBuilder {
  public typealias Component = _ZStackItem

  public static func buildBlock(_ nestedComponents: [Component]...) -> [Component] {
    return nestedComponents.flatMap { $0 }
  }

  public static func buildExpression(_ views: [UIView]...) -> [Component] {
    return views.flatMap { $0 }.map {
      return .init(node: .view(.init($0)))
    }
  }

  public static func buildExpression<View: UIView>(_ view: View) -> [Component] {
    return [
      .init(node: .view(.init(view)))
    ]
  }

  public static func buildExpression<Block: _ZStackItemConvertible>(
    _ block: Block
  ) -> [Component] {
    return [block._zStackItem]
  }

  public static func buildExpression(_ blocks: [_ZStackItemConvertible]...) -> [Component] {
    return blocks.flatMap { $0 }.map { $0._zStackItem }
  }

}
