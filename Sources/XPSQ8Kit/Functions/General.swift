//
//  General.swift
//  
//
//  Created by Connor Barnes on 12/20/19.
//

import Foundation

public extension XPSQ8Controller {
  // TODO: Convert this into an enum of possible statuses
  /// An XPS-Q8 status.
  struct Status {
    /// The code of the status.
    public var code: Int
  }
}

// MARK: - Types
public extension XPSQ8Controller {
  typealias TimeLoad = (cpuTotalLoadRatio: Double,
                        cpuCorrectorLoadRatio: Double,
                        cpuProfilerLoadRatio: Double,
                        cpuServitudesLoadRatio: Double)
}

// MARK: - Functions
public extension XPSQ8Controller {
  // TODO: Is this needed? It may only be useful when manually dealing with sockets (as in the C library)
  /// Closes all sockets besides the one used to send this command.
  func closeAllOtherSockets() async throws {
    try await communicator.write(string: "CloseAllOtherSockets()")
    try await communicator.validateNoReturn()
  }
  
  /// The Current hardware's firmware version.
  ///
  /// Implements the `FirmwareVersionGet(char *)` XPS function.
  ///
  /// # Example #
  /// ````
  /// let version = try controller.firmwareVersion
  /// ````
  var firmwareVersion: String {
    get async throws {
      try await communicator.write(string: "FirmwareVersionGet(char *)")
      return try await communicator.read(as: String.self)
    }
  }
  
  /// The controller motion kernel time load.
  ///
  /// Gets the last exact values of controller motion kernel time load (total, corrector, profier, and servitudes calculation time)
  var motionKernelTimeLoad: TimeLoad {
    get async throws {
      try await communicator.write(
        string: "ControllerMotionKernelTimeLoadGet(double  *,double  *,double  *,double  *)"
      )
      return try await communicator.read(as: (Double.self, Double.self, Double.self, Double.self))
    }
  }
  
  /// The controller's current status.
  var status: Status {
    get async throws {
      try await communicator.write(string: "ControllerStatusRead(int  *)")
      let code = try await communicator.read(as: Int.self)
      return Status(code: code)
    }
  }
  
  /// Returns the controller's current status and resets the status.
  @discardableResult func resetStatus() async throws -> Status {
    try await communicator.write(string: "ControllerStatusGet(int  *)")
    let code = try await communicator.read(as: Int.self)
    return Status(code: code)
  }
  
  /// Return the controller status string.
  ///
  /// - Parameter status: The status to get the description of.
  func statusString(of status: Status) async throws -> String {
    try await communicator.write(string: "ControllerStatusStringGet(\(status.code),char *)")
    return try await communicator.read(as: String.self)
  }
  
  /// Return elapsed time in seconds from controller power on.
  var timeElapsed: Double {
    get async throws {
      try await communicator.write(string: "ElapsedTimeGet(double *)")
      return try await communicator.read(as: Double.self)
    }
  }
  
  /// Return the error string corresponding to the error code.
  ///
  /// - Parameter code: The error code to get the description of.
  func errorString(forCode code: Int) async throws -> String {
    try await communicator.write(string: "ErrorStringGet(\(code),char *)")
    return try await communicator.read(as: String.self)
  }
  
  /// Kills all groups, putting them in the "Not initialized" state.
  ///
  /// The function kills and resets all groups as well as analog and digital I/O. The following occurs:
  /// 1. An "emergency stop" is done if the group state is defined as HOMING, REFERENCING, MOVING, JOGGING, or ANALOG\_TRACKING.
  /// 2. The motor is turned off, the motion done is stopped and the control loop is stopped.
  /// 3. ERR\_EMERGENCY\_SIGNAL is returned by each function that is in progress, and where the group state is: MOTOR\_INIT, ENCODER\_CALIBRATING, HOMING, REFERENCING, MOVING, TRAJECTORY, ERR\_EMERGENCY\_SIGNAL.
  /// 4. The group state is set to not initialized for all groups.
  ///
  /// # Example #
  /// ````
  /// try controller.killAll()
  /// ````
  func killAll() async throws {
    let command = "KillAll()"
    try await communicator.write(string: command)
    try await communicator.validateNoReturn()
  }
  
  /// Logs the user in.
  ///
  /// # Example #
  /// ````
  /// try controller.login(username: "User", password: "Pa55w0rd")
  /// ````
  ///
  /// - Parameters:
  ///   - username: The user's username.
  ///   - password: The user's password.
  func login(username: String, password: String) async throws {
    let command = "Login(\(username), \(password))"
    try await communicator.write(string: command)
    try await communicator.validateNoReturn()
  }
  
  /// Reboots the controller.
  ///
  /// # Example #
  /// ````
  /// try controller.reboot()
  /// ````
  ///
  /// - Note: This is a firmware reboot, not a hardware reboot.
  func reboot() async throws {
    let command = "Reboot()"
    try await communicator.write(string: command)
    try await communicator.validateNoReturn()
  }
  
  /// Restarts the controller's application without a hardware reboot.
  ///
  /// # Example #
  /// ````
  /// try controller.restart()
  /// ````
  func restart() async throws {
    let command = "RestartApplication()"
    try await communicator.write(string: command)
    try await communicator.validateNoReturn()
  }
  
  /// The hardware date and time.
  var hardwareDate: Date {
    get async throws {
      let command = "HardwareDateAndTimeGet(char *)"
      try await communicator.write(string: command)
      let dateString = try await communicator.read(as: (String.self))
      
      let formatter = DateFormatter()
      formatter.dateFormat = "E MMM dd HH:mm:ss yyyy"
      
      if let date = formatter.date(from: dateString) {
        return date
      } else {
        throw XPSQ8Communicator.Error.couldNotDecode
      }
    }
  }
}
