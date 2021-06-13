
import UIKit

public enum VHStackElement {

  case view(ViewConstraint)
  case spacer(StackSpacer)
  case vStack(VStackConstraint)
  case hStack(HStackConstraint)
  //  case zStack(ZStackConstraint)
}
