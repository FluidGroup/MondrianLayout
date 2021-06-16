import UIKit

public struct SpacerBlock {

  public let minLength: CGFloat
  public let expands: Bool

  public init(
    minLength: CGFloat,
    expands: Bool = true
  ) {
    self.minLength = minLength
    self.expands = expands
  }
}

