import MondrianLayout
import StorybookKit
import UIKit

final class InstagramPostView: UIView {

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

  private let saveButton = UIView.mock(
    backgroundColor: .mondrianRed,
    preferredSize: .init(width: 32, height: 32)
  )

  private let box = UIView.mock(backgroundColor: .mondrianYellow)
  private let box2 = UIView.mock(backgroundColor: .mondrianRed)

  init() {

    super.init(frame: .zero)

    self.buildSelfSizing {
      $0.width(200)
    }

    let views: [UIView] = []

    VStackBlock {
      views
    }

    self.buildSublayersLayout {
      VStackBlock(alignment: .fill) {

        HStackBlock {
          ViewBlock(profileImageView)
            .huggingPriority(.horizontal, .required)
          SpacerBlock(minLength: 4, expands: false)
          nicknameLabel
        }
        .spacingAfter(10)

        ViewBlock(imageView)
          .aspectRatio(1)
          .spacingAfter(10)

        HStackBlock {
          HStackBlock(spacing: 2) {
            likeButton
            commentButton
            messageButton
          }
          SpacerBlock(minLength: 8)
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
