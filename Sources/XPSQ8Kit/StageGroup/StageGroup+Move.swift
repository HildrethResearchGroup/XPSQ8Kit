//
//  StageGroup+Move.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension StageGroup {
  /// Move the specified stage by the target displacement in mm.
  ///
  /// #Example#
  /// ````
  /// // Move the x stage by 5 mm
  /// try group.moveRelative(to: 5, for: xStage)
  /// ````
  ///
  /// - Parameters:
  ///   - targetDisplacement: The distance in mm to move.
  ///   - stage: The stage to move.
  func moveRelative(to targetDisplacement: Double, for stage: Stage) throws {
    try controller.group.moveRelative(stage: stage.fullyQualifiedName,
                                      byDisplacement: targetDisplacement)
  }
  
  /// Move the specified stage to the target location in mm.
  ///
  /// #Example#
  /// ````
  /// // Move the x stage to 5 mm from the origin
  /// group.moveAbsolute(to: 5, for: xStage)
  /// ````
  ///
  /// - Parameters:
  ///   - location: The location to move to.
  ///   - stage: The stage to move.
  func moveAbsolute(to location: Double, for stage: Stage) throws {
    try controller.group.moveAbsolute(stage: stage.fullyQualifiedName,
                                      toLocation: location)
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
  /// #Example#
  /// ````
  /// try group.searchForHome()
  /// ````
  ///
  /// - Note: The group must be initialized and the group must be in “NOT REFERENCED” state else this function returns the ERR_NOT_ALLOWED_ACTION (-22) error. If no error then the group status becomes “HOMING”.
  func searchForHome() throws {
    try controller.group.homeSearch(group: name)
  }
  
  /// Kills the selected group to go to “NOTINIT” status.
  ///
  /// Kills the selected group to stop its action. The group returns to the “NOTINIT” state. If the group is already in this state then it stays in the “NOT INIT” state.
  /// The GroupKill is a high priority command that is executed in any condition.
  ///
  /// #Example#
  /// ````
  /// try group.kill()
  /// ````
  func kill() throws {
    try controller.group.kill(group: name)
  }
  
  /// Disables motion for the group.
  ///
  /// Turns OFF the motors, stops the corrector servo loop and disables the position compare mode if active. The group status becomes “DISABLE”.
  /// If the group is not in the “READY” state then an ERR\_NOT\_ALLOWED\_ACTION (- 22) is returned.
  ///
  /// #Example#
  /// ````
  /// try group.disableMotion()
  /// ````
  func disableMotion() throws {
    try controller.group.disableMotion(group: name)
  }
  
  /// Enables motion for the group.
  ///
  /// Turns ON the motors and restarts the corrector servo loops. The group state becomes “READY”.
  /// If the group is not in the “DISABLE” state then the “ERR\_NOT\_ALLOWED\_ACTION (-22)” is returned.
  ///
  /// #Example#
  /// ````
  /// try group.enableMotion()
  /// ````
  func enableMotion() throws {
    try controller.group.enableMotion(group: name)
  }
  
  /// The motion status for the given stage.
  ///
  /// #Example#
  /// ````
  /// // Get x stage status
  /// let stageStatus = try group.motionStatus(for: xStage)
  /// ````
  ///
  /// To get the motion status for the group, see ``groupMotionStatus``.
  ///
  /// - Parameter stage: The stage to get the status of.
  /// - Returns: The stage or group status.
  func motionStatus(for stage: Stage) throws -> Stage.MotionStatus {
    return try controller.group.getMotionStatus(stageOrGroupName: stage.fullyQualifiedName)
  }
  
  /// The motion status for the group.
  ///
  /// #Example#
  /// ````
  /// let groupStatus = try group.groupMotionStatus
  /// ````
  var groupMotionStatus: Stage.MotionStatus {
    get throws {
      try controller.group.getMotionStatus(stageOrGroupName: name)
    }
  }
  
  /// Aborts the motion or the jog in progress for the given stage.
  ///
  /// If the group status is “MOVING”, this function stops the motion of the selected positioner.
  /// If the group status is “JOGGING”, this function stops the “jog” motion of the selected positioner.
  /// If the positioner is idle, an ERR_NOT_ALLOWED_ACTION (-22) is thrown.
  ///
  /// After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, otherwise the group stays in the same state.
  ///
  /// - Note: The stage state must be “MOVING” or “JOGGING” else the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
  ///
  /// - Parameter stage: The stage to abort moves for.
  func abortMove(for stage: Stage) throws {
    try controller.group.abortMove(stage.fullyQualifiedName)
  }
  
  /// Aborts the motion or the jog in progress for all stages in the group.
  ///
  /// 1) If the group status is “MOVING”, this function stops all motion in progress.
  /// 2) If the group status is “JOGGING”, this function stops all “jog” motions in progress and disables the jog mode. After this “group move abort” action, the group status becomes “READY”.
  ///
  /// After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, otherwise the group stays in the same state.
  ///
  /// - Note: The group state must be “MOVING” or “JOGGING” else the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
  func abortAllMoves() throws {
    try controller.group.abortMove(name)
  }
  
  // TODO: Change the return type to an enum containing all possible status codes
  /// The status code of the group.
  ///
  /// The group status codes are listed in the “Group status list” § 0. The description of the group status code can be retrieved from the “GroupStatusStringGet” function.
  ///
  /// #Example#
  /// ````
  /// let statusCode = try group.statusCoe
  /// ````
  var statusCode: Int {
    get throws {
      try controller.group.getStatus(group: name)
    }
  }
  
  // TODO: Deprecate this function after converting the status codes into an enum (make sure to provide the localizedString property to describe the error). It may also be beneficial to add conformance to CustomStringConvertable providing a description of the error in the `var description: String { get }` property.
  /// Gets the description of the state of the group.
  ///
  /// This function returns the group state description corresponding to a group state code (see § 0 Group state list).
  /// If the group state code is not referenced then the “Error: undefined status” message will be returned.
  ///
  /// #Example#
  /// ````
  /// // Get the description for the state 25
  /// let stateDescription = group.statusString(for: 25)
  /// ````
  ///
  /// - Parameter code: The state code of the group.
  /// - Returns: The description of the given state.
  func statusString(for code: Int) throws -> String {
    try controller.group.getStatusString(code: code)
  }
  
  /// Returns the velocity for the given stage.
  ///
  /// #Example#
  /// ````
  /// let velocity = try group.currentVelocity(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to get the velocity from.
  /// - Returns: The velocity of the given stage.
  func currentVelocity(for stage: Stage) throws -> Double {
    try controller.group.getCurrentVelocity(forStage: stage.fullyQualifiedName)
  }
}
