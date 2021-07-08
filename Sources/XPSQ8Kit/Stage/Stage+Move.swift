//
//  Stage+Move.swift
//  
//
//  Created by Connor Barnes on 7/2/21.
//

public extension Stage {
  /// Moves the stage by the target displacement in mm.
  ///
  /// # Example #
  /// ````
  /// // Move the stage in the reverse direction by 5 mm.
  /// try await stage.moveRelative(by: -5)
  /// ````
  ///
  /// - Parameter displacement: The distance in millimeters that the stage should be moved.
  func moveRelative(by displacement: Double) async throws {
    let command = "GroupMoveRelative(\(fullyQualifiedName),\(displacement))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Moves the stage to an absolute location.
  ///
  /// # Example #
  /// ````
  /// // Move the stage to -5 mm from the origin along the stage's axis
  /// try await stage.moveAbsolute(to: -5)
  /// ````
  ///
  /// - Parameter toLocation: The location in mm to move the stage to.
  func moveAbsolute(to location: Double) async throws {
    let command = "GroupMoveAbsolute(\(fullyQualifiedName),\(location))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Returns the motion status for the stage.
  ///
  /// # Example #
  /// ````
  /// let status = try await stage.motionStatus
  /// ````
  ///
  /// - Returns: Positioner or group  status.
  var motionStatus: MotionStatus {
    get async throws {
      let command = "GroupMotionStatusGet(\(fullyQualifiedName), int *)"
      try await controller.communicator.write(string: command)
      let status = try await controller.communicator.read(as: Int.self)
      
      if let motionStatus = Stage.MotionStatus(rawValue: status) {
        return motionStatus
      } else {
        throw XPSQ8Communicator.Error.couldNotDecode
      }
    }
  }
  
  /// Aborts the motion or the jog in progress for a group or a positioner.
  ///
  /// This function aborts a motion or a jog in progress. The group state must be “MOVING” or “JOGGING” otherwise “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
  ///
  /// For a group:
  /// 1) If the group status is “MOVING”, this function stops all motion in progress.
  /// 2) If the group status is “JOGGING”, this function stops all “jog” motions in progress and disables the jog mode. After this “group move abort” action, the group status becomes “READY”.
  ///
  /// For a positioner:
  /// 1) If the group status is “MOVING”, this function stops the motion of the selected positioner.
  /// 2) If the group status is “JOGGING”, this function stops the “jog” motion of the selected positioner.
  /// 3) If the positioner is idle, an ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, else the group stays in the same state.
  ///
  /// # Example #
  /// ````
  /// try await stage.moveRelative(to: -100)
  /// // The stage will stop moving
  /// try await abortMove()
  /// ````
  func abortMove() async throws {
    let command = "GroupMoveAbort(\(fullyQualifiedName))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  // FIXME: Determine the unit of velocity
  /// The current velocity for one or all positioners of the selected group in *UNIT*.
  ///
  /// # Example #
  /// ````
  /// let velocity = try await stage.currentVelocity
  /// ````
  var currentVelocity: Double {
    get async throws {
      let command = "GroupVelocityCurrentGet(\(fullyQualifiedName), double *)"
      try await controller.communicator.write(string: command)
      return try await controller.communicator.read(as: (Double.self))
    }
  }
}

// MARK: - Motion Status
extension Stage {
  /// The motion status for a stage
  public enum MotionStatus: Int {
    /// Not moving state (group status in NOT\_INIT, NOT\_REF or READY).
    case notMoving = 0
    /// Busy state (positioner in moving, homing, referencing, spinning, analog tracking, trajectory, encoder calibrating, slave mode).
    case busy = 1
  }
}
