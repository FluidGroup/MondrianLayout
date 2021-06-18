import MondrianLayout
import StorybookKit
import UIKit

var _book_ViewController: BookView {

  BookNavigationLink(title: "ViewController") {

    BookPush(title: "Push") {

      let subview = ExampleView(width: nil, height: nil) { view in
        view.buildSublayersLayout {
          HStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
          }
        }
      }

      return AnyViewController { view in
        view.buildSublayersLayout(safeArea: .all) {
          ZStackBlock {
            subview
              .viewBlock
              .padding(20)
              .background(UIView.mock(backgroundColor: .layeringColor))
              .relative([.bottom, .horizontal], 0)
          }
        }
      }
    }

  }
}
