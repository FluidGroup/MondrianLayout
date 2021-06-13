
public enum _ZStackElement {

  case view(ViewConstraint)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  case zStack(ZStackConstraint)
  case relative(RelativeConstraint)
}

public struct ZStackConstraint: LayoutDescriptorType {

  public let elements: [_ZStackElement]

  public init(
    @ZStackElementBuilder elements: () -> [_ZStackElement]
  ) {
    self.elements = elements()
  }

  public func setupConstraints(parent: LayoutBox, in context: Context) {

    elements.forEach { element in

      func perform(current: LayoutBox) {

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

        let newLayoutGuide = context.makeLayoutGuide(identifier: "ZStackConstraint.VStack")
        relativeConstraint.setupConstraints(parent: .init(layoutGuide: newLayoutGuide), in: context)

        perform(current: .init(layoutGuide: newLayoutGuide))

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
