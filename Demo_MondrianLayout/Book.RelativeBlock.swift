import MondrianLayout
import StorybookKit
import UIKit

var _book_RelativeBlock: BookView {
  BookNavigationLink(title: "RelativeBlock") {

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        view.mondrian.buildSubviews {
          ZStackBlock {
            ZStackBlock {
              UILabel.mockSingleline(text: "Hello Hello Hello")
                .viewBlock
                .background(UIView.mock())
            }
            .padding(20)
          }
          .background(UIView.mock())
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        view.mondrian.buildSubviews {
          VStackBlock {
            ZStackBlock {
              UIView.mock(
                backgroundColor: .mondrianYellow,
                preferredSize: .init(width: 100, height: 100)
              )

              UIView.mock(
                backgroundColor: .systemBlue,
                preferredSize: .init(width: 10, height: 10)
              )
              .viewBlock
              .relative(.top, 2)
              .relative([.trailing], 10)
              .padding(20)

            }
          }
        }
      }
    }
  }
}
