import Testing

@testable import Core

// One off test to validate that basic data load testing works
struct AdventDayTests {
  @Test func testInitData() async throws {
    #expect(Day00().data.starts(with: "4514"))
  }
}

private struct Day00: AdventDay {
  let data: String
  init(data: String) {
    self.data = data
  }
  func part1() async throws {}
}
