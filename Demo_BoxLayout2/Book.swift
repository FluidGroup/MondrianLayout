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
  private let imageView = UIView.make(backgroundColor: .systemYellow)

  private let likeButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))
  private let commentButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))
  private let messageButton = UIView.make(backgroundColor: .systemRed, preferredSize: .init(width: 32, height: 32))

  init() {

    super.init(frame: .zero)

    self.buildLayout {
      VStackConstraint {
        StackSpacer(minLength: 10)
        StackSpacer(minLength: 10)
        profileImageView
        StackSpacer(minLength: 10)
        StackSpacer(minLength: 10)
        ViewConstraint(imageView)
          .height(20)
        StackSpacer(minLength: 10)
        HStackConstraint {
          likeButton
          StackSpacer(minLength: 2)
          commentButton
          StackSpacer(minLength: 2)
          messageButton
        }
      }
    }

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

