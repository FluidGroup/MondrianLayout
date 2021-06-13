import UIKit

public enum _RelativeContent {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
}

public struct RelativeConstraint: LayoutDescriptorType {

  public let content: _RelativeContent

  public var top: CGFloat?
  public var bottom: CGFloat?
  public var right: CGFloat?
  public var left: CGFloat?

  public init(
    @RelativeContentBuilder content: () -> _RelativeContent
  ) {
    self.content = content()
  }

  public func setupConstraints(parent: LayoutBox, in context: Context) {

    func perform(current: LayoutBox) {

      context.add(
        constraints: [
          top.map {
            current.topAnchor.constraint(equalTo: parent.topAnchor, constant: $0)
          },
          right.map {
            current.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: $0)
          },
          left.map {
            current.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: $0)
          },
          bottom.map {
            current.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: $0)
          },
        ].compactMap { $0 }
      )

      context.add(
        constraints: [
          current.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor),
          current.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
          current.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor),
          current.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor),
          
          current.centerXAnchor.constraint(equalTo: parent.centerXAnchor).withPriority(.defaultHigh),
          current.centerYAnchor.constraint(equalTo: parent.centerYAnchor).withPriority(.defaultHigh),
        ].compactMap { $0 }
      )
    }

    switch content {
    case .view(let viewConstarint):

      context.register(view: viewConstarint)

      perform(current: .init(view: viewConstarint.view))

    case .vStack(let stackConstraint):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.VStack")
      stackConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .hStack(let stackConstraint):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.HStack")
      stackConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))

    case .zStack(let stackConstraint):

      let newLayoutGuide = context.makeLayoutGuide(identifier: "RelativeConstraint.ZStack")
      stackConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)
      perform(current: .init(layoutGuide: newLayoutGuide))
    }

  }

}

#if swift(>=5.4)
@resultBuilder
public enum RelativeContentBuilder {
}
#else
@_functionBuilder
public enum RelativeContentBuilder {
}
#endif

extension RelativeContentBuilder {

  @_disfavoredOverload
  public static func buildBlock(_ components: _RelativeContent...) -> [_RelativeContent] {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> _RelativeContent {
    return .view(.init(view))
  }

  public static func buildExpression(_ stack: VStackConstraint) -> _RelativeContent {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> _RelativeContent {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: ZStackConstraint) -> _RelativeContent {
    return .zStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> _RelativeContent {
    return .view(view)
  }
}
