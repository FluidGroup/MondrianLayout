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
