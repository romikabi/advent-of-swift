import Core
import Foundation

extension Year2025 {
  struct Day02 {
    private let data: [ClosedRange<UInt>]
  }
}

extension Year2025.Day02: AdventDay {
  init(data: String) {
    self.data = data.split(separator: ",").compactMap { range -> ClosedRange<UInt>? in
      let numbers = range.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "-")
      guard numbers.count == 2,
        let first = UInt(numbers[0]),
        let second = UInt(numbers[1]),
        first <= second
      else {
        print("dropped <\(range)>")
        return nil
      }
      return first...second
    }
  }

  func part1() -> UInt {
    slowSolve { number in
      let string = "\(number)"
      let index = string.index(string.startIndex, offsetBy: string.count / 2)
      return string.count.isMultiple(of: 2) && string[..<index] == string[index...]
    }
  }

  func part2() -> UInt {
    data.reduce(0) { sum, range in
      let sLower = String(range.lowerBound)
      let sUpper = String(range.upperBound)
      return sum
        + (2...sUpper.count).reduce(into: Set<UInt>()) { set, times in
          var part = UInt(sLower.prefix(sLower.count / times)) ?? 1
          while true {
            let number = UInt(String(repeating: "\(part)", count: times))!
            if number > range.upperBound {
              break
            }
            if range.contains(number) {
              set.insert(number)
            }
            part += 1
          }
        }.reduce(0, +)
    }
  }

  private func slowSolve(isBad: (UInt) -> Bool) -> UInt {
    data.reduce(0) { sum, range in
      sum
        + range.reduce(0) { sum, number in
          return sum + (isBad(number) ? number : 0)
        }
    }
  }
}
