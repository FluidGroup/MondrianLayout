import UIKit

public enum _ZStackElement {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case relative(RelativeConstraint)
}

public struct ZStackConstraint: LayoutDescriptorType, _RelativeContentConvertible {

  public var _relativeContent: _RelativeContent {
    return .zStack(self)
  }

  public let elements: [_ZStackElement]

  public init(
    @ZStackElementBuilder elements: () -> [_ZStackElement]
  ) {
    self.elements = elements()
  }

  public func setupConstraints(parent: _LayoutElement, in context: Context) {

    elements.forEach { element in

      func perform(current: _LayoutElement) {

        context.add(constraints: [
          current.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor),
          current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
          current.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor),
          current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor),
          current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).withPriority(.defaultHigh),
          current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).withPriority(.defaultHigh),
        ])
      }

      switch element {
      case .view(let viewConstraint):

        context.register(view: viewConstraint)

        perform(current: .init(view: viewConstraint.view))

      case .relative(let relativeConstraint):

        relativeConstraint.setupConstraints(parent: parent, in: context)

      case .vStack(let stackConstraint):

        let newLayoutGuide = context.makeLayoutGuide(identifier: "ZStackConstraint.VStack")
        stackConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)

        perform(current: .init(layoutGuide: newLayoutGuide))

      case .hStack(let stackConstraint):

        let newLayoutGuide = context.makeLayoutGuide(identifier: "ZStackConstraint.HStack")
        stackConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)

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

@_functionBuilder
public enum ZStackElementBuilder {
  public typealias Component = _ZStackElement
}

extension ZStackElementBuilder {


  @_disfavoredOverload
  public static func buildBlock(_ components: _ZStackElement...) -> [Component] {
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
}
