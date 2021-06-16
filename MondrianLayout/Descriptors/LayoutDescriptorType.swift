
public protocol LayoutDescriptorType {

  var name: String { get }
  func setupConstraints(parent: _LayoutElement, in context: LayoutBuilderContext)
}
