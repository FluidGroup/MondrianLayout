//
//  Extensions.swift
//  Demo_BoxLayout2
//
//  Created by Muukii on 2021/06/13.
//

import UIKit

extension UIView {

  static func make(backgroundColor: UIColor) -> UIView {
    let view = UIView()
    view.backgroundColor = backgroundColor
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    return view
  }

  static func make(backgroundColor: UIColor, preferredSize: CGSize) -> UIView {
    let view = IntrinsicSizeView(preferredSize: preferredSize)
    view.backgroundColor = backgroundColor
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    return view
  }
}

final class IntrinsicSizeView: UIView {

  private let preferredSize: CGSize

  init(preferredSize: CGSize) {
    self.preferredSize = preferredSize
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    preferredSize
  }

}

extension UILabel {

  static func make(text: String) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = text
    return label
  }
}
