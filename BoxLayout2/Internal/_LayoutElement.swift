
import UIKit

public struct _LayoutElement {

  let leadingAnchor: NSLayoutXAxisAnchor
  let trailingAnchor: NSLayoutXAxisAnchor
  let leftAnchor: NSLayoutXAxisAnchor
  let rightAnchor: NSLayoutXAxisAnchor
  let topAnchor: NSLayoutYAxisAnchor
  let bottomAnchor: NSLayoutYAxisAnchor
  let widthAnchor: NSLayoutDimension
  let heightAnchor: NSLayoutDimension
  let centerXAnchor: NSLayoutXAxisAnchor
  let centerYAnchor: NSLayoutYAxisAnchor

  let view: UIView?
  let layoutGuide: UILayoutGuide?

  public init(view: UIView) {

    self.view = view
    self.layoutGuide = nil

    leadingAnchor = view.leadingAnchor
    trailingAnchor = view.trailingAnchor
    leftAnchor = view.leftAnchor
    rightAnchor = view.rightAnchor
    topAnchor = view.topAnchor
    bottomAnchor = view.bottomAnchor
    widthAnchor = view.widthAnchor
    heightAnchor = view.heightAnchor
    centerXAnchor = view.centerXAnchor
    centerYAnchor = view.centerYAnchor
  }

  public init(layoutGuide: UILayoutGuide) {

    self.view = nil
    self.layoutGuide = layoutGuide

    leadingAnchor = layoutGuide.leadingAnchor
    trailingAnchor = layoutGuide.trailingAnchor
    leftAnchor = layoutGuide.leftAnchor
    rightAnchor = layoutGuide.rightAnchor
    topAnchor = layoutGuide.topAnchor
    bottomAnchor = layoutGuide.bottomAnchor
    widthAnchor = layoutGuide.widthAnchor
    heightAnchor = layoutGuide.heightAnchor
    centerXAnchor = layoutGuide.centerXAnchor
    centerYAnchor = layoutGuide.centerYAnchor

  }

}
