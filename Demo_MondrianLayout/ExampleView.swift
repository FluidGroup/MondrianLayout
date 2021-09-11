
import UIKit
import MondrianLayout

final class ExampleView: UIView {

  init(
    width: CGFloat?,
    height: CGFloat?,
    build: (UIView) -> Void
  ) {

    super.init(frame: .zero)
    build(self)

    translatesAutoresizingMaskIntoConstraints = false

    mondrian.layout
      .width(width.map { .exact($0) } ?? .exact(0, .fittingSizeLevel))
      .height(height.map { .exact($0) } ?? .exact(0, .fittingSizeLevel))
      .activate()

    layoutIfNeeded()

  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}
