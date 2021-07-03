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
            .top(.toSuperview)
            .left(.toSuperview)
            .right(.to(box2).left)
            .bottom(.to(box2).bottom)

          box2.mondrian.layout
            .top(.toSuperview.top, .constant(10))
            .right(.toSuperview)
            .bottom(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let containerCenterDemo = UIView.mock(backgroundColor: .mondrianGray, preferredSize: .largeSquare)
        let containeeCenterDemo = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        view.addSubview(containerCenterDemo)

        containerCenterDemo.addSubview(containeeCenterDemo)

        mondrianBatchLayout {

          containerCenterDemo.mondrian.layout
            .edges(.toSuperview)

          containeeCenterDemo.mondrian.layout
            .center(.toSuperview)

        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let containerEdgesDemo = UIView.mock(backgroundColor: .mondrianYellow, preferredSize: .largeSquare)
        let containeeEdgesDemo = UIView.mock(backgroundColor: .mondrianBlue)

        view.addSubview(containerEdgesDemo)

        containerEdgesDemo.addSubview(containeeEdgesDemo)

        mondrianBatchLayout {

          containerEdgesDemo.mondrian.layout
            .edges(.toSuperview)

          containeeEdgesDemo.mondrian.layout
            .edges(.toSuperview, .constant(8))
        }
      }
    }

  }
}
