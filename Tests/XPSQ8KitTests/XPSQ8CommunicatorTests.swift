import XCTest
@testable import XPSQ8Kit

final class XPSQ8CommunicatorTests: XCTestCase {
	
	/// The communicator to be used by the tests
	static var communicator: XPSQ8Communicator!
	
	override class func setUp() {
		communicator = try? .init(address: "192.168.0.254", port: 5001, timeout: 5.0)
	}
	
	/// Tests that an instrument is connected to properly. If this is failing, check the connection between the instrument. This will cause most other tests to fail.
	func testConnectToInstrument() {
		// The communicator needs to be created before any tests are run, so it has to be created in setUp(). We check that it is not nil here.
		XCTAssertNotNil(Self.communicator, "Could not create communicator.")
	}
	
	/// Tests that the read write functionality is working by sending the function `ElapsedTimeGet(double *)`.
	///
	/// The choise of function is arbitrary - `ElapsedTimeGet(double *)` was chosen because its ouput is a single Double value.
	func testReadWrite() async {
		guard let communicator = Self.communicator else {
			XCTFail("Could not create communicator.")
			return
		}
		
		do {
      try await communicator.write(string: "ElapsedTimeGet(double *)")
		} catch {
			XCTFail("Could not write.")
			return
		}
		
		do {
			_ = try await communicator.read(as: Double.self)
		} catch {
			XCTFail("Could not read.")
			return
		}
	}
	
	static var allTests = [
		("testConnectToInstrument", testConnectToInstrument),
		("testGetTimeElapsed", testReadWrite),
	]
}
