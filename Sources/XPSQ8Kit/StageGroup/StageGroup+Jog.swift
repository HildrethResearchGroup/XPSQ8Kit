//
//  StageGroup+Jog.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension StageGroup {
  /// Disables jog mode for the group.
  ///
  /// Implements  the `int GroupJogModeDisable (int SocketID, char *GroupName)`  XPS function.
  ///
  /// Disables the Jog mode. To use this function, the group must be in the “JOGGING” state and all positioners must be idle (meaning velocity must be 0).
  /// This function exits the “JOGGING” state and to returns to the “READY” state. If the group state is not in the “JOGGING” state or if the profiler velocity is not null then the error ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// # Example #
  /// ````
  /// try group.disableJogging()
  /// ````
  func disableJogging() async throws {
    let message = "GroupJogModeDisable(\(name))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Enables jog mode for the group.
  ///
  /// Implements  the `int GroupJogModeEnable (int SocketID, char *GroupName)`  XPS function.
  ///
  /// Enables the Jog mode. To use this function, the group must be in the “READY” state and all positioners must be idle (meaning velocity must be 0).
  /// This function goes to the “JOGGING” state. If the group state is not “READY”, ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// # Example #
  /// ````
  /// try group.enableJogging()
  /// ````
  func enableJogging() async throws {
    let message = "GroupJogModeEnable(\(name))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
}
