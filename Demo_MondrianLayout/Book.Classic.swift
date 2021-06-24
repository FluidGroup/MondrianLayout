import MondrianLayout
import StorybookKit
import UIKit

var _book_classic: BookView {
  BookNavigationLink(title: "Classic") {

    BookPreview {
      ExampleView(width: nil, height: nil) { view in

        let box1 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)
        let box2 = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        let containerCenterDemo = UIView.mock(backgroundColor: .mondrianGray, preferredSize: .largeSquare)
        let containeeCenterDemo = UIView.mock(backgroundColor: .mondrianBlue, preferredSize: .smallSquare)

        let containerEdgesDemo = UIView.mock(backgroundColor: .mondrianYellow, preferredSize: .largeSquare)
        let containeeEdgesDemo = UIView.mock(backgroundColor: .mondrianBlue)

        view.addSubview(box1)
        view.addSubview(box2)
        view.addSubview(containerCenterDemo)
        view.addSubview(containerEdgesDemo)

        containerCenterDemo.addSubview(containeeCenterDemo)
        containerEdgesDemo.addSubview(containeeEdgesDemo)


        mondrianBatchLayout {

          box1.mondrian.layout
            .topToSuperview()
            .leftToSuperview()
            .right(to: box2, .left)
            .bottom(to: box2, .bottom)

          box2.mondrian.layout
            .topToSuperview(.top, .constant(10))
            .rightToSuperview()

          containerCenterDemo.mondrian.layout
            .top(to: box2, .bottom, .constant(20))
            .bottomToSuperview()

          containeeCenterDemo.mondrian.layout
            .centerToSuperView()

          containerEdgesDemo.mondrian.layout
            .top(to: containerCenterDemo, .top, .constant(0))
            .leading(to: containerCenterDemo, .trailing, .constant(5))

          containeeEdgesDemo.mondrian.layout
            .edgesToSuperView(.constant(8))
        }
      }
    }

  }
}
