//
//  StageGroup.Positioner.swift
//  
//
//  Created by Connor Barnes on 7/3/21.
//

extension StageGroup {
  /// The stage group's positioner.
  public struct Positioner {
    /// The positioner's controller.
    let controller: XPSQ8Controller
    
    /// Creates a positioner from a given controller.
    /// - Parameter controller: The controller.
    init(controller: XPSQ8Controller) {
      self.controller = controller
    }
    
    /// The stage group positioner's SGamme.
    public struct SGamma {
      /// The SGamma's controller.
      let controller: XPSQ8Controller
      
      /// Creates an SGamma from a given controller.
      /// - Parameter controller: The controller.
      init(controller: XPSQ8Controller) {
        self.controller = controller
      }
    }
  }
}

// MARK: Access Positioner Namespace
public extension StageGroup {
  /// The stage groups's positioner.
  var positioner: Positioner {
    Positioner(controller: self.controller)
  }
}

// MARK: - Access SGamma NameSpace
public extension StageGroup.Positioner {
  var sGamma: SGamma {
    SGamma(controller: self.controller)
  }
}

// MARK: Positioner Functions
public extension StageGroup.Positioner {
  /// The Astrom & Hägglund based auto-scaling process for determining the stage scaling acceleration.
  ///
  /// Implements the  `void PositionerAccelerationAutoScaling( char PositionerName[250],  double* Scaling)`  XPS Controller function.
  ///
  /// The function executes an auto-scaling process and returns the calculated scaling acceleration. The selected group must be in “NOTINIT” state, else ERR\_NOT\_ALLOWED\_ACTION (-22) is returned. More information in the programmer manual.
  ///
  /// #Example#
  /// ````
  /// let accelerationAutoScaling = try group.accelerationAutoScaling(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to get the auto-scaling value from.
  /// - Returns: The Astrom & Hägglund based auto-scaling value.
  func accelerationAutoScaling(for stage: Stage) throws -> Double {
    try controller.positioner.accelerationAutoScaling(positioner: stage.fullyQualifiedName)
  }
  
  /// Disables backlash compensation for the stage.
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
  /// try group.positioner.disableBacklash(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to disable backlash compensation for.
  func disableBacklash(for stage: Stage) throws {
    try controller.positioner.backlashDisable(positioner: stage.fullyQualifiedName)
  }
  
  /// Enables backlash compensation for the given stage.
  ///
  /// Implements the  `void PositionerBacklashEnable(char PositionerName[250])`  XPS Controller function.
  ///
  /// This function enables the backlash compensation defined in the “stages.ini” file or defined by the “PositionerBacklashSet” function. If the backlash compensation value is null then this function will have not effect, and backlash compensation will remain disabled. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
  ///
  /// The group state must be NOTINIT to enable the backlash compensation. If it is not the case then ERR_NOT_ALLOWED_ACTION (-22) is returned.
  ///
  /// In the “stages.ini” file the parameter “Backlash” allows the user to enable or disable the backlash compensation:
  /// - Backlash = 0 → Disable backlash
  /// - Backlash > 0 → Enable backlash
  ///
  /// #Example#
  /// ````
  /// try group.positioner.enableBacklash(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to enable backlash for.
  func enableBacklash(for stage: Stage) throws {
    let completeStageName = stage.fullyQualifiedName
    try controller.positioner.backlashEnable(positioner: completeStageName)
  }
  
  /// Gets the stage's hardware status code.
  ///
  /// Implements the  ````void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)````  XPS Controller function.
  ///
  /// This function returns the hardware status of the selected positioner. The positioner hardware status is composed of the “corrector” hardware status and the “servitudes” hardware status:
  /// - The “Corrector” returns the motor interface and the position encoder hardware status.
  /// - The “Servitudes” returns the general inhibit and the end of runs hardware status.
  ///
  /// - Parameter stage: The stage to get the status code from.
  /// - Returns: The status code for the given stage.
  func hardwareStatus(for stage: Stage) throws -> Int {
    try controller.positioner.getHardwareStatus(positioner: stage.fullyQualifiedName)
  }
  
  // TODO: Replace UNITS with the correct units.
  /// Gets the maximum velocity (in *UNITS*) and acceleration (in *UNITS*) from the profiler generators.
  ///
  /// Implements the  `void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)`  XPS Controller function.
  ///
  /// This function returns the maximum velocity and acceleration of the profile generators. These parameters represent the limits for the profiler and are defined in the stages.ini file.
  ///
  /// #Example#
  /// ````
  /// let (velocity, acceleration) = try maximumVelocityAndAcceleration(for: xStage)
  /// ````
  func maximumVelocityAndAcceleration(
    forStage stage: Stage
  ) throws -> (velocity: Double, acceleration: Double) {
    try controller.positioner.getMaximumVelocityAndAcceleration(
      positioner: stage.fullyQualifiedName
    )
  }
  
  /// Returns the motion done parameters.
  ///
  ///  Implements the  `void PositionerMotionDoneGet(char PositionerName[250], double* positionWindow, double* velocityWindow, double* checkingTime, double* meanPeriod, double* timeOut)`  XPS Controller function.
  ///
  /// This function returns the motion done parameters only for the “VelocityAndPositionWindow” MotionDone mode. If the MotionDone mode is defined as “Theoretical” then ERR_WRONG_OBJECT_TYPE (-8) is returned.
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
  /// ) = try motionDoneParameters(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to get the motion done parameters from.
  /// - Returns: The motion done parameters for the given stage.
  func motionDoneParameters(for stage: Stage) throws -> (positionWindow: Double,
                                                         velocityWindow: Double,
                                                         checkingTime: Double,
                                                         meanPeriod: Double,
                                                         timeout: Double) {
    try controller.positioner.getMotionDone(positioner: stage.fullyQualifiedName)
  }
  
  /// Gets the user travel limits for the given stage.
  ///
  /// Implements the  `void PositionerUserTravelLimitsGet(char PositionerName[250], double* UserMinimumTarget, double* UserMaximumTarget)`  XPS Controller function.
  ///
  /// This function returns the user-defined travel limits for the selected positioner.
  ///
  /// #Example#
  /// ````
  /// let (minimum, maximum) = try group.positioner.userTravelLimits(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to get the travel limits for.
  /// - Returns: The minimum and maximum user targets.
  func userTravelLimits(for stage: Stage) throws -> (userMinimumTarget: Double, userMaximumTarget: Double) {
    
    let completeStageName = stage.fullyQualifiedName
    
    let limits = try controller.positioner.getUserTravelLimits(positioner: completeStageName)
    
    return limits
  }
}

// MARK: SGamma Functions
public extension StageGroup.Positioner.SGamma {
  /// Returns the current motion values from the SGamma profiler.
  ///
  /// Implements the  `void PositionerSGammaParametersGet(char PositionerName[250], double* Velocity, double* Acceleration, double* MinimumTjerkTime, double* MaximumTjerkTime)`  XPS Controller function.
  ///
  /// This function gets the current SGamma profiler values that are used in displacements.
  ///
  /// #Example#
  /// ````
  /// let (
  ///   velocity,
  ///   acceleration,
  ///   minimumJerkTime,
  ///   maximumJerkTime
  /// ) = try sGammaParameters(for: xStage)
  /// ````
  /// - Parameter stage: The stage to get the sGamma values from.
  /// - Returns: The SGamma values.
  func sGammaParameters(for stage: Stage) throws -> (velocity: Double,
                                                     acceleration: Double,
                                                     minimumTjerkTime: Double,
                                                     maximumTjerkTime: Double) {
    try controller.positioner.SGamma.getParameters(positioner: stage.fullyQualifiedName)
  }
  
  /// Sets new motion values for the SGamma profiler.
  ///
  /// Implements the  `int PositionerSGammaParametersSet (int SocketID, char FullPositionerName[250] , double Velocity, double Acceleration, double MinimumJerkTime, double MaximumJerkTime)`  XPS Controller function.
  ///
  /// This function defines the new SGamma profiler values that will be used in future displacements.
  ///
  /// - Parameters:
  ///   - stage: The stage to set the parameters for.
  ///   - parameters: The velocity (in *UNITS*), acceleration (in *UNITS*), minimumTjerkTime (sec), maximumTjerkTime (sec).
  ///
  /// #Example#
  /// ````
  /// let parameters = (velocity: 0.0, acceleration: 0.0, minimumTjerkTime: 0.0, maximumTjerkTime: 0.0)
  /// try group.positioner.sGamma.setSGammaParameters(for: xStage, parameters: parameters)
  /// ````
  func setSGammaParameters(for stage: Stage, parameters: (velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double)) throws {
    let completeStageName = stage.fullyQualifiedName
    
    try controller.positioner.SGamma.setParameters(positioner: completeStageName,
                                                   velocity: parameters.velocity,
                                                   acceleration: parameters.acceleration,
                                                   minimumTjerkTime: parameters.minimumTjerkTime,
                                                   maximumTjerkTime: parameters.maximumTjerkTime)
  }
  
  /// Gets the motion and the settling time for the given stage.
  ///
  /// Implements the  `void PositionerSGammaPreviousMotionTimesGet( char PositionerName[250], double* SettingTime, double* SettlingTime)`  XPS Controller function.
  ///
  /// This function returns the motion (setting) and settling times from the previous motion. The motion time represents the defined time to complete the previous displacement. The settling time represents the effective settling time for a motion done.
  ///
  /// #Example#
  /// ````
  /// let (settingTime, settlingTime) = try group.positioner.sGamma.previousMotionTimes(for: xStage)
  /// ````
  ///
  /// - Parameter stage: The stage to get motion times for.
  /// - Returns: Th setting time and settling time in seconds.
  func previousMotionTimes(for stage: Stage) throws -> (setting: Double, settling: Double) {
    
    let completeStageName = stage.fullyQualifiedName
    
    let parameters = try controller.positioner.SGamma.getPreviousMotionTimes(positioner: completeStageName)
    
    return parameters
  }
}

