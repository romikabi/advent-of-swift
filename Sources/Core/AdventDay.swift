import ArgumentParser
import Foundation
import RegexBuilder

public protocol AdventDay: Sendable {
  associatedtype Answer = Int

  /// The day of the Advent of Code challenge.
  ///
  /// You can implement this property, or, if your type is named with the
  /// day number following `Day` (like `Day01`), it is derived automatically.
  static var day: Int { get }

  /// The year of the Advent of Code challenge.
  ///
  /// You can implement this property, or, if your type is named with the
  /// year number following `Year` (like `Year2015Day01`), it is derived automatically.
  static var year: Int? { get }

  /// An initializer that uses the provided test data.
  init(data: String)

  /// Computes and returns the answer for part one.
  func part1() async throws -> Answer

  /// Computes and returns the answer for part two.
  func part2() async throws -> Answer
}

public struct PartUnimplemented: Error {
  public let day: Int
  public let part: Int
}

extension AdventDay {
  // Find the challenge day from the type name.
  public static var day: Int {
    guard let day = getNumberFromTypeName(prefixedBy: "Day")
    else {
      fatalError(
        """
        Day number not found in type name: \
        implement the static `day` property \
        or use the day number in your type's name following `Day` (like `Day03`).")
        """)
    }
    return day
  }

  public static var year: Int? {
    getNumberFromTypeName(prefixedBy: "Year")
  }

  private static func getNumberFromTypeName(prefixedBy prefix: String) -> Int? {
    let typeName = String(reflecting: Self.self)
    let regex = Regex {
      prefix
      ZeroOrMore("0")
      Capture {
        OneOrMore(.digit)
      }
    }
    guard let match = typeName.firstMatch(of: regex) else { return nil }
    return Int(match.output.1)
  }

  public var day: Int {
    Self.day
  }

  public var year: Int? {
    Self.year
  }

  // Default implementation of `part2`, so there aren't interruptions before
  // working on `part1()`.
  public func part2() throws -> Answer {
    throw PartUnimplemented(day: day, part: 2)
  }

  /// An initializer that loads the test data from the corresponding data file.
  public init() throws {
    self.init(data: try Self.loadData())
  }

  public static func loadData() throws -> String {
    let dayString = String(format: "Day%02d", day)
    let dataURL: URL
    if let year, year != 0 {
      let yearString = String(format: "Year%04d", year)
      let url =
        // Data/Year0000Day00.txt
        Bundle.module.url(
          forResource: yearString + dayString,
          withExtension: "txt",
          subdirectory: "Data"
        )
        // Data/0000/Day00.txt
        ?? Bundle.module.url(
          forResource: dayString,
          withExtension: "txt",
          subdirectory: "Data/\(year)/"
        )
      if let url {
        dataURL = url
      } else {
        throw ValidationError(
          "Couldn't find file '\(dayString).txt' in the 'Data/\(year)' directory.")
      }
    } else {
      // Data/Day00.txt
      let url = Bundle.module.url(
        forResource: dayString,
        withExtension: "txt",
        subdirectory: "Data"
      )
      if let url {
        dataURL = url
      } else {
        throw ValidationError("Couldn't find file '\(dayString).txt' in the 'Data' directory.")
      }
    }

    guard let data = try? String(contentsOf: dataURL, encoding: .utf8)
    else {
      fatalError("Couldn't read file at \(dataURL.path()).")
    }

    // On Windows, line separators may be CRLF. Converting to LF so that \n
    // works for string parsing.
    return data.replacingOccurrences(of: "\r", with: "")
  }
}
