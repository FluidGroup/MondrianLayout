import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class RelateiveTests: XCTestCase {

  func test_centering_in_ambiguous() {
    let view = ExampleView(width: 100, height: 100) { view in
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
    assertSnapshot(matching: view, as: .image, record: _record)
  }

  func test_accumulate_relative() {
    let view = ExampleView(width: 100, height: 100) { view in
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

    assertSnapshot(matching: view, as: .image, record: _record)
  }

  func test_accumulate_padding() {

    let view = ExampleView(width: 100, height: 100) { view in
      Mondrian.buildSubviews(on: view) {
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

  func test_accumulation_0() {

    var base = RelativeBlock.ConstrainedValue()

    XCTAssert(base.min == nil)
    XCTAssert(base.exact == nil)
    XCTAssert(base.max == nil)

    let other = RelativeBlock.ConstrainedValue(min: 0, exact: nil, max: nil)

    base.accumulate(other)

    XCTAssertEqual(base.min, 0)
    XCTAssertEqual(base.exact, nil)
    XCTAssertEqual(base.max, nil)

  }

  func test_accumulation_1() {

    var base = RelativeBlock.ConstrainedValue(min: 1, exact: nil, max: nil)

    XCTAssertEqual(base.min, 1)
    XCTAssertEqual(base.exact, nil)
    XCTAssertEqual(base.max, nil)

    let other = RelativeBlock.ConstrainedValue(min: nil, exact: nil, max: nil)

    base.accumulate(other)

    XCTAssertEqual(base.min, 1)
    XCTAssertEqual(base.exact, nil)
    XCTAssertEqual(base.max, nil)

  }

  func test_accumulation_2() {

    var base = RelativeBlock.ConstrainedValue(min: 1, exact: nil, max: nil)

    XCTAssertEqual(base.min, 1)
    XCTAssertEqual(base.exact, nil)
    XCTAssertEqual(base.max, nil)

    let other = RelativeBlock.ConstrainedValue(min: 1, exact: nil, max: nil)

    base.accumulate(other)

    XCTAssertEqual(base.min, 2)
    XCTAssertEqual(base.exact, nil)
    XCTAssertEqual(base.max, nil)

  }
}
