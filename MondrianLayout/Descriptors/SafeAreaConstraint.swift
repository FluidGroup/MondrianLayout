
import UIKit

public enum _SafeAreaContent {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case overlay(OverlayConstraint)
  case background(BackgroundConstraint)
}

public struct SafeAreaConstraint {

  let edge: Edge.Set
  let content: _SafeAreaContent

  public init(edge: Edge.Set, @SafeAreaContentBuilder content: () -> _SafeAreaContent) {
    self.edge = edge
    self.content = content()
  }

  public func setupConstraints(parent: UIView, in context: LayoutBuilderContext) {

    func perfom(container: _LayoutElement) {
      if edge.contains(.top) {
        context.add(constraints: [
          container.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor)
        ])
      } else {
        context.add(constraints: [
          container.topAnchor.constraint(equalTo: parent.topAnchor)
        ])
      }
      if edge.contains(.left) {
        context.add(constraints: [
          container.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor)
        ])
      } else {
        context.add(constraints: [
          container.leftAnchor.constraint(equalTo: parent.leftAnchor)
        ])
      }
      if edge.contains(.right) {
        context.add(constraints: [
          container.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor)
        ])
      } else {
        context.add(constraints: [
          container.rightAnchor.constraint(equalTo: parent.rightAnchor)
        ])
      }
      if edge.contains(.bottom) {
        context.add(constraints: [
          container.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor)
        ])
      } else {
        context.add(constraints: [
          container.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
      }
    }

    switch content {
    case .view(let c):

      context.register(viewConstraint: c)
      perfom(container: .init(view: c.view))

    case .vStack(let c as LayoutDescriptorType),
         .hStack(let c as LayoutDescriptorType),
         .zStack(let c as LayoutDescriptorType),
         .overlay(let c as LayoutDescriptorType),
         .background(let c as LayoutDescriptorType):

      let containerLayoutGuide = context.makeLayoutGuide(identifier: "SafeArea.\(c.name)")
      perfom(container: .init(layoutGuide: containerLayoutGuide))
      c.setupConstraints(parent: .init(layoutGuide: containerLayoutGuide), in: context)

    }

  }
}


@_functionBuilder
public enum SafeAreaContentBuilder {

  public typealias Component = _SafeAreaContent

  public static func buildBlock(_ components: Component) -> Component {
    return components
  }

  public static func buildExpression<View: UIView>(_ view: View) -> Component {
    return .view(.init(view))
  }

  public static func buildExpression(_ stack: VStackConstraint) -> Component {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: HStackConstraint) -> Component {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: ZStackConstraint) -> Component {
    return .zStack(stack)
  }

  public static func buildExpression(_ view: ViewConstraint) -> Component {
    return .view(view)
  }

  public static func buildExpression(_ components: Component) -> Component {
    return components
  }
}
