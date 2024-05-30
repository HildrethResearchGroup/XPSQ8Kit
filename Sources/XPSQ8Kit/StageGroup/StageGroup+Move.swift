//
//  StageGroup+Move.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension StageGroup {
  /// Initializes the stage group.
  ///
  /// This corresponds to the GroupInitialize() XPS-Q8 function
  func initialize() async throws {
    let command = "GroupInitialize(\(name))"
    try await controller.communicator.write(string: command)
//    try await controller.communicator.validateNoReturn()
  }
  
  /// Starts the home search sequence.
  ///
  /// This function initiates a home search for each positioner of the selected group.
  ///
  /// The home search can fail due to:
  ///   1. a following error: ERR\_FOLLOWING\_ERROR (-25)
  ///   2. a ZM detection error: ERR\_GROUP\_HOME\_SEARCH\_ZM\_ERROR (-49)
  ///   3. a motion done time out when a dynamic error of the positioner is detected during one of the moves during the home search process: ERR\_GROUP\_MOTION\_DONE\_TIMEOUT (-33)
  ///   4. a home search timeout when the complete (and complex) home search procedure was not executed in the allowed time: ERR\_HOME\_SEARCH\_TIMEOUT (-28)
  ///
  /// For all these errors, the group returns to the “NOTINIT” state.
  /// After the home search sequence, each positioner error is checked. If an error is detected, the hardware status register is reset (motor on) and the positioner error is cleared before checking it again. If a positioner error is always present, ERR\_TRAVEL\_LIMITS (-35) is returned and the group becomes “NOTINIT”.
  /// Once the home search is successful, the group is in “READY” state.
  ///
  /// # Example #
  /// ````
  /// try await group.searchForHome()
  /// ````
  ///
  /// - Note: The group must be initialized and the group must be in “NOT REFERENCED” state else this function returns the ERR_NOT_ALLOWED_ACTION (-22) error. If no error then the group status becomes “HOMING”.
  func searchForHome() async throws {
    let command = "GroupHomeSearch(\(name))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Kills the selected group to go to “NOTINIT” status.
  ///
  /// Kills the selected group to stop its action. The group returns to the “NOTINIT” state. If the group is already in this state then it stays in the “NOT INIT” state.
  /// The GroupKill is a high priority command that is executed in any condition.
  ///
  /// # Example #
  /// ````
  /// try await group.kill()
  /// ````
  func kill() async throws {
    let command = "GroupKill(\(name))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Disables motion for the group.
  ///
  /// Turns OFF the motors, stops the corrector servo loop and disables the position compare mode if active. The group status becomes “DISABLE”.
  /// If the group is not in the “READY” state then an ERR\_NOT\_ALLOWED\_ACTION (- 22) is returned.
  ///
  /// # Example #
  /// ````
  /// try await group.disableMotion()
  /// ````
  func disableMotion() async throws {
    let command = "GroupMotionDisable(\(name))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Enables motion for the group.
  ///
  /// Turns ON the motors and restarts the corrector servo loops. The group state becomes “READY”.
  /// If the group is not in the “DISABLE” state then the “ERR\_NOT\_ALLOWED\_ACTION (-22)” is returned.
  ///
  /// # Example #
  /// ````
  /// try await group.enableMotion()
  /// ````
  func enableMotion() async throws {
    let command = "GroupMotionEnable(\(name))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// The motion status for the group.
  ///
  /// # Example #
  /// ````
  /// let groupStatus = try await group.groupMotionStatus
  /// ````
  var motionStatus: Stage.MotionStatus {
    get async throws {
      let command = "GroupMotionStatusGet(\(name), int *)"
      try await controller.communicator.write(string: command)
      let status = try await controller.communicator.read(as: Int.self)
      
      if let motionStatus = Stage.MotionStatus(rawValue: status) {
        return motionStatus
      } else {
        throw XPSQ8Communicator.Error.couldNotDecode
      }
    }
  }
  
  /// Aborts the motion or the jog in progress for all stages in the group.
  ///
  /// 1) If the group status is “MOVING”, this function stops all motion in progress.
  /// 2) If the group status is “JOGGING”, this function stops all “jog” motions in progress and disables the jog mode. After this “group move abort” action, the group status becomes “READY”.
  ///
  /// After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, otherwise the group stays in the same state.
  ///
  /// - Note: The group state must be “MOVING” or “JOGGING” else the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
  func abortAllMoves() async throws {
    let command = "GroupMoveAbort(\(name))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  // TODO: Deprecate this function after converting the status codes into an enum (make sure to provide the localizedString property to describe the error). It may also be beneficial to add conformance to CustomStringConvertible providing a description of the error in the `var description: String { get }` property.
  /// Gets the description of the state of the group.
  ///
  /// This function returns the group state description corresponding to a group state code (see § 0 Group state list).
  /// If the group state code is not referenced then the “Error: undefined status” message will be returned.
  ///
  /// # Example #
  /// ````
  /// // Get the description for the state 25
  /// let stateDescription = try await group.statusString(for: 25)
  /// ````
  ///
  /// - Parameter code: The state code of the group.
  /// - Returns: The description of the given state.
  func statusString(for code: Int) async throws -> String {
    let command = "GroupStatusStringGet(\(code), char *)"
    try await controller.communicator.write(string: command)
    return try await controller.communicator.read(as: (String.self))
  }
}
