//
//  Tests.swift
//  Tests
//
//  Created by Muukii on 2021/06/13.
//

import XCTest
import BoxLayout2

@discardableResult
func layout<Content: ConstraintLayoutElementType>(
  @LayoutConstraintBuilder _ c: () -> Content
) -> Content {
  c()
}

class Tests: XCTestCase {

  func test_pattern1() {

    let result = layout {
      HStackConstraint {
        VStackConstraint {
          SingleElement()
        }
      }
    }

    _ = result as HStackConstraint<VStackConstraint<SingleElement>>

  }

  func test_pattern2() {

    let result = layout {
      HStackConstraint {
        SingleElement()
        VStackConstraint {}
      }
    }

    _ = result as HStackConstraint<MultipleElements>

  }

  func test_pattern3() {

    let result = layout {
      HStackConstraint {
        UIView()
        UIView()
      }
    }

    _ = result as HStackConstraint<MultipleElements>

  }
}
