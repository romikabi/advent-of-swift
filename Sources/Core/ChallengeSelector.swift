import ArgumentParser

public struct ChallengeSelector {
  private let day: Int?
  private let year: Int?
  private let challenges: [any AdventDay]

  public init(day: Int?, year: Int?, challenges: [any AdventDay]) {
    self.day = day
    self.year = year
    self.challenges = challenges
  }

  public var selectedChallenge: any AdventDay {
    get throws {
      let years = challenges.map(\.year)
      let targetYear =
        if let year {
          year
        } else if years.contains(nil) {
          nil as Int?
        } else {
          years.compactMap { $0 }.max()
        }
      let yearChallenges = challenges.filter { $0.year == targetYear }
      let targetDay = day ?? yearChallenges.map(\.day).max()
      let matchingChallenges = yearChallenges.filter { $0.day == targetDay }

      if let firstChallenge = matchingChallenges.first {
        if matchingChallenges.count > 1 {
          throw error(prefix: "Multiple solutions found")
        }
        return firstChallenge
      } else {
        throw error(prefix: "No solution found")
      }
    }
  }

  private func error(prefix: String) -> ValidationError {
    guard day != nil || year != nil else { return ValidationError(prefix) }
    return ValidationError(
      [
        prefix,
        "for",
        day.map { "day \($0)" },
        year.map { "year \($0)" },
      ].compactMap { $0 }.joined(separator: " "))
  }
}
