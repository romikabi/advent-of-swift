import Core
import Foundation

extension Year2025 {
  struct Day01 {
    private let data: [Int]
  }
}

extension Year2025.Day01: AdventDay {
  init(data: String) {
    self.data =
      data
      .replacingOccurrences(of: "R", with: "")
      .replacingOccurrences(of: "L", with: "-")
      .split(separator: "\n")
      .compactMap { Int($0) }
  }

  func part1() throws -> Int {
    data.reduce(into: Intermediate()) { intermediate, number in
      intermediate.sum += number
      intermediate.sum %= 100
      if intermediate.sum == 0 {
        intermediate.zeroes += 1
      }
    }.zeroes
  }

  func part2() throws -> Int {
    data.reduce(into: Intermediate()) { intermediate, number in
      if number < 0, intermediate.sum > 0 {
        intermediate.sum -= 100
      }
      intermediate.sum += number
      intermediate.zeroes += Int(abs(intermediate.sum / 100))
      intermediate.sum %= 100
      intermediate.sum += 100
      intermediate.sum %= 100
    }.zeroes
  }
}

private struct Intermediate {
  var zeroes = 0
  var sum = 50
}
