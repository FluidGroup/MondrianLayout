
import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class LayoutDescriptorTests: XCTestCase {

  func testSyntax() {

    let container = UIView()
    let view = UIView()

    container.addSubview(view)

    let g = view.mondrian.layout
      .width(10)
      .top(.toSuperview)
      .right(.toSuperview)
      .leading(.toSuperview)
      .activate()

    XCTAssertEqual(g.constraints.count, 4)
  }

  func testSyntax_batch() {

    let container = UIView()

    let parent = UIView()
    let view = UIView()

    container.addSubview(parent)
    container.addSubview(view)

    let group = mondrianBatchLayout {
      view.mondrian.layout.width(10)
      view.mondrian.layout.top(.to(parent))
    }

    XCTAssertEqual(group.constraints.count, 2)
  }

  func test_layout_0() {

    let view =  ExampleView(width: nil, height: nil) { view in

      let box1 = UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)
      let box2 = UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)

      view.addSubview(box1)
      view.addSubview(box2)

      mondrianBatchLayout {

        box1.mondrian.layout
          .top(.toSuperview)
          .left(.toSuperview)
          .right(.to(box2).left)
          .bottom(.to(box2).bottom)

        box2.mondrian.layout
          .top(.toSuperview.top, .exact(10))
          .right(.toSuperview)
          .bottom(.toSuperview)

      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_layout_center() {

    let view =  ExampleView(width: nil, height: nil) { view in

      let containerCenterDemo = UIView.mock(backgroundColor: .layeringColor, preferredSize: .largeSquare)
      let containeeCenterDemo = UIView.mock(backgroundColor: .layeringColor, preferredSize: .smallSquare)

      view.addSubview(containerCenterDemo)

      containerCenterDemo.addSubview(containeeCenterDemo)

      mondrianBatchLayout {

        containerCenterDemo.mondrian.layout
          .edges(.toSuperview)

        containeeCenterDemo.mondrian.layout
          .center(.toSuperview)

      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_layout_edge() {

    let view =  ExampleView(width: nil, height: nil) { view in

      let containerEdgesDemo = UIView.mock(backgroundColor: .layeringColor, preferredSize: .largeSquare)
      let containeeEdgesDemo = UIView.mock(backgroundColor: .layeringColor)

      view.addSubview(containerEdgesDemo)

      containerEdgesDemo.addSubview(containeeEdgesDemo)

      mondrianBatchLayout {

        containerEdgesDemo.mondrian.layout
          .edges(.toSuperview)

        containeeEdgesDemo.mondrian.layout
          .edges(.toSuperview, .exact(8))
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }
}
