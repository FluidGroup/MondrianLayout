//
//  Tests.swift
//  Tests
//
//  Created by Muukii on 2021/06/13.
//

import XCTest
import BoxLayout2
import SnapshotTesting

final class LayoutSnapshotTests: XCTestCase {

  private let record = false

  func test_1() {

    let view = AnyView(width: 100, height: 100) { view in
      view.buildSublayersLayout {
        VStackConstraint {
          ZStackConstraint {
            UIView.mock(
              backgroundColor: .systemYellow,
              preferredSize: .init(width: 100, height: 100)
            )

            UIView.mock(
              backgroundColor: .systemBlue,
              preferredSize: .init(width: 10, height: 10)
            )
            .viewConstraint()
            .relative(top: 10, right: 10)

          }
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: record)

  }
}

/*
@discardableResult
func layout<Content: ConstraintLayoutElementType>(
  @LayoutConstraintBuilder _ c: () -> Content
) -> Content {
  c()
}

class Tests: XCTestCase {

  func test_pattern_stack() {

    _ = layout {
      HStackConstraint {
        UIView()
      }
    }

    _ = layout {
      HStackConstraint {
        UIView()
        StackSpacer(minLength: 0)
      }
    }

  }

  func test_pattern1() {

    _ = layout {
      HStackConstraint {
//        VStackConstraint {
//          UIView()
//        }
      }
    }

  }

  func test_pattern2() {

    _ = layout {
      HStackConstraint {
        UIView()
//        VStackConstraint {}
      }
    }

  }

  func test_pattern3() {

    _ = layout {
      HStackConstraint {
        UIView()
        UIView()
      }
    }

  }
}
*/
