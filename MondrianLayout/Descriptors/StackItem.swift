
public struct StackItem {

  public init(content: _LayeringContent) {

  }

}

extension _LayeringContentConvertible {

  public func fill() -> StackItem {
    return .init(content: self._layeringContent)
  }

}
