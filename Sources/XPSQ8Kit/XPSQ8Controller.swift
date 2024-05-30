//
//  XPSQ8Controller.swift
//
//
//  Created by Connor Barnes on 11/13/19.
//

import Foundation

/// A type for controlling an XPS-Q8 instrument.
public final class XPSQ8Controller {
  var communicator: XPSQ8Communicator
  
  /// Tries to create a controller for an instrument at the given address and port. A timeout value can optionally be specified.
  ///
  /// If a timeout value is not specified, a value of `5.0` seconds will be used.
  ///
  /// # Example:
  ///
  /// The following will try to create a controller for an XPSQ8 instrument at the address `192.168.0.254` and on port number `5001`.
  /// ```
  /// let communicator = try XPSQ8Communicator(address: "192.168.0.254", port: 5001, identifier: "XPSQ8")
  /// ```
  ///
  /// - Parameters:
  ///   - address: The IPV4 address of the instrument in dot notation.
  ///   - port: The port of the instrument.
  ///   - timeout: The maximum time to wait in seconds before timing out when communicating with the instrument.
  public init(address: String, port: Int, timeout: TimeInterval = 5.0) async throws {
    communicator = try await .init(address: address, port: port, timeout: timeout)
  }
  
  /// Disconnects from the instrument.
  public func disconnect() async {
    await communicator.disconnect()
  }
}
