import MondrianLayout
import StorybookKit
import UIKit

extension FixedWidthInteger {

  public var bk: CGFloat {
    return 4 * CGFloat(self)
  }
}

var _book_RelativeBlock: BookView {
  BookNavigationLink(title: "RelativeBlock") {

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          LayoutContainer(attachedSafeAreaEdges: .all) {
            ZStackBlock {

              UIView.mock(backgroundColor: .layeringColor)
                .viewBlock.alignSelf(.attach(.all))

              UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
                .viewBlock
                .relative(.bottom, 20)
                .relative(.trailing, 20)
            }
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          ZStackBlock {
            UILabel.mockSingleline(text: "A")
              .viewBlock
              .background(UIView.mock())
              .relative(.all, .min(20))
          }
          .background(UIView.mock())
        }
      }
    }

    BookPreview {
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
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
      ExampleView(width: 100, height: 100) { view in
        Mondrian.buildSubviews(on: view) {
          ZStackBlock {
            ZStackBlock {
              UILabel.mockSingleline(text: "Hello Hello Hello")
                .viewBlock
            }
            .relative(.horizontal, 20)
          }
        }
      }
    }

    BookPreview {
      ExampleView(width: nil, height: nil) { (view: UIView) in
        Mondrian.buildSubviews(on: view) {
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
              .relative(.top, 2.bk)
              .relative([.trailing], 10)
              .padding(20)

            }
          }
        }
      }
    }
  }
}
