//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation

/**
 An External class to manage stages.
 This class is used to implement stage-specific commands owned by varioius controllers.
*/
public class Stage {
    /// Many stages are part of a larger Stage Group (Example: "MacroStages.X", where "MacroStages" is the stage group and "X" is this specific stageName.
    public let stageGroup: StageGroup
    
    /// The name of this stage.  Example: "X" might be a stage that moves in the "X" direction.
	public let stageName: String
	
    
    /**
    Creates a Stage instance.
     
     Stage instance links it to the provided StageGroup, and sets the name of the stage "stageName".  Additionally, it adds the instance to the StageGroup's stages array.
    
    - Parameters:
        - stageGroup:  The StageGroup that the Stage instance belongs to.  This is actually set on the hardware itself.  The StageGroup is used to hold the name of the Group (e.g. "MacroStages") and the stageName holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary characterstring (e.g. MacroStages.X) using the completeStageName function
         - stageName:  The name of the stage as set on the hardware itself.
     
     # Example #
     ````
      // Setup Controller, StageGroup, and Stage
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
      let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
      let stage = Stage(stageGroup: stageGroup, stageName: "X")
     ````
    */
    public init(stageGroup: StageGroup, stageName: String) {
		self.stageGroup = stageGroup
		self.stageName = stageName
        
        stageGroup.stages.append(self)
	}
    
    
	// MARK: - Names
    /**
     Returns the name of the StageGroup that the Stage instance is assigned to.
     - Returns: A string containing the name of the StageGroup
    
     # Example #
     ````
      // Setup Controller, StageGroup, and Stage
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
      let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
      let stageGroupName = stageGroup.groupName()
     ````
     
    */
    private func groupName() -> String {
        return self.stageGroup.stageGroupName
    }
    
    /**
     Returns a String containing the complete stage name for the stage.
    
     The complete stage name is a combination of the name of the StageGroup and the name of the Stage.  For example: "MacroStages.X" where "MacroStages" is the name of the group, "X" is the name of the stage, and "." is the deliniator.  These variables are set on the XPS hardware through the Administrator account.
    
    - Returns: A string containing the complete name of the Stage with the group.
    
     # Example #
     ````
      // Setup Controller, StageGroup, and Stage
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
      let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
      let stage = Stage(stageGroup: stageGroup, stageName: "X")
      let completeStageName = stage.completeStageName()
     ````
    */
	public func completeStageName() -> String {
        return groupName() + "." + stageName
	}
	
}



// MARK: - Move Functions
public extension Stage {
    
    /**
     Moves the stage using the moveRelative command by the target displacement in mm.
        
    - Parameters:
        - targetDisplacement: The distance in millimeters that the stage should be moved by using the moveRelative command
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        try stage.moveRelative(targetDisplacement: -5)
     } catch {print(error)}
     ````
    */
    func moveRelative(targetDisplacement: Double) throws {
        try self.stageGroup.moveRelative(stage: self, targetDisplacement: targetDisplacement)
    }
    
    
    /**
     Moves the stage using the moveAbsolution commadn to the target location.
     
     - Parameters:
        - toLocation: The location in mm to move the stage to.
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
        
     // Tell stage to move
     do {
        try stage.moveAbsolute(toLocation: -5)
    } catch {print(error)}
     ````
     */
    func moveAbsolute(toLocation: Double) throws {
        try self.stageGroup.moveAbsolute(stage: self, toLocation: toLocation)
    }
    
    /**
     Returns the motion status for the  stage
     
      Returns the motion status for one or all positioners of the selected group.
      The motion status possible values are :
      0 : Not moving state (group status in NOT_INIT, NOT_REF or READY).
      1 : Busy state (positioner in moving, homing, referencing, spinning, analog tracking, trajectory, encoder calibrating, slave mode).
     
     - Author: Owen Hildreth
    
     - returns:
        -  status: Positioner or Group status

     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        let stageStatus = try stage.getMotionStatus()
     } catch {print(error)}
     ````
    */
    func getMotionStatus() throws -> Int? {
        
        let status = try self.stageGroup.getMotionStatus(self)
        
        return status
    }
    
    /**
     Aborts the motion or the jog in progress for a group or a positioner.
     
      This function aborts a motion or a jog in progress. The group state must be “MOVING” or “JOGGING” else the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
     
      For a group:
      1) If the group status is “MOVING”, this function stops all motion in progress.
      2) If the group status is “JOGGING”, this function stops all “jog” motions in progress and disables the jog mode. After this “group move abort” action, the group status becomes “READY”.
     
      For a positioner:
      1) If the group status is “MOVING”, this function stops the motion of the selected positioner.
      2) If the group status is “JOGGING”, this function stops the “jog” motion of the selected positioner.
      3) If the positioner is idle, an ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
      After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, else the group stays in the same state.
     
     - Author: Owen Hildreth

     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        // Abort move for a specific stage
        try stage.abortMove()
     } catch {print(error)}
     ````
    */
    func abortMove() throws {
        try self.stageGroup.abortMove(self)
    }
    
    
    
    /**
     Returns the current velocity for one or all positioners of the selected group.
     
     - Author: Owen Hildreth
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        // Abort move for a specific stage
        let velocity =  try stage.getCurrentVelocity()
     } catch {print(error)}
     ````
    */
    func getCurrentVelocity() throws -> Double? {
        let velocity = try self.stageGroup.getCurrentVelocity(forStage: self)
        
        return velocity
    }
    
}

// MARK: - Jog Functions
public extension Stage {
    
    /**
     Returns a tuple containing the current velocity and acceration of the specified stage.
     
      Implements  the ````int GroupJogCurrentGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)```` XPS function at the Stage Group through the Controller getCurrent function.
     
     - returns:
        - velocity:  The current velocity in mm/s of the specified stage.
        - acceleration:   The current acceration in mm/s^2 of the specified stage.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let current = try stage.jogGetCurrent() {
             let velocity = current.velocity
             let acceleration = current.acceleration
             print("Velocity = \(velocity)")
             print("Acceleartion = \(acceleration)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func jogGetCurrent() throws -> (velocity: Double, acceleration: Double)? {
        
        let currentVelocityAndAcceleration = try self.stageGroup.jogGetCurrent(forStage: self)
        return currentVelocityAndAcceleration
    }
    
    
    /**
     Returns a tuple containing the  current jog velocity and acceration settings of this stage.
     
     Implements  the ````int GroupJogParametersGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)````  XPS function.
     
      This function returns the velocity and the acceleration set by the user to use the jog mode for one positioner or for all positioners of the selected group.
      So, this function must be called when the group is in “JOGGING” mode else the velocity and the acceleration will be null.
      To change the velocity and the acceleration on the fly, in the jog mode, call the “GroupJogParametersSet” function.
     
      - Authors: Owen Hildreth
     
     - returns:
        - velocity:  The current velocity in mm/s of the specified stage.
        - acceleration:   The current acceration in mm/s^2 of the specified stage.
     
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let currentParameters = try stage.getJogParameters() {
             let velocity = currentParameters.velocity
             let acceleration = currentParameters.acceleration
             print("Velocity Setting = \(velocity)")
             print("Acceleartion Setting = \(acceleration)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func getJogParameters() throws -> (velocity: Double, acceleration: Double)? {
        let currentVelocityAndAcceleration = try self.stageGroup.getJogParameters(forStage: self)
        return currentVelocityAndAcceleration
    }
}


// MARK: - Group.Position Functions
public extension Stage {
    /**
      Returns the setpoint position for one or all positioners of the selected group.
      
       Returns the setpoint position for one or all positioners of the selected group.
       The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
     
     - Authors: Owen Hildreth
      
      - returns:
         - setPoint: position setpoint of the specified stage
     
      
      # Example #
      ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let currentPostition = try stage.getCurrentPosition() {
     } catch {
         print(error)
     }
     
     print("Current Position = \(currentPostition)")
      ````
     */
    func getCurrentPosition() throws -> Double? {
        let position = try self.stageGroup.getCurrentPosition(forStage: self)
        return position
    }
    
    
    /**
      Returns the setpoint position of the selected stage.
      
     Implements the ````void GroupPositionSetpointGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group through the Controller getCurrent function.  The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
          
     - Authors: Owen Hildreth
      
      - returns:
         - setPoint: position setpoint of the specified stage
     
      - parameters:
         - stage: The name of the stage to find the positon setpoint of
      
      # Example #
      ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let currentSetPoint = try stage.getSetpoint() {
     } catch {
         print(error)
     }
     
     print("Current Setpoint = \(currentSetPoint)")
      ````
     */
    func getSetpoint() throws -> Double? {
        let setPoint = try self.stageGroup.getSetpoint(forStage: self)
        return setPoint
    }
    
    
    /**
     Returns the target position for one or all positioners of the selected group.
     
     Implements the ````void GroupPositionTargetGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group.
     
     Returns the target position for one or all positioners of the selected group. The target position represents the “end” position after the move.
     
     For instance, during a move from 0 to 10 units, the position values are: GroupPositionTargetGet => 10.0000
     GroupPositionCurrentGet => 5.0005 GroupPositionSetpointGet => 5.0055
     
     - Authors: Steven DiGregorio
     
     - Returns:
        - target: position target of the specified stage
     
     - Parameters:
        - stage: The name of the stage to find the positon target of
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let currenTarget = try stage.getTarget() {
     } catch {
         print(error)
     }
     
     print("Current Target = \(currenTarget)")
     ````
     */
    func getTarget() throws -> Double? {
        let currentTarget = try self.stageGroup.getTarget(forStage: self)
        return currentTarget
    }
}

// MARK: - Positioner Functions
public extension Stage {
    
    /**
     Auto-scaling process for determining the stage scaling acceleration.
     
     Implements the  ````void PositionerAccelerationAutoScaling( char PositionerName[250],  double* Scaling)````  XPS Controller function.
     
     The function executes an auto-scaling process and returns the calculated scaling acceleration. The selected group must be in “NOTINIT” state, else ERR_NOT_ALLOWED_ACTION (-22) is returned. More information in the programmer manual
     
     Takes a long time to return a value
     
     - Authors:
        - Owen Hildreth
     
     - Returns:
        -  scaling: Astrom & Hägglund based auto-scaling
     
     - Parameters:
        - stage: The stage to get value(s) from
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let currenAccelerationAutoScaling = try stage.accelerationAutoScaling() {
     } catch {
         print(error)
     }
     
     print("Current Acceleration Auto Scalling = \(currenAccelerationAutoScaling)")
     ````
     */
    func accelerationAutoScaling() throws -> Double? {
        let currentAccelerationAutoScaling = try self.stageGroup.positioner.accelerationAutoScaling(forStage: self)
        
        return currentAccelerationAutoScaling
    }
    
    /**
     Disables the backlash compensation
     
     Implements the  ````void PositionerBacklashDisable(char PositionerName[250])````  XPS Controller function.
     
      This function disables the backlash compensation. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
     
      In the “stages.ini” file the parameter “Backlash” will enable or disable this feature as follows:
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Authors:
        - Owen Hildreth
    
     - Parameters:
        - stage: The stage to get value(s) from

    # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stage.backlashDisable() {
     } catch {
         print(error)
     }
      ````
    */
    func backlashDisable() throws {
        try self.stageGroup.positioner.backlashDisable(forStage: self)
    }
    
    
    /**
     Enables the backlash compensation
     
     Implements the  ````void PositionerBacklashEnable(char PositionerName[250])````  XPS Controller function.
     
     This function enables the backlash compensation defined in the “stages.ini” file or defined by the “PositionerBacklashSet” function. If the backlash compensation value is null then this function will have not effect, and backlash compensation will remain disabled. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
     
      The group state must be NOTINIT to enable the backlash compensation. If it is not the case then ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
      In the “stages.ini” file the parameter “Backlash” allows the user to enable or disable the backlash compensation.
     
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Authors:
        - Owen Hildreth
    
     - Parameters:
        - stage: he stage to get value(s) from
    
    # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stage.backlashEnable() {
     } catch {
         print(error)
     }
      ````
    */
    func backlashEnable() throws {
        try self.stageGroup.positioner.backlashEnable(forStage: self)
    }
    
    /**
     Gets the positioner hardware status code.
     
     Implements the  ````void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)````  XPS Controller function.
     
     
     This function returns the hardware status of the selected positioner. The positioner hardware status is composed of the “corrector” hardware status and the “servitudes” hardware status:
     
     The “Corrector” returns the motor interface and the position encoder hardware status.
     
     The “Servitudes” returns the general inhibit and the end of runs hardware status.
     
     - Authors:
        - Owen Hildreth
      
       - returns:
          -  status: positioner hardware status code

       - parameters:
         - positionerName: The name of the positioner
       
       # Example #
       ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let hardwareStatus = try stage.getHardwareStatus()
     print("hardwareStatus = \(hardwareStatus)"){
     } catch {
         print(error)
     }
       ````
      */
    func getHardwareStatus() throws -> Int? {
        let hardwareStatus = try self.stageGroup.positioner.getHardwareStatus(forStage: self)
        
        return hardwareStatus
    }
    
    
    /**
     Gets the maximum velocity and acceleration from the profiler generators.
     
     Implements the  ````void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)````  XPS Controller function.
     
     This function returns the maximum velocity and acceleration of the profile generators. These parameters represent the limits for the profiler and are defined in the stages.ini file:
     
     MaximumVelocity = ; unit/second
     
     MaximumAcceleration = ; unit/second2
     
     - Authors:
        - Owen Hildreth
     
      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         - velocity: Maximum velocity in units/sec (units most likely  mm/sec)
         - acceleration: Maximum acceleration in units/sec^2 (units most likely  mm/sec^2)
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
        if let current = try stage.getMaximumVelocityAndAcceleration() {
            let velocity = current.velocity
            let acceleration = current.acceleration
            print("Velocity = \(velocity)")
            print("Acceleartion = \(acceleration)")
        } else { print("current = nil") }
    } catch { print(error) }
     ````
     */
    func getMaximumVelocityAndAcceleration() throws -> (velocity: Double, acceleration: Double)? {
        
        let currentVelocityAndAcceleration = try self.stageGroup.positioner.getMaximumVelocityAndAcceleration(forStage: self)
        
        return currentVelocityAndAcceleration
        
    }
    
    
    /**
     Gets the motion done parameters
     
     Implements the  ````void PositionerMotionDoneGet(char PositionerName[250], double* positionWindow, double* velocityWindow, double* checkingTime, double* meanPeriod, double* timeOut)````  XPS Controller function.
     
     This function returns the motion done parameters only for the “VelocityAndPositionWindow” MotionDone mode. If the MotionDone mode is defined as “Theoretical” then ERR_WRONG_OBJECT_TYPE (-8) is returned.
     
     The “MotionDoneMode” parameter from the stages.ini file defines the motion done mode. The motion done can be defined as “Theoretical” (the motion done mode is not used) or “VelocityAndPositionWindow”. For a more thorough description of the motion done mode, please refer to the XPS Motion Tutorial section Motion/Motion Done.
     
     - Authors:
        - Owen Hildreth

      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         -  positionWindow:
         - velocityWindow:
         - checkingTime:
         - meanPeriod:
         - timeout:
     
     # Example #
      ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let parameters = try stage.getMaximumVelocityAndAcceleration(forStage: stage) {
            let positionWindow = parameters. positionWindow
            let velocityWindow = parameters.velocityWindow
            let checkingTime = parameters.checkingTime
            let meanPeriod = parameters.meanPeriod
            let timeout = parameters.timeout
     
            print("positionWindow   = \(positionWindow)")
            print("velocityWindow   = \(velocityWindow)")
            print("checkingTime     = \(checkingTime)")
            print("meanPeriod       = \(meanPeriod)")
            print("timeout          = \(timeout)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
       ````
     */
    func getMotionDone() throws -> (positionWindow: Double, velocityWindow: Double, checkingTime: Double, meanPeriod: Double, timeout: Double)? {
        
        let parameters = try self.stageGroup.positioner.getMotionDone(forStage: self)
        
        return parameters
    }
    
    
    /**
    Gets the user travel limits
     
     Implements the  ````void PositionerUserTravelLimitsGet(char PositionerName[250], double* UserMinimumTarget, double* UserMaximumTarget)````  XPS Controller function.
     
     This function returns the user-defined travel limits for the selected positioner.
     
     - Authors:
        - Owen Hildreth

      - Parameters:
         - positioner: The name of the positioner
     
      - Returns:
         - userMinimumTarget in units (likely mm )
         - userMaximumTarget in units (likely mm )
     
     # Example #
      ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let parameters = try stage.getMaximumVelocityAndAcceleration() {
            let userMinimumTarget = parameters. userMinimumTarget
            let userMaximumTarget = parameters.userMaximumTarget
            let checkingTime = parameters.checkingTime
            let meanPeriod = parameters.meanPeriod
            let timeout = parameters.timeout
     
            print("userMinimumTarget   = \(userMinimumTarget)")
            print("userMaximumTarget   = \(userMaximumTarget)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
       ````
     */
    func getUserTravelLimits() throws -> (userMinimumTarget: Double, userMaximumTarget: Double)? {
        let parameters = try self.stageGroup.positioner.getUserTravelLimits(forStage: self)
        
        return parameters
    }
    
    
    /**
     Gets the current motion values from the SGamma profiler
     
     Implements the  ````void PositionerSGammaParametersGet(char PositionerName[250], double* Velocity, double* Acceleration, double* MinimumTjerkTime, double* MaximumTjerkTime)````  XPS Controller function.
     
     This function gets the current SGamma profiler values that are used in displacements.
     
     - Authors:
        - Owen HIldreth

      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         - velocity (units/sec)
         - acceleration (units/sec^2)
         - minumumTjerkTime (sec)
         - maximumTjerkTime (sec)
     
     # Example #
      ````
      // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let parameters = try stage.getSGammaParameters(forStage: stage) {
            let velocity = parameters.velocity
            let acceleration = parameters.acceleration
            let minumumTjerkTime = parameters.minumumTjerkTime
            let maximumTjerkTime = parameters.maximumTjerkTime
     
            print("velocity   = \(velocity)")
            print("acceleration   = \(acceleration)")
        printminumumTjerkTime
            print("maximumTjerkTime   = \(maximumTjerkTime)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
       ````
     */
    func getSGammaParameters() throws -> (velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double)? {
        let parameters = try self.stageGroup.positioner.sGamma.getSGammaParameters(forStage: self)
        
        return parameters
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
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stage.setSGammaParameters(forStage: stage, velocity: velocity, acceleration: acceleration, minimumTjerkTime: minimumTjerkTime, maximumTjerkTime: maximumTjerkTime) {
     } catch {
         print(error)
     }
       ````
     */
    func setSGammaParameters(velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double) throws {
        try self.stageGroup.positioner.sGamma.setSGammaParameters(forStage: self, velocity: velocity, acceleration: acceleration, minimumTjerkTime: minimumTjerkTime, maximumTjerkTime: maximumTjerkTime)
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
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
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
    func getPreviousMotionTimes(forStage stage: Stage) throws -> (setting: Double, settling: Double)? {
        let parameters = try self.stageGroup.positioner.sGamma.getPreviousMotionTimes(forStage: self)
        
        return parameters
    }
    
    
} // END:  SGamma functions
