//
//  StageGroup+Jog.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension StageGroup {
  /// Returns a tuple containing the current velocity and acceleration of the given stage.
  ///
  /// Implements  the `void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber)` XPS function at the Stage Group through the Controller getCurrent function.
  ///
  /// #Example#
  /// ````
  /// let (velocity, acceleration) = try currentJog(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage tao find the jog information for.
  /// - Returns: The current velocity (in mm/s) and acceleration (mm/s^2) of the given stage.
  func currentJog(for stage: Stage) throws -> (velocity: Double, acceleration: Double) {
    try controller.group.jog.getCurrent(stage: stage.fullyQualifiedName)
  }
  
  /// Disables jog mode for the group.
  ///
  /// Implements  the `int GroupJogModeDisable (int SocketID, char *GroupName)`  XPS function.
  ///
  /// Disables the Jog mode. To use this function, the group must be in the “JOGGING” state and all positioners must be idle (meaning velocity must be 0).
  /// This function exits the “JOGGING” state and to returns to the “READY” state. If the group state is not in the “JOGGING” state or if the profiler velocity is not null then the error ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// #Example#
  /// ````
  /// try group.disableJog()
  /// ````
  func disableJog() throws {
    try controller.group.jog.disable(group: name)
  }
  
  /// Enables jog mode for the group.
  ///
  /// Implements  the `int GroupJogModeEnable (int SocketID, char *GroupName)`  XPS function.
  ///
  /// Enables the Jog mode. To use this function, the group must be in the “READY” state and all positioners must be idle (meaning velocity must be 0).
  /// This function goes to the “JOGGING” state. If the group state is not “READY”, ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// #Example#
  /// ````
  /// try group.enableJog()
  /// ````
  func enableJog() throws {
    try controller.group.jog.enable(group: self.name)
  }
  
  /// Returns a tuple containing the  current jog velocity (in mm/s) and acceleration (in mm/s^2) settings of the given stage.
  ///
  /// Implements  the ````int GroupJogParametersGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)````  XPS function.
  ///
  /// This function returns the velocity and the acceleration set by the user to use the jog mode for one positioner or for all positioners of the selected group.
  /// So, this function must be called when the group is in “JOGGING” mode else the velocity and the acceleration will be null.
  /// To change the velocity and the acceleration on the fly, in the jog mode, call the “GroupJogParametersSet” function.
  ///
  /// - Parameter stage: The stage to get the parameters for.
  /// - Returns: The velocity (in mm/s) and acceleration (in mm/s^2).
  func jogParameters(for stage: Stage) throws -> (velocity: Double, acceleration: Double) {
    // Generate the complete stage name for the stage.
    let completeStageName = stage.fullyQualifiedName
    let currentVelocityAndAcceleration = try controller.group.jog.getParameters(stage: completeStageName)
    return currentVelocityAndAcceleration
  }
}
