import StorybookKit
import UIKit

import MondrianLayout

var _book_background: BookView {
  BookNavigationLink(title: "Background") {
    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock {
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
          .padding(10)
          .background(UIView.mock(backgroundColor: .mondrianGray))
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock(spacing: 2) {
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

            HStackBlock(spacing: 2) {
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
              UIView.mock(
                backgroundColor: .mondrianBlue,
                preferredSize: .init(width: 28, height: 28)
              )
            }

          }
          .padding(10)
          .background(UIView.mock(backgroundColor: .mondrianGray))
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.buildSublayersLayout {
          VStackBlock {
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
            .viewBlock
            .padding(10)
            .background(UIView.mock(backgroundColor: .mondrianGray))
          }
          .padding(10)
          .background(UIView.mock(backgroundColor: .mondrianGray))
        }
      }
    }
  }
}
