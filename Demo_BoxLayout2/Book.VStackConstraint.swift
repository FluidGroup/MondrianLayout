
import StorybookKit
import UIKit

import BoxLayout2

var _book_VStackConstraint: BookView {

  BookNavigationLink(title: "VStackConstraint") {

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
          }
        }
      }
    }
    .title("Spacing")

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackConstraint(spacing: 4) {
            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            StackSpacer(minLength: 4)

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )

            UIView.mock(
              backgroundColor: .mondrianYellow,
              preferredSize: .init(width: 28, height: 28)
            )
          }
        }
      }
    }
    .title("Spacing with additional spacer")
  }
}
