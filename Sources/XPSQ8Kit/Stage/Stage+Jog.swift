//
//  Stage+Jog.swift
//  
//
//  Created by Connor Barnes on 7/2/21.
//

public extension Stage {
  /// Returns a tuple containing the current velocity (in mm/s) and acceleration (in mm/s^2) of the specified stage.
  ///
  /// # Example #
  /// ````
  /// let (velocity, acceleration) = try await stage.currentJog
  /// ````
  var currentJog: Jog {
    get async throws {
      let message = "GroupJogCurrentGet(\(fullyQualifiedName), double *, double *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: (Double.self, Double.self))
    }
  }
  
  /// Returns a tuple containing the current jog velocity (in mm/s) and acceleration (in mm/s^2) settings of this stage.
  ///
  /// Implements  the `int GroupJogParametersGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)`  XPS function.
  ///
  /// This function returns the velocity and the acceleration set by the user to use the jog mode for one positioner or for all positioners of the selected group.
  ///
  /// # Example #
  /// ````
  /// let (velocity, acceleration) = try await stage.jogParameters
  /// ````
  ///
  /// - Note:
  /// This function must be called when the group is in “JOGGING” mode, otherwise the velocity and the acceleration will be `nil`.
  ///
  /// - Note:
  /// To change the velocity and the acceleration on the fly, in the jog mode, call the “GroupJogParametersSet” function.
  var jogParameters: Jog {
    get async throws {
      let message = "GroupJogParametersGet(\(fullyQualifiedName), double *, double *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: (Double.self, Double.self))
    }
  }
}
