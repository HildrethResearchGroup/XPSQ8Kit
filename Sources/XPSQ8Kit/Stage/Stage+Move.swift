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
  /// try stage.moveRelative(by: -5)
  /// ````
  ///
  /// - Parameter targetDisplacement: The distance in millimeters that the stage should be moved.
  func moveRelative(by targetDisplacement: Double) throws {
    try stageGroup.moveRelative(to: targetDisplacement, for: self)
  }
  
  /// Moves the stage to an absolute location.
  ///
  /// # Example #
  /// ````
  /// // Move the stage to -5 mm from the origin along the stage's axis
  /// try stage.moveAbsolute(to: -5)
  /// ````
  ///
  /// - Parameter toLocation: The location in mm to move the stage to.
  func moveAbsolute(to location: Double) throws {
    try stageGroup.moveAbsolute(to: location, for: self)
  }
  
  /// Returns the motion status for the stage.
  ///
  /// # Example #
  /// ````
  /// let status = try stage.motionStatus
  /// ````
  ///
  /// - Returns: Positioner or group  status.
  var motionStatus: MotionStatus {
    get throws {
      try stageGroup.motionStatus(for: self)
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
  /// try stage.moveRelative(to: -100)
  /// // The stage will stop moving
  /// try abortMove()
  /// ````
  func abortMove() throws {
    try stageGroup.abortMove(for: self)
  }
  
  // FIXME: Determine the unit of velocity
  /// The current velocity for one or all positioners of the selected group in *UNIT*.
  ///
  /// # Example #
  /// ````
  /// let velocity = try stage.currentVelocity
  /// ````
  var currentVelocity: Double {
    get throws {
      try stageGroup.currentVelocity(for: self)
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
