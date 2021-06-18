import UIKit

public struct ZStackBlock:
  _LayoutBlockType
{

  // MARK: - Properties

  public var name: String = "ZStack"

  public var _layoutBlockNode: _LayoutBlockNode {
    return .zStack(self)
  }

  public let elements: [_LayoutBlockNode]

  // MARK: - Initializers

  public init(
    @_LayeringContentBuilder elements: () -> [_LayoutBlockNode]
  ) {
    self.elements = elements()
  }

  // MARK: - Functions

  public func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext) {

    elements.forEach { element in

      func perform(current: _LayoutElement) {

        context.add(constraints: [
          current.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor)
            .withInternalIdentifier("ZStack.left"),
          current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor)
            .withInternalIdentifier("ZStack.top"),
          current.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor)
            .withInternalIdentifier("ZStack.right"),
          current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor)
            .withInternalIdentifier("ZStack.bottom"),
          current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).withPriority(.defaultHigh)
            .withInternalIdentifier("ZStack.centerX"),
          current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).withPriority(.defaultHigh)
            .withInternalIdentifier("ZStack.cenretY"),

          current.widthAnchor.constraint(equalTo: parent.widthAnchor).withPriority(.fittingSizeLevel)
            .withInternalIdentifier("ZStack.width"),
          current.heightAnchor.constraint(equalTo: parent.heightAnchor).withPriority(.fittingSizeLevel)
            .withInternalIdentifier("ZStack.height"),
        ])
      }

      switch element {
      case .view(let viewConstraint):

        context.register(viewConstraint: viewConstraint)

        perform(current: .init(view: viewConstraint.view))

      case .relative(let relativeConstraint):

        relativeConstraint.setupConstraints(parent: parent, in: context)

      case .background(let c as _LayoutBlockType),
           .overlay(let c as _LayoutBlockType),
           .vStack(let c as _LayoutBlockType),
           .hStack(let c as _LayoutBlockType):

        let newLayoutGuide = context.makeLayoutGuide(identifier: "ZStackBlock.\(c.name)")
        c.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)

        perform(current: .init(layoutGuide: newLayoutGuide))

      case .zStack(let stackConstraint):

        stackConstraint.setupConstraints(parent: parent, in: context)

      }
    }

    // FIXME:
    //    setContentHuggingPriority(.defaultHigh, for: .horizontal)
    //    setContentHuggingPriority(.defaultHigh, for: .vertical)

  }

}
