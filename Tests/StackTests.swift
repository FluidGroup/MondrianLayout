//
//  OverlayTests.swift
//  Tests
//
//  Created by Muukii on 2021/06/16.
//

import MondrianLayout
import Foundation
import SnapshotTesting
import XCTest

final class StackTests: XCTestCase {

  func test_vstack_center() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        VStackBlock(spacing: 4, alignment: .center) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_vstack_leading() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        VStackBlock(spacing: 4, alignment: .leading) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_vstack_trailing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        VStackBlock(spacing: 4, alignment: .trailing) {
          UILabel.mockMultiline(text: "Hello", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Mondrian", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
          UILabel.mockMultiline(text: "Layout!", textColor: .white)
            .viewBlock
            .padding(8)
            .background(UIView.mock(backgroundColor: .layeringColor))
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)

  }

  func test_vstack_additional_spacing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        VStackBlock(spacing: 4) {
          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )

          SpacerBlock(minLength: 4)

          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )

          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)
  }

  func test_hstack_additional_spacing() {

    let view = ExampleView(width: nil, height: nil) { (view: UIView) in
      view.buildSublayersLayout {
        HStackBlock(spacing: 4) {
          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )

          SpacerBlock(minLength: 4)

          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )

          UIView.mock(
            preferredSize: .init(width: 28, height: 28)
          )
        }
      }
    }

    assertSnapshot(matching: view, as: .image, record: _record)
  }
}
