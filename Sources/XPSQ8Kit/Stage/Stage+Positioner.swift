//
//  Stage+Positioner.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

public extension Stage {
  /// The Astrom & Hägglund based auto-scaling process for determining the stage scaling acceleration.
  ///
  /// Implements the  `void PositionerAccelerationAutoScaling( char PositionerName[250],  double* Scaling)`  XPS Controller function.
  ///
  /// The function executes an auto-scaling process and returns the calculated scaling acceleration.
  ///
  /// #Example#
  /// ````
  /// let accelerationAutoScaling = try stage.accelerationAutoScaling
  /// ````
  ///
  /// - Note: The selected group must be in “NOTINIT” state, else ERR\_NOT\_ALLOWED\_ACTION (-22) is returned. More information in the programmer manual.
  ///
  /// - Note: This property will take a long time to return a value
  var accelerationAutoScaling: Double {
    get throws {
      try stageGroup.positioner.accelerationAutoScaling(for: self)
    }
  }/// Disables the backlash compensation.
  ///
  /// Implements the  `void PositionerBacklashDisable(char PositionerName[250])`  XPS Controller function.
  ///
  /// This function disables the backlash compensation. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
  ///
  /// In the “stages.ini” file the parameter “Backlash” will enable or disable this feature as follows:
  /// - Backlash = 0 → Disable backlash
  /// - Backlash > 0 → Enable backlash
  ///
  /// #Example#
  /// ````
  /// try stage.disableBacklash()
  /// ````
  func disableBacklash() throws {
    try self.stageGroup.positioner.disableBacklash(for: self)
  }
  
  /// Enables backlash compensation.
  ///
  /// Implements the  `void PositionerBacklashEnable(char PositionerName[250])`  XPS Controller function.
  ///
  /// This function enables the backlash compensation defined in the “stages.ini” file or defined by the “PositionerBacklashSet” function. If the backlash compensation value is null then this function will have not effect, and backlash compensation will remain disabled. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
  ///
  /// In the “stages.ini” file the parameter “Backlash” will enable or disable this feature as follows:
  /// - Backlash = 0 → Disable backlash
  /// - Backlash > 0 → Enable backlash
  ///
  /// #Example#
  /// ````
  /// try stage.enableBacklash()
  /// ````
  ///
  /// - Note: The group state must be NOTINIT to enable the backlash compensation. If it is not the case then ERR\_NOT\_ALLOWED\_ACTION (-22) is returned.
  func enableBacklash() throws {
    try self.stageGroup.positioner.enableBacklash(for: self)
  }
  
  /// The positioner hardware status code.
  ///
  /// Implements the  `void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)`  XPS Controller function.
  ///
  /// This property returns the hardware status of the stage. The positioner hardware status is composed of the “corrector” hardware status and the “servitudes” hardware status. The “Corrector” returns the motor interface and the position encoder hardware status. The “Servitudes” returns the general inhibit and the end of runs hardware. status.
  ///
  /// #Example#
  /// ````
  /// let status = try stage.hardwareStatus
  /// ````
  var hardwareStatus: Int {
    get throws {
      try stageGroup.positioner.hardwareStatus(for: self)
    }
  }
  
  // FIXME: Replace UNIT with units of velocity and acceleration
  /// Gets the maximum velocity (in UNIT) and acceleration (in UNIT) from the profiler generators.
  ///
  /// Implements the  `void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)`  XPS Controller function.
  ///
  /// This function returns the maximum velocity and acceleration of the profile generators. These parameters represent the limits for the profiler and are defined in the stages.ini file.
  ///
  /// #Example#
  /// ````
  /// let (velocity, acceleration) = try stage.maximumVelocityAndAcceleration
  /// ````
  var maximumVelocityAndAcceleration: (velocity: Double, acceleration: Double) {
    get throws {
      try stageGroup.positioner.maximumVelocityAndAcceleration(forStage: self)
    }
  }
  
  /// The stage's motion done parameters.
  ///
  /// Implements the  ````void PositionerMotionDoneGet(char PositionerName[250], double* positionWindow, double* velocityWindow, double* checkingTime, double* meanPeriod, double* timeOut)````  XPS Controller function.
  ///
  /// The “MotionDoneMode” parameter from the stages.ini file defines the motion done mode. The motion done can be defined as “Theoretical” (the motion done mode is not used) or “VelocityAndPositionWindow”. For a more thorough description of the motion done mode, please refer to the XPS Motion Tutorial section Motion/Motion Done.
  ///
  /// #Example#
  /// ````
  /// let (
  ///   positionWindow,
  ///   velocityWindow,
  ///   checkingTime,
  ///   meanPeriod,
  ///   timeout
  /// ) = try stage.motionDoneParameters
  /// ````
  ///
  /// - Note: This function returns the motion done parameters only for the “VelocityAndPositionWindow” MotionDone mode. If the MotionDone mode is defined as “Theoretical” then ERR_WRONG_OBJECT_TYPE (-8) is returned.
  var motionDoneParameters: (
    positionWindow: Double,
    velocityWindow: Double,
    checkingTime: Double,
    meanPeriod: Double,
    timeout: Double
  ) {
    get throws {
      try stageGroup.positioner.motionDoneParameters(for: self)
    }
  }
  
  /// The user travel limits for the stage.
  ///
  /// Implements the  `void PositionerUserTravelLimitsGet(char PositionerName[250], double* UserMinimumTarget, double* UserMaximumTarget)`  XPS Controller function.
  ///
  /// This property returns the user-defined travel limits for the selected positioner.
  ///
  /// #Example#
  /// ````
  /// let (minimum, maximum) = try stage.userTravelLimits
  /// ````
  var userTravelLimits: (userMinimumTarget: Double, userMaximumTarget: Double) {
    get throws {
      try stageGroup.positioner.userTravelLimits(for: self)
    }
  }
  
  // FIXME: Replace UNITS with correct units
  /// The current motion values from the SGamma profiler.
  ///
  ///  Implements the  `void PositionerSGammaParametersGet(char PositionerName[250], double* Velocity, double* Acceleration, double* MinimumTjerkTime, double* MaximumTjerkTime)`  XPS Controller function.
  ///
  /// Gets the current SGamma profiler values that are used in displacements:
  /// - velocity (*UNITS*)
  /// - acceleration (*UNITS*)
  /// - minimumTjerkTime (sec)
  /// - maximumTjerkTime (sec)
  ///
  /// #Example#
  /// ````
  /// let (
  ///   velocity,
  ///   acceleration,
  ///   minimumTjerkTime,
  ///   maximumTjerkTime
  /// ) = try sGammeParameters
  /// ````
  var sGammaParameters: (
    velocity: Double,
    acceleration: Double,
    minimumTjerkTime: Double,
    maximumTjerkTime: Double
  ) {
    get throws {
      try stageGroup.positioner.sGamma.sGammaParameters(for: self)
    }
  }
  
  
  /**
   Sets new motion values for the SGamma profiler
   
   Implements the  ````int PositionerSGammaParametersSet (int SocketID, char FullPositionerName[250] , double Velocity, double Acceleration, double MinimumJerkTime, double MaximumJerkTime)````  XPS Controller function.
   
   This function defines the new SGamma profiler values that will be used in future displacements.
   
   - Authors:
   - Owen Hildreth
   
   - Parameters:
   - positioner: The name of the positioner
   - velocity: motion velocity (units/seconds)
   - acceleration: motion acceleration (units/seconds^2)
   - minimumJerkTime: Minimum jerk time (seconds)
   - maximumJerkTime: Maximum jerk time (seconds)
   
   # Example #
   ````
   let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
   let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
   let stage = Stage(stageGroup: stageGroup, name: "X")
   
   do {
   try stage.setSGammaParameters(forStage: stage, velocity: velocity, acceleration: acceleration, minimumTjerkTime: minimumTjerkTime, maximumTjerkTime: maximumTjerkTime) {
   } catch {
   print(error)
   }
   ````
   */
  
  
  /// Sets new motion values for the SGamma profiler.
  ///
  /// Implements the  `int PositionerSGammaParametersSet (int SocketID, char FullPositionerName[250] , double Velocity, double Acceleration, double MinimumJerkTime, double MaximumJerkTime)`  XPS Controller function.
  ///
  /// This function defines the new SGamma profiler values that will be used in future displacements.
  ///
  /// #Example#
  /// ````
  /// try setSGammaParameters(
  ///   (velocity: 0.0, acceleration: 0.0, minimumTjerkTime: 0.0, maximumTjerkTime: 0.0)
  /// )
  /// ````
  ///
  /// - Parameter parameters: The velocity (*UNITS*), acceleration (*UNITS*), minimum jerk time (sec), and maximum jerk time (sec).
  func setSGammaParameters(
    _ parameters: (velocity: Double,
                   acceleration: Double,
                   minimumTjerkTime: Double,
                   maximumTjerkTime: Double)
  ) throws {
    try stageGroup.positioner.sGamma.setSGammaParameters(
      for: self,
      parameters: (parameters.velocity, parameters.acceleration, parameters.minimumTjerkTime, parameters.maximumTjerkTime)
    )
  }
  
  /**
   Gets the motion and the settling time
   
   Implements the  ````void PositionerSGammaPreviousMotionTimesGet( char PositionerName[250], double* SettingTime, double* SettlingTime)````  XPS Controller function.
   
   This function returns the motion (setting) and settling times from the previous motion. The motion time represents the defined time to complete the previous displacement. The settling time represents the effective settling time for a motion done.
   
   - Authors:
   - Owen Hildreth
   
   - Parameters:
   - positioner: The name of the positioner that will be moved.
   
   - Returns:
   - settingTime (seconds)
   - settlingTime (seconds)
   
   # Example #
   ````
   let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
   let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
   let stage = Stage(stageGroup: stageGroup, name: "X")
   
   do {
   if let parameters =  try stage.getPreviousMotionTimes(forStage: stage) {
   let settingTime = parameters.settingTime
   let settlingTime = parameters.settlingTime
   
   print("settingTime  = \(settingTime)")
   print("settlingTime = \(settlingTime)")
   }
   } catch {
   print(error)
   }
   ````
   */
  
  
  /// The motion and the settling time in seconds.
  ///
  /// Implements the  `void PositionerSGammaPreviousMotionTimesGet( char PositionerName[250], double* SettingTime, double* SettlingTime)`  XPS Controller function.
  ///
  /// This function returns the motion (setting) and settling times from the previous motion. The motion time represents the defined time to complete the previous displacement. The settling time represents the effective settling time for a motion done.
  ///
  /// #Example#
  /// ````
  /// let (setting, settling) = try stage.previousMotionTimes
  /// ````
  var previousMotionTimes: (setting: Double, settling: Double)? {
    get throws {
      try stageGroup.positioner.sGamma.previousMotionTimes(for: self)
    }
  }
}
