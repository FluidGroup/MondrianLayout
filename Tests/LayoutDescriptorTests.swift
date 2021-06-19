
import Foundation
import MondrianLayout
import XCTest

final class LayoutDescriptorTests: XCTestCase {

  func testSyntax() {

    let container = UIView()
    let view = UIView()

    container.addSubview(view)

    let g = view.layout
      .width(10)
      .topToSuperview()
      .rightToSuperview()
      .leading()
      .activate()

    XCTAssertEqual(g.constraints.count, 4)
  }

  func testSyntax_batch() {

    let container = UIView()

    let parent = UIView()
    let view = UIView()

    container.addSubview(parent)
    container.addSubview(view)

    let group = batchLayout {
      view.layout.width(10)
      view.layout.top(to: parent)
    }

    XCTAssertEqual(group.constraints.count, 2)
  }
}
