import MondrianLayout
import StorybookKit
import UIKit

final class InstagramPostView: UIView {

  private let profileImageView = UIView.mock(
    backgroundColor: .mondrianBlue,
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

  private let saveButton = UIView.mock(
    backgroundColor: .mondrianCyan,
    preferredSize: .init(width: 32, height: 32)
  )

  private let captionBackground = UIView.mock(backgroundColor: .layeringColor)
  private let captionLabel = UILabel.mockMultiline(text: "Caption", textColor: .white)

  init() {

    super.init(frame: .zero)

    self.mondrian.buildSelfSizing {
      $0.width(200)
    }

    Mondrian.buildSubviews(on: self) {
      VStackBlock(alignment: .fill) {

        HStackBlock {
          ViewBlock(profileImageView)
            .huggingPriority(.horizontal, .required)
            .spacingAfter(4)
          nicknameLabel
        }
        .spacingAfter(10)

        ViewBlock(imageView)
          .aspectRatio(1)
          .overlay(
            captionLabel.viewBlock
              .padding(10)
              .background(captionBackground)
              .relative([.bottom, .trailing], 8)
          )
          .spacingAfter(10)

        HStackBlock {
          HStackBlock(spacing: 2) {
            likeButton
            commentButton
            messageButton
          }
          StackingSpacer(minLength: 8)
          saveButton
        }
        .spacingAfter(10)

      }
    }

  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

}
