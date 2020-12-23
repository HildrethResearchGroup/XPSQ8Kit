//
//  XPSQ8Controller.swift
//
//
//  Created by Connor Barnes on 11/13/19.
//

import Foundation

public class XPSQ8Controller {
	
	var communicator: XPSQ8Communicator
    var identifier: String
    
    public var dispatchQueue: DispatchQueue
	
	/// Tries to create a controller for an instrument at the given address and port. A timeout value can optionally be specified.
	///
	/// If a timeout value is not specified, a value of `5.0` seconds will be used.
	///
	/// # Example:
	///
	/// The following will try to create a controller for an XPSQ8 instrument at the address `192.168.0.254` and on port number `5001`.
	/// ```
	/// let communicator = try XPSQ8Communicator(address: "192.168.0.254", port: 5001)
	/// ```
	/// 
	/// - Parameters:
	///   - address: The IPV4 address of the instrument in dot notation.
	///   - port: The port of the instrument.
	///   - timeout: The maximum time to wait in seconds before timing out when communicating with the instrument.
    public init?(address: String, port: Int, timeout: TimeInterval = 5.0, identifier: String) {
		// TODO: Thrown an error instead of returning nil if the instrument could not be connected to.
		do {
			communicator = try .init(address: address, port: port, timeout: timeout)
            self.identifier = identifier
            self.dispatchQueue = DispatchQueue(label: identifier, qos: .userInitiated)
            
		} catch { return nil }
	}
}
