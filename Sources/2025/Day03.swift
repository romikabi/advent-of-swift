import Core
import Foundation

extension Year2025 {
  struct Day03 {
    private let data: [[Int]]
  }
}

extension Year2025.Day03: AdventDay {
  init(data: String) {
    self.data = data.split(separator: "\n").map { line in
      line.compactMap { Int(String($0)) }
    }
  }

  func part1() -> Int {
    data.reduce(into: 0) { sum, line in
      let tens = line.dropLast().max() ?? 0
      let tensIndex = line.firstIndex(of: tens) ?? 0
      let ones = line[(tensIndex + 1)...].max() ?? 0
      sum += tens * 10 + ones
    }
  }

  func part2() -> Int {
    data.reduce(into: 0) { sum, line in
      let digits = 12
      var index = line.startIndex
      var endIndex = line.index(line.endIndex, offsetBy: -digits + 1)
      for power in (0..<digits).reversed() {
        let range = line[index..<endIndex]
        let max = range.max() ?? 0
        index = (range.firstIndex(of: max) ?? range.startIndex).advanced(by: 1)
        endIndex = endIndex.advanced(by: 1)
        sum += max * NSDecimalNumber(decimal: pow(10, power)).intValue
      }
    }
  }
}
