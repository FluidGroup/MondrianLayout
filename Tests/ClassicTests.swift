import Foundation
import MondrianLayout
import SnapshotTesting
import XCTest

final class ClassicTests: XCTestCase {

  func test_resultBuilder() {

    func syntax() {

      let views: [UIView] = []

      mondrianBatchLayout {
        views.map {
          $0.mondrian.layout.minHeight(10)
        }
      }

    }

  }

  func test_multiplier_constraints() {

    let view = ExampleView(width: nil, height: nil) { view in

      let box1 = UIView.mock(
        backgroundColor: .layeringColor,
        preferredSize: .init(width: 30, height: 30)
      )
      
      let box2 = UIView.mock(
        backgroundColor: .layeringColor,
        preferredSize: .init(width: 30, height: 30)
      )

      view.addSubview(box1)
      view.addSubview(box2)

      mondrianBatchLayout {

        box1.mondrian.layout
          .top(.toSuperview, .min(0))
          .left(.toSuperview)
          .right(.to(box2).left)
          .bottom(.to(box2).bottom)

        box2.mondrian.layout
          .top(.toSuperview.top)
          .height(.to(box1).height, multiplier: 2)
          .right(.toSuperview)
          .bottom(.toSuperview)

      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }
}
