import BoxLayout2
import StorybookKit
import UIKit

let book = Book(title: "BoxLayout2") {

  BookSection(title: "Sample") {

    BookPreview {
      AnonymousDemoView { (view: UIView) in
        view.buildLayout {
          VStackConstraint {
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .systemYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint()
              .relative(top: 10, right: 10)

            }
          }
        }
      }
    }

    BookPreview {
      AnonymousDemoView { (view: UIView) in
        view.buildLayout {
          VStackConstraint {
            UIView.mock(backgroundColor: .systemYellow, preferredSize: .init(width: 30, height: 30))
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .systemYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint()
              .relative(top: 10, right: 10)

            }
            ZStackConstraint {
              UIView.mock(
                backgroundColor: .systemYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewConstraint()
              .relative(top: 10, right: 10)
              
            }
          }
        }
      }
    }

    BookPreview {
      AnonymousDemoView { (view: UIView) in
        view.buildLayout {
          VStackConstraint {
            UIView.mock(backgroundColor: .systemYellow, preferredSize: .init(width: 30, height: 30))
            UIView.mock(backgroundColor: .systemYellow, preferredSize: .init(width: 30, height: 30))
            UIView.mock(backgroundColor: .systemYellow, preferredSize: .init(width: 30, height: 30))
          }
        }
      }
    }

    BookPreview(viewBlock: {
      DemoView()
    })
  }
}

final class AnonymousDemoView: UIView {

  init(
    _ build: (UIView) -> Void
  ) {
    super.init(frame: .zero)
    build(self)

    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)
  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}

final class DemoView: UIView {

  private let profileImageView = UIView.mock(
    backgroundColor: .systemYellow,
    preferredSize: .init(width: 32, height: 32)
  )

  private let nicknameLabel = UILabel.make(text: "Muukii")

  private let imageView = UIView.mock(backgroundColor: .systemYellow)

  private let likeButton = UIView.mock(
    backgroundColor: .systemRed,
    preferredSize: .init(width: 32, height: 32)
  )
  private let commentButton = UIView.mock(
    backgroundColor: .systemRed,
    preferredSize: .init(width: 32, height: 32)
  )
  private let messageButton = UIView.mock(
    backgroundColor: .systemRed,
    preferredSize: .init(width: 32, height: 32)
  )

  private let box = UIView.mock(backgroundColor: .systemYellow)
  private let box2 = UIView.mock(backgroundColor: .systemRed)

  init() {

    super.init(frame: .zero)

    self.buildLayout {
      VStackConstraint {
        StackSpacer(minLength: 10)
        StackSpacer(minLength: 10)
        HStackConstraint {
          ViewConstraint(profileImageView)
            .huggingPriority(.horizontal, .required)
          StackSpacer(minLength: 4)

          nicknameLabel
        }
        StackSpacer(minLength: 10)
        StackSpacer(minLength: 10)
        ViewConstraint(imageView)
          .aspectRatio(1)
        StackSpacer(minLength: 10)
        HStackConstraint {
          likeButton
          StackSpacer(minLength: 2)
          commentButton
          StackSpacer(minLength: 2)
          messageButton
        }
        ZStackConstraint {
          ViewConstraint(box).width(100).aspectRatio(CGSize(width: 3, height: 4))
          ViewConstraint(box2).width(50).aspectRatio(CGSize(width: 1, height: 2))
        }
      }
    }

  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}
