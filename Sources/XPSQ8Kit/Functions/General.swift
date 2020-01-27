//
//  General.swift
//  
//
//  Created by Connor Barnes on 12/20/19.
//

// General functions that are not placed in a namespace

public extension XPSQ8Controller {
	struct Status {
		public var code: Int
	}
}

// MARK: Functions

public extension XPSQ8Controller {
	/// Close all socket beside the one used to send this command.
	func closeAllOtherSockets() throws {
		try communicator.write(string: "CloseAllOtherSockets()")
		try communicator.validateNoReturn()
	}
    
    
    /**
     Get  XPS Controller hardware's current Firmware Version.  Implements the FirmwareVersionGet(char *) XPS function.
     
     - returns: A string containing the current firmware vision.
     
            do {
                let firmwareVersion = try controller?.getFirmwareVersion()
                print(firmwareVersion ?? "No firmware version text recieved")
            } catch {
                print(error)
            }
     */
    func getFirmwareVersion() throws -> String {
        try communicator.write(string: "FirmwareVersionGet(char *)")
        let string = try communicator.read(as: String.self)
        
        return string
    }
	
    /// Get controller motion kernel time load.
	func getMotionKernalTimeLoad() throws -> (cpuTotalLoadRatio: Double, cpuCorrectorLoadRatio: Double, cpuProfilerLoadRatio: Double, cpuServitudesLoadRatio: Double) {
		try communicator.write(string: "ControllerMotionKernelTimeLoadGet(double  *,double  *,double  *,double  *)")
		let load = try communicator.read(as: (Double.self, Double.self, Double.self, Double.self))
		
		return (cpuTotalLoadRatio: load.0,
						cpuCorrectorLoadRatio: load.1,
						cpuProfilerLoadRatio: load.2,
						cpuServitudesLoadRatio: load.3)
	}
	
    /// Get controller current status and reset the status.
	func getStatus() throws -> Status {
		try communicator.write(string: "ControllerStatusGet(int  *)")
		let code = try communicator.read(as: Int.self)
		
		return Status(code: code)
	}
	
	/// Read controller current status.
	func readStatus() throws -> Status {
		try communicator.write(string: "ControllerStatusRead(int *)")
		let code = try communicator.read(as: Int.self)
		
		return Status(code: code)
	}
	
	/// Return the controller status string.
	///
	/// - Parameter status: The status to get the description of.
	func getStatusString(_ status: Status) throws -> String {
		try communicator.write(string: "ControllerStatusStringGet(\(status.code),char *)")
		let string = try communicator.read(as: String.self)
		
		return string
	}
	
	/// Return elapsed time from controller power on.
	func getTimeElapsed() throws -> Double {
		try communicator.write(string: "ElapsedTimeGet(double *)")
		let timeElapsed = try communicator.read(as: Double.self)
		
		return timeElapsed
	}
	
	/// Return the error string corresponding to the error code.
	///
	/// - Parameter code: The error code to get the description of.
	func getErrorString(code: Int) throws -> String {
		try communicator.write(string: "ErrorStringGet(\(code),char *)")
		let string = try communicator.read(as: String.self)
		
		return string
	}
}
