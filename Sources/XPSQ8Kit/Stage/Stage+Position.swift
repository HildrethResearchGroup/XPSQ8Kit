//
//  Stage+Position.swift
//  
//
//  Created by Connor Barnes on 7/2/21.
//

public extension Stage {
  /// The setpoint position for the stage.
  ///
  /// The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
  ///
  /// # Example #
  /// ````
  /// let currentPosition = try stage.currentPosition
  /// ````
  var currentPosition: Double {
    get async throws {
      let message = "GroupPositionCurrentGet(\(fullyQualifiedName), double *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: Double.self)
    }
  }
  
  /// The setpoint position of the selected stage.
  ///
  /// Implements the `void GroupPositionSetpointGet(char groupName[250], double *CurrentEncoderPosition)` XPS function at the Stage Group through the Controller getCurrent function.  The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
  ///
  /// # Example #
  /// ````
  /// let setpoint = try stage.setpoint
  /// ````
  var setpoint: Double {
    get async throws {
      let message = "GroupPositionSetpointGet(\(fullyQualifiedName), double *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: Double.self)
    }
  }
  
  /// Returns the target position for the stage.
  ///
  /// Implements the `void GroupPositionTargetGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group.`
  ///
  /// Returns the target position for one or all positioners of the selected group. The target position represents the “end” position after the move.
  ///
  /// For instance, during a move from 0 to 10 units, the position values are:
  /// - GroupPositionTargetGet => 10.0000
  /// - GroupPositionCurrentGet => 5.0005
  /// - GroupPositionSetpointGet => 5.0055
  ///
  /// # Example #
  /// ````
  /// let target = try stage.target
  /// ````
  var target: Double {
    get async throws {
      let message = "GroupPositionTargetGet(\(fullyQualifiedName), double *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: Double.self)
    }
  }
}
