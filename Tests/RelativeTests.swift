import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class RelateiveTests: XCTestCase {

  func test_accumulate_padding() {

    let view = ExampleView(width: 100, height: 100) { view in
      view.mondrian.buildSubviews {
        LayoutContainer(attachedSafeAreaEdges: .vertical) {
          VStackBlock {
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
            .viewBlock
            .padding(.bottom, 10)
            .padding(.bottom, 10)
            .padding(.bottom, 10)
          }
          .background(
            UIView.mock(
              backgroundColor: .layeringColor,
              preferredSize: .smallSquare
            )
          )
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

}
