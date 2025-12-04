import Testing

@testable import Core

struct ChallengeSelectorTests {
  @Test func `day and year specified, matching challenge present`() throws {
    struct Day05Year2010: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: 2010,
      challenges: [
        Day05Year2010()
      ])
    #expect(try selector.selectedChallenge is Day05Year2010)
  }

  @Test func `day and year specified, only wrong day challenge present`() throws {
    struct Day06Year2010: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: 2010,
      challenges: [
        Day06Year2010()
      ])
    #expect(throws: Error.self) {
      try selector.selectedChallenge
    }
  }

  @Test func `day and year specified, only wrong year challenge present`() throws {
    struct Day05Year2011: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: 2010,
      challenges: [
        Day05Year2011()
      ])
    #expect(throws: Error.self) {
      try selector.selectedChallenge
    }
  }

  @Test func `day and year specified, multiple matching challenges present`() throws {
    struct Day05Year2010: AdventDay {}
    struct AnotherDay05Year2010: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: 2010,
      challenges: [
        Day05Year2010(),
        AnotherDay05Year2010(),
      ])
    #expect(throws: Error.self) {
      try selector.selectedChallenge
    }
  }

  @Test func `only day specified, challenge from latest year is selected`() throws {
    struct Day05Year2009: AdventDay {}
    struct Day05Year2010: AdventDay {}
    struct Day05Year2011: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: nil,
      challenges: [
        Day05Year2010(),
        Day05Year2011(),
        Day05Year2009(),
      ])
    #expect(try selector.selectedChallenge is Day05Year2011)
  }

  @Test func `only year specified, latest challenge from that year is selected`() throws {
    struct Day05Year2009: AdventDay {}
    struct Day05Year2010: AdventDay {}
    struct Day05Year2011: AdventDay {}
    let selector = ChallengeSelector(
      day: nil, year: 2010,
      challenges: [
        Day05Year2009(),
        Day05Year2010(),
        Day05Year2011(),
      ])
    #expect(try selector.selectedChallenge as? Day05Year2010 != nil)
  }

  @Test func `only year specified, challenges from that year aren't present`() throws {
    struct Day05Year2009: AdventDay {}
    struct Day05Year2011: AdventDay {}
    let selector = ChallengeSelector(
      day: nil, year: 2010,
      challenges: [
        Day05Year2009(),
        Day05Year2011(),
      ])
    #expect(throws: Error.self) {
      try selector.selectedChallenge
    }
  }

  @Test func `only day specified, challenge without year selected`() throws {
    struct Day05Year2010: AdventDay {}
    struct Day05: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: nil,
      challenges: [
        Day05Year2010(),
        Day05(),
      ])
    #expect(try selector.selectedChallenge is Day05)
  }

  @Test func `only day specified, all challenges have years, latest year is selected`() throws {
    struct Day05Year2010: AdventDay {}
    struct Day05Year2011: AdventDay {}
    let selector = ChallengeSelector(
      day: 5, year: nil,
      challenges: [
        Day05Year2010(),
        Day05Year2011(),
      ])
    #expect(try selector.selectedChallenge is Day05Year2011)
  }
}

extension AdventDay {
  fileprivate init(data: String) {
    self.init()
  }
  fileprivate func part1() async throws {}
}
