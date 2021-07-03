
import Foundation
import MondrianLayout
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
}
