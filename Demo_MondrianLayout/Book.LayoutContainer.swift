import MondrianLayout
import StorybookKit
import UIKit

var _book_layoutContainer: BookView {

  BookNavigationLink(title: "LayoutContainer") {

    BookPreview {

      let view = UIView.mock()
      Mondrian.buildSubviews(on: view) {
        LayoutContainer(attachedSafeAreaEdges: .all) {
          VStackBlock {
            
          }
        }
      }
      return view

    }

  }

}
