import Core
import Foundation

extension Year2025 {
  struct Day04 {
    private let data: [[Bool]]
  }
}

extension Year2025.Day04: AdventDay {
  init(data: String) {
    self.data = data.split(separator: "\n").map { line in
      line.map { $0 == "@" }
    }
  }

  func part1() -> Int {
    var solver = Solver(data: data)
    return solver.countAccessibleRolls()
  }

  func part2() -> Int {
    var solver = Solver(data: data)
    var total = 0
    var last = -1
    while last != 0 {
      let accessible = solver.countAccessibleRolls(prune: true)
      last = accessible
      total += last
    }
    return total
  }
}

private struct Solver {
  private var data: [[Bool]]

  init(data: [[Bool]]) {
    self.data = data
  }

  mutating func countAccessibleRolls(prune: Bool = false) -> Int {
    var accessible = [(row: Int, col: Int)]()
    for row in data.indices {
      for col in data[row].indices {
        guard data[row][col] else { continue }
        var rolls = 0
        iterateNeighbors(row, col) { row, col in
          if data[row][col] {
            rolls += 1
          }
          return rolls < 4
        }
        if rolls < 4 {
          accessible.append((row, col))
        }
      }
    }
    if prune {
      for (row, col) in accessible {
        data[row][col] = false
      }
    }
    return accessible.count
  }

  private func iterateNeighbors(
    _ row: Int,
    _ col: Int,
    proceed: (_ row: Int, _ col: Int) -> Bool
  ) {
    for i in [row - 1, row, row + 1] {
      for j in [col - 1, col, col + 1] {
        guard i != row || j != col,
          data.indices.contains(i),
          data[i].indices.contains(j)
        else { continue }
        if !proceed(i, j) {
          return
        }
      }
    }
  }
}
