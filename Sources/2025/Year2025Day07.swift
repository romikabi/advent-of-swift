import Core
import Foundation

extension Year2025 {
  struct Day07 {
    private let data: [[Character]]

    init(data: String) {
      self.data = data.split(separator: "\n").map(Array.init)
    }
  }
}

extension Year2025.Day07: AdventDay {
  func part1() -> Int {
    var solver = Solver(data: data)
    return solver.traverse()
  }

  func part2() -> Int {
    var solver = Solver(data: data)
    solver.traverse()
    return solver.collapse()
  }
}

private struct Solver {
  private var data: [[Character]]
  private var paths: [[Int]]

  init(data: [[Character]]) {
    self.data = data
    self.paths = Array(
      repeating: Array(
        repeating: -1,
        count: data.first?.count ?? 0
      ),
      count: data.count
    )
  }

  @discardableResult
  mutating func traverse() -> Int {
    var answer = 0
    for i in data.indices {
      for j in data[i].indices {
        switch data[i][j] {
        case "S":
          data[i][j] = "|"
        case "." where data.get(i - 1, j) == "|":
          data[i][j] = "|"
        case "^" where data.get(i - 1, j) == "|":
          answer += 1
          data.set(i, j - 1, to: "|")
          data.set(i, j + 1, to: "|")
        default:
          break
        }
      }
    }
    return answer
  }

  mutating func collapse() -> Int {
    pathsFrom(0, data[0].firstIndex(of: "|") ?? 0)
  }

  private mutating func pathsFrom(_ i: Int, _ j: Int) -> Int {
    if i >= data.count {
      return 1
    }
    if !data[i].indices.contains(j) {
      return 0
    }
    if let paths = paths.get(i, j), paths >= 0 {
      return paths
    }
    let result =
      switch data.get(i, j) {
      case "^":
        pathsFrom(i, j - 1) + pathsFrom(i, j + 1)
      case "|":
        pathsFrom(i + 1, j)
      default:
        0
      }
    paths.set(i, j, to: result)
    return result
  }
}
