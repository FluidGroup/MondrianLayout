
import UIKit

public enum _SafeAreaContent {

  case view(ViewBlock)
  case vStack(VStackBlock)
  case hStack(HStackBlock)
  case zStack(ZStackBlock)
  case overlay(OverlayBlock)
  case background(BackgroundBlock)
}

struct SafeAreaContainer {

  let edge: Edge.Set
  let content: _SafeAreaContent

  init(edge: Edge.Set, @SafeAreaContentBuilder content: () -> _SafeAreaContent) {
    self.edge = edge
    self.content = content()
  }

  func setupConstraints(parent: UIView, in context: LayoutBuilderContext) {

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

    case .vStack(let c as _LayoutBlockType),
         .hStack(let c as _LayoutBlockType),
         .zStack(let c as _LayoutBlockType),
         .overlay(let c as _LayoutBlockType),
         .background(let c as _LayoutBlockType):

      if edge.isEmpty {
        perfom(container: .init(view: parent))
        c.setupConstraints(parent: .init(view: parent), in: context)
      } else if edge.contains(.all) {
        c.setupConstraints(parent: .init(layoutGuide: parent.safeAreaLayoutGuide), in: context)
      }else {
        let containerLayoutGuide = context.makeLayoutGuide(identifier: "SafeArea.\(c.name)")
        perfom(container: .init(layoutGuide: containerLayoutGuide))
        c.setupConstraints(parent: .init(layoutGuide: containerLayoutGuide), in: context)
      }

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

  public static func buildExpression(_ stack: VStackBlock) -> Component {
    return .vStack(stack)
  }

  public static func buildExpression(_ stack: HStackBlock) -> Component {
    return .hStack(stack)
  }

  public static func buildExpression(_ stack: ZStackBlock) -> Component {
    return .zStack(stack)
  }

  public static func buildExpression(_ view: ViewBlock) -> Component {
    return .view(view)
  }

  public static func buildExpression(_ components: Component) -> Component {
    return components
  }

  public static func buildExpression(_ stack: BackgroundBlock) -> Component {
    return .background(stack)
  }

  public static func buildExpression(_ stack: OverlayBlock) -> Component {
    return .overlay(stack)
  }
}
