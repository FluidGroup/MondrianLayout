
import UIKit

public enum VHStackElement {

  case view(UIView)
  case spacer(StackSpacer)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  //  case zStack(ZStackConstraint)
}

extension Array where Element == VHStackElement {

  func parsed() -> [VHStackElementParsed] {

    var firstSpacing: CGFloat?
    var parsed: [VHStackElementParsed] = []

    for element in self {
      switch element {
      case .view(let view):
        parsed.append(.init(edge: .view(view)))
      case .vStack(let stack):
        parsed.append(.init(edge: .vStack(stack)))
      case .hStack(let stack):
        parsed.append(.init(edge: .hStack(stack)))
      case .spacer(let spacer):
        if parsed.isEmpty {
          firstSpacing = spacer.minLength
        } else {
          if let lastIndex = parsed.indices.last {
            parsed[lastIndex].spacingAfter += spacer.minLength
          }
        }
      }
    }

    if parsed.isEmpty == false, let firstSpacing = firstSpacing {
      parsed[0].spacingBefore = firstSpacing
    }

    return parsed
  }
}

struct VHStackElementParsed {

  enum Edge {
    case view(UIView)
    case vStack(VStackConstraint)
    case hStack(HStackConstraint)
  }

  var edge: Edge
  var spacingAfter: CGFloat = 0
  var spacingBefore: CGFloat = 0

}
