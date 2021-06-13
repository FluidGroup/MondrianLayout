import StorybookKit

let book = Book(title: "MyBook") {
  BookText("Hello, MyBook")

  BookSection(title: "Sample") {

    BookPreview(viewBlock: {
      DemoView()
    })
  }
}

import UIKit
import BoxLayout2

final class DemoView: UIView {

  private let profileImageView = UIView.make(backgroundColor: .systemYellow, preferredSize: .init(width: 32, height: 32))
  private let imageView = UIView.make(backgroundColor: .systemYellow, preferredSize: .init(width: 32, height: 32))

  private let likeButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))
  private let commentButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))
  private let messageButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))

  init() {
    super.init(frame: .zero)

    let context = Context(targetView: self)

    VStackConstraint {
      profileImageView
      imageView
      HStackConstraint {
        likeButton
        commentButton
        messageButton
      }
    }
    .setupConstraints(parent: .init(view: self), in: context)

    context.prepareViewHierarchy()
    context.activate()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

