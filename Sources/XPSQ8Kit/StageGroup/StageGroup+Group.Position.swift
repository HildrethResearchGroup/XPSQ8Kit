//
//  StageGroup.Group.Positioner.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension StageGroup {
  /// Returns the setpoint position for one or all positioners of the selected group.
  ///
  /// Returns the setpoint position for one or all positioners of the selected group.
  /// The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
  ///
  /// #Example#
  /// ````
  /// let currentPosition = try group.currentPosition(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to find the position setpoint of.
  /// - Returns: The position setpoint of the given stage.
  func currentPosition(for stage: Stage) throws -> Double {
    try controller.group.position.getCurrent(stage: stage.fullyQualifiedName)
  }
  
  /// Returns the setpoint position of the given stage.
  ///
  /// Implements the `void GroupPositionSetpointGet(char groupName[250], double *CurrentEncoderPosition)` XPS function at the Stage Group through the Controller getCurrent function.  The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
  ///
  /// #Example#
  /// ````
  /// let setpoint = try group.setpoint(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to find the setpoint position of.
  /// - Returns: The setpoint position of the specified stage.
  func setpoint(for stage: Stage) throws -> Double {
    try controller.group.position.getSetpoint(stage: stage.fullyQualifiedName)
  }
  
  /// Returns the target position for the given stage.
  ///
  /// Implements the `void GroupPositionTargetGet(char groupName[250], double *CurrentEncoderPosition)`  XPS function at the Stage Group.
  ///
  /// Returns the target position for one or all positioners of the selected group. The target position represents the “end” position after the move.
  ///
  /// #Example#
  /// ````
  /// try group.target(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to find the target of.
  /// - Returns: The target position of the given stage.
  func target(for stage: Stage) throws -> Double {
    try controller.group.position.getTarget(stage: stage.fullyQualifiedName)
  }
}
