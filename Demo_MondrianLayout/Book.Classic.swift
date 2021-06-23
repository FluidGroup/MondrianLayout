import MondrianLayout
import StorybookKit
import UIKit

var _book_classic: BookView {
  BookNavigationLink(title: "Classic") {

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let box1 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)
        let box2 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        view.addSubview(box1)
        view.addSubview(box2)

        mondrianBatchLayout {

          box1.mondrian.layout
            .topToSuperview()
            .leftToSuperview()
            .right(to: box2, .left)
            .bottomToSuperview()

          box2.mondrian.layout
            .topToSuperview(.top, .constant(10))
            .rightToSuperview()
            .bottomToSuperview()
        }

      }
    }

  }
}
