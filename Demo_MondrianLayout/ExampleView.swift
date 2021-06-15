
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

    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)

    translatesAutoresizingMaskIntoConstraints = false

//    buildSelfSizing {
//      $0.height(height)
//    }

    if let width = width {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    if let height = height {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    layoutIfNeeded()

  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}
