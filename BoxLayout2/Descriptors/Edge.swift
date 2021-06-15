
public enum Edge: Int8, CaseIterable {

  case top = 0
  case left = 1
  case bottom = 2
  case right = 3

  public struct Set: OptionSet {

    public var rawValue: Int8
    public var isEmpty: Bool {
      rawValue == 0
    }

    public init(rawValue: Int8) {
      self.rawValue = rawValue
    }

    public static let top: Set = .init(rawValue: 1 << 1)
    public static let left: Set = .init(rawValue: 1 << 2)
    public static let bottom: Set = .init(rawValue: 1 << 3)
    public static let right: Set = .init(rawValue: 1 << 4)

    public static var horizontal: Set {
      [.left, .right]
    }

    public static var vertical: Set {
      [.top, .bottom]
    }

    public static var all: Set {
      [.top, .bottom, .right, left]
    }

  }

}
