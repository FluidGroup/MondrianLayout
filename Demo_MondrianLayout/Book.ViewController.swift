import MondrianLayout
import StorybookKit
import UIKit

var _book_ViewController: BookView {

  BookNavigationLink(title: "ViewController") {

    BookPush(title: "Push") {

      let body = ExampleView(width: nil, height: nil) { view in
        view.mondrian.buildSubviews {
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

      let container = ExampleView(width: nil, height: nil) { view in
        view.mondrian.buildSubviews {
          ZStackBlock {
            body.viewBlock.padding(10)
          }
        }
      }

      return AnyViewController { view in
        view.mondrian.buildSublayersLayout {
          LayoutContainer(attachedSafeAreaEdges: .all) {
            ZStackBlock {
              container
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
}
