import MondrianLayout
import StorybookKit
import UIKit

var _book_sizing: BookView {

  BookNavigationLink(title: "Sizing") {

    BookPreview {
      ExampleView(width: 200, height: 200) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
          ZStackBlock {

            HStackBlock {
              VStackBlock(alignment: .leading) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 36, height: 36)
                )
                .viewBlock
                .alignSelf(.fill)

                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 36, height: 36)
                )
                .viewBlock
                .alignSelf(.fill)
              }
              .width(20)

              VStackBlock(alignment: .leading) {
                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 36, height: 36)
                )
                .viewBlock
                .alignSelf(.fill)

                UIView.mock(
                  backgroundColor: .layeringColor,
                  preferredSize: .init(width: 36, height: 36)
                )
                .viewBlock
                .alignSelf(.fill)
              }
              .width(40)

              UIView.mock(
                backgroundColor: .layeringColor,
                preferredSize: .init(width: 36, height: 36)
              )
              .viewBlock
              .padding(10)
              .width(.max(30))

            }
            .height(50)

          }
        }
      }
    }

  }

}
