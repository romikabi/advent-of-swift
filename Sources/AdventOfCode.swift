@_exported import Algorithms
import ArgumentParser
@_exported import Collections
import Core

// Add each new day implementation to this array:
private let allChallenges: [any AdventDay.Type] =
  [
    Day00.self
  ]
  + Year2023.challenges
  + Year2025.challenges

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Argument(help: "The year of the challenge.")
  var year: Int?

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false

  @Flag(help: "Run all the days available")
  var all: Bool = false

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result! {
    case .success(let success):
      print("\(named): \(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    let challengeTypes =
      if all {
        allChallenges
      } else {
        try [
          ChallengeSelector(
            day: day,
            year: year,
            challenges: allChallenges
          ).selectedChallenge
        ]
      }

    for challengeType in challengeTypes {
      let day = challengeType.day
      let year = challengeType.year ?? 0
      print("Executing Advent of Code \(year != 0 ? "\(year) " : "")challenge \(day)...")
      let challenge = try challengeType.init()

      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")

      if benchmark {
        print("Part 1 took \(timing1), part 2 took \(timing2).")
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }
}
