
import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class OverlayTests: XCTestCase {

  func test_1() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {
        UIView.mock(
          backgroundColor: .layeringColor,
          preferredSize: .init(width: 100, height: 100)
        )
        .viewBlock
        .overlay(
          UIView.mock(backgroundColor: .layeringColor)
            .viewBlock
            .overlay(
              UIView.mock(backgroundColor: .layeringColor)
                .viewBlock
                .padding(10)
            )
            .padding(10)
        )
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_2() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      Mondrian.buildSubviews(on: view) {
        VStackBlock {
          UIView.mock(
            preferredSize: .smallSquare
          )
          UIView.mock(
            preferredSize: .smallSquare
          )
          UIView.mock(
            preferredSize: .smallSquare
          )
        }
        .padding(10)
        .overlay(UIView.mock(backgroundColor: .layeringColor))
      }
    }

    XCTAssertFalse(view.hasAmbiguousLayoutRecursively)
    assertSnapshot(matching: view, as: .image, record: _record)

  }

}
