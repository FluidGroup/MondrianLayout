import MondrianLayout
import StorybookKit
import UIKit

let book = Book(title: "BoxLayout2") {

  BookSection(title: "Sample") {

    BookPreview {
      ExampleView(width: 200, height: 200) { (view: UIView) in
        view.buildSublayersLayout {

          HStackBlock(spacing: 2, alignment: .fill) {
            VStackBlock(spacing: 2, alignment: .fill) {
              UIView.mock(
                backgroundColor: .mondrianRed,
                preferredSize: .init(width: 28, height: 28)
              )

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 50)
              )

              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 28, height: 28)
              )

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 28, height: 28)
              )

              HStackBlock(alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
              }
            }

            VStackBlock(spacing: 2, alignment: .fill) {
              HStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )
                VStackBlock(spacing: 2, alignment: .fill) {
                  HStackBlock(spacing: 2, alignment: .fill) {
                    UIView.mock(
                      backgroundColor: .mondrianYellow,
                      preferredSize: .init(width: 28, height: 28)
                    )
                    UIView.mock(
                      backgroundColor: .layeringColor,
                      preferredSize: .init(width: 28, height: 28)
                    )
                  }
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                }
              }

              HStackBlock(spacing: 2, alignment: .fill) {
                VStackBlock(spacing: 2, alignment: .fill) {
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                  UIView.mock(
                    backgroundColor: .mondrianBlue,
                    preferredSize: .init(width: 28, height: 28)
                  )
                }

                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 28, height: 28)
                )

                VStackBlock(spacing: 2, alignment: .fill) {
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                }
              }

              HStackBlock(spacing: 2, alignment: .fill) {
                UIView.mock(
                  backgroundColor: .mondrianRed,
                  preferredSize: .init(width: 28, height: 28)
                )
                VStackBlock(spacing: 2, alignment: .fill) {
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                  UIView.mock(
                    backgroundColor: .layeringColor,
                    preferredSize: .init(width: 28, height: 28)
                  )
                }
              }

            }

          }
          .overlay(
            UILabel.mockMultiline(text: "Mondrian Layout", textColor: .white)
              .viewBlock
              .padding(4)
              .background(
                UIView.mock(
                  backgroundColor: .layeringColor
                )
                .viewBlock
              )
              .relative(bottom: 8, right: 8)
          )

        }
      }
    }

    _book_background

    _book_overlay

    _book_VStackBlock

    _book_HStackBlock

    _book_ZStackConstraint

    _book_SafeArea
  }
}

final class DemoView: UIView {

  private let profileImageView = UIView.mock(
    backgroundColor: .mondrianYellow,
    preferredSize: .init(width: 32, height: 32)
  )

  private let nicknameLabel = UILabel.mockMultiline(text: "Muukii")

  private let imageView = UIView.mock(backgroundColor: .mondrianYellow)

  private let likeButton = UIView.mock(
    backgroundColor: .mondrianRed,
    preferredSize: .init(width: 32, height: 32)
  )
  private let commentButton = UIView.mock(
    backgroundColor: .mondrianRed,
    preferredSize: .init(width: 32, height: 32)
  )
  private let messageButton = UIView.mock(
    backgroundColor: .mondrianRed,
    preferredSize: .init(width: 32, height: 32)
  )

  private let box = UIView.mock(backgroundColor: .mondrianYellow)
  private let box2 = UIView.mock(backgroundColor: .mondrianRed)

  init() {

    super.init(frame: .zero)

    self.buildSublayersLayout {
      VStackBlock {
        SpaceBlock(minLength: 10)
        SpaceBlock(minLength: 10)
        HStackBlock {
          ViewBlock(profileImageView)
            .huggingPriority(.horizontal, .required)
          SpaceBlock(minLength: 4)

          nicknameLabel
        }
        SpaceBlock(minLength: 10)
        SpaceBlock(minLength: 10)
        ViewBlock(imageView)
          .aspectRatio(1)
        SpaceBlock(minLength: 10)
        HStackBlock {
          likeButton
          SpaceBlock(minLength: 2)
          commentButton
          SpaceBlock(minLength: 2)
          messageButton
        }
        ZStackBlock {
          box.viewBlock.width(100).aspectRatio(CGSize(width: 3, height: 4))
          box2.viewBlock.width(50).aspectRatio(CGSize(width: 1, height: 2))
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
