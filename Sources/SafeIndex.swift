import Foundation

extension MutableCollection where Element: MutableCollection {
  func get(_ i: Index, _ j: Element.Index) -> Element.Element? {
    get(i)?.get(j)
  }

  mutating func set(_ i: Index, _ j: Element.Index, to value: Element.Element) {
    guard indices.contains(i), self[i].indices.contains(j) else { return }
    self[i][j] = value
  }
}

extension MutableCollection {
  func get(_ index: Index) -> Element? {
    guard indices.contains(index) else { return nil }
    return self[index]
  }

  mutating func set(_ index: Index, to value: Element) {
    guard indices.contains(index) else { return }
    self[index] = value
  }
}
