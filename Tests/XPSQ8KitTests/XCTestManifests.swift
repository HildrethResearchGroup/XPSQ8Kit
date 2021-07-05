import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(XPSQ8KitTests.allTests),
  ]
}
#endif
