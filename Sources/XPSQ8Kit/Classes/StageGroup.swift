//
//  File.swift
//  
//
//  Created by Owen Hildreth on 1/24/20.
//

import Foundation

/// An External class to manage a Group of Stages for use by the XPS Hardware.   Many stages are part of a larger Stage Group (Example: "MacroStages.X", where "MacroStages" is the stage group and "X" is this specific stageName.
///
/// This class groups stages together and implements group-specific commends owned by various controllers

public class StageGroup {
    
    let controller: XPSQ8Controller?
    /// An array of Stages that belong to the StageGroup
    public var stages:[Stage] = []
    
    // TODO: Fix groupName to thrown an error if the String is larger than 250 characters (instrument is limited to 250 character strings)
    /// The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    public let stageGroupName: String
    
    public struct Positioner {
        var controller: XPSQ8Controller?
    }
    
    
    /**
     Creates an instance of Stage Group with the specified  Stage Group Name.
     
     From the XPS Controller manual, all stages belong to a Stage Group and are addressed by stageGroupName.stageName.   This is actually set on the hardware itself.  The StageGroup is used to hold the name of the Group (e.g. "MacroStages") and the stageName holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary characterstring (e.g. MacroStages.X) using the completeStageName function.
     
     This initilizer creates a Stage Group with the specificed StageGroupName.  Stages that belong to this controller are stored in the stages array.
    
     - Parameters:
       - controller: The XPSQ8Controller that is handling communication to the XPS Controller.
       - stageGroupName: The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    
     # Example #
    ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
    ````
     */
    public init(controller: XPSQ8Controller?, stageGroupName:String) {
        self.controller = controller
        self.stageGroupName = stageGroupName
    }
}



// MARK: - Move Functions
public extension StageGroup {
    
    /**
     Move the specified stage by the target displacement in mm.
     
      - Author: Owen Hildreth
     
     - Parameters:
         - stage: The Stage that will be moved.
         - targetDisplacement: The distance in mm to move the specified stage.
     
    
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        try group.moveRelative(stage, targetDisplacement: -5)
     } catch {print(error)}
      ````
    */
    func moveRelative(stage: Stage, targetDisplacement: Double) throws {
        // Generate the stageName
        let completeStageName = stage.completeStageName()
        
        try self.controller?.group.moveRelative(stage: completeStageName, byDisplacement: targetDisplacement)
    }
    
    
     /**
     Move the specified stage to the target location in mm.
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
        
     // Tell stage to move
     do {
        try group.moveRelative(stage, targetDisplacement: -5)
     } catch {print(error)}
     ````
     */
     func moveAbsolute(stage: Stage, toLocation targetLocation: Double) throws {
         // Generate the complete stage name for the stage.
         let completeStageName = stage.completeStageName()
         
         try self.controller?.group.moveAbsolute(stage: completeStageName, toLocation: targetLocation)
     }
    
    
    
    /**
     Start home seach sequence on specified stage
     
      This function initiates a home search for each positioner of the selected group.
      The group must be initialized and the group must be in “NOT REFERENCED” state else this function returns the ERR_NOT_ALLOWED_ACTION (-22) error. If no error then the group status becomes “HOMING”.
      The home search can fail due to:
      1) a following error: ERR_FOLLOWING_ERROR (-25)
      2) a ZM detection error: ERR_GROUP_HOME_SEARCH_ZM_ERROR (-49)
      3) a motion done time out when a dynamic error of the positioner is detected during one of the moves during the home search process: ERR_GROUP_MOTION_DONE_TIMEOUT (-33)
      4) a home search timeout when the complete (and complex) home search procedure was not executed in the allowed time: ERR_HOME_SEARCH_TIMEOUT (-28)
     
      For all these errors, the group returns to the “NOTINIT” state.
      After the home search sequence, each positioner error is checked. If an error is detected, the hardware status register is reset (motor on) and the positioner error is cleared before checking it again. If a positioner error is always present, ERR_TRAVEL_LIMITS (-35) is returned and the group becomes “NOTINIT”.
      Once the home search is successful, the group is in “READY” state.
     
     - Author: Owen Hildreth
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.homeSearch()
         print("Home Search completed")
     } catch {
         print(error)
     }
     ````
    */
    func homeSearch() throws {
        try self.controller?.group.homeSearch(group: stageGroupName)
    }
    
    
    /**
     Kills the selected group to go to “NOTINIT” status.
     
      Kills the selected group to stop its action. The group returns to the “NOTINIT” state. If the group is already in this state then it stays in the “NOT INIT” state.
      The GroupKill is a high priority command that is executed in any condition.
     
     - Author: Owen Hildreth
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.kill()
         print("Home Search completed")
     } catch {
         print(error)
     }
     ````
    */
    func kill() throws {
        try self.controller?.group.kill(group: stageGroupName)
    }
    
    
    /**
     Set motion disable on selected group
     
      Turns OFF the motors, stops the corrector servo loop and disables the position compare mode if active. The group status becomes “DISABLE”.
      If the group is not in the “READY” state then an ERR_NOT_ALLOWED_ACTION (- 22) is returned.
     
     - Author: Owen Hildreth
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.disableMotion()
         print("Motion Disabled.")
     } catch {
         print(error)
     }
     ````
    */
    func disableMotion() throws {
        try self.controller?.group.disableMotion(group: stageGroupName)
    }
    
    
    /**
     Set motion disable on selected group
     
      Enables a group in a DISABLE state to turn the motors on and to restart corrector loops.
     
     Turns ON the motors and restarts the corrector servo loops. The group state becomes “READY”.
     If the group is not in the “DISABLE” state then the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
     
     - Author: Owen Hildreth
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.enableMotion()
         print("Motion Enabled.")
     } catch {
         print(error)
     }
     ````
    */
    func enableMotion() throws {
        try self.controller?.group.enableMotion(group: stageGroupName)
    }
    
    
    /**
     Returns the motion status for the selected stage
     
      Returns the motion status for one or all positioners of the selected group.
      The motion status possible values are :
      0 : Not moving state (group status in NOT_INIT, NOT_REF or READY).
      1 : Busy state (positioner in moving, homing, referencing, spinning, analog tracking, trajectory, encoder calibrating, slave mode).
     
     - Author: Owen Hildreth
    
     - returns:
        -  status: Positioner or Group status

     - parameters:
       - stage: Optional Stage to get status from.  If stage isn't passed in, then the return status is for the group
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        let stageStatus = try group.getMotionStatus(stage)
        let groupStatus = try group.getMotionStatus()
     } catch {print(error)}
     ````
    */
    func getMotionStatus(_ stage: Stage? = nil) throws -> Int? {
        
        var name = stageGroupName
        
        if let unwrappedStage = stage {
            name = unwrappedStage.completeStageName()
        }
        
        let status = try controller?.group.getMotionStatus(stageOrGroupName: name)
        
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

     - parameters:
       - stage: Optional value of the Stage to abort moves on.  If left empty, this is set to nil and the abort move is applied to the entire group.
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
     // Tell stage to move
     do {
        // Abort move for a specific stage
        try group.abortMove(stage)
        // Above move for the entire group
        try group.abortMove()
     } catch {print(error)}
     ````
    */
    func abortMove(_ stage: Stage? = nil) throws {
        var name = stageGroupName
        
        if let unwrappedStage = stage {
            name = unwrappedStage.completeStageName()
        }
        
        try controller?.group.abortMove(name)
    }
    
    
    /**
      Returns the group status code
     
      Returns the group status code. The group status codes are listed in the “Group status list” § 0.
      The description of the group status code can be retrieved from the “GroupStatusStringGet” function.
     
     - Author: Owen Hildreth
      
     - returns:
          -  status: group status code

       
       # Example #
        ````
        // Setup Controller, StageGroup, and Stage
        let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
        let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
        let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
        // Tell stage to move
        do {
            let groupStatus = try group.getStatus()
        } catch {print(error)}
        ````
      */
    func getStatus() throws -> Int? {
        let status = try controller?.group.getStatus(group: self.stageGroupName)
        return status
    }
    

    /**
     Get the group state description from a group state code.
   
     This function returns the group state description corresponding to a group state code (see § 0 Group state list).
     If the group state code is not referenced then the “Error: undefined status” message will be returned.
     
     - Author: Owen Hildreth
      
     - returns:
          -  status: group status code

       
       # Example #
        ````
        // Setup Controller, StageGroup, and Stage
        let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
        let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
        let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
        // Tell stage to move
        do {
            let groupStatus = try group.getStatusString(code: code)
        } catch {print(error)}
        ````
    */
    func getStatusString(code: Int) throws -> String? {
        let statusString = try controller?.group.getStatusString(code: code)
        
        return statusString
    }
    
    
    /**
      Returns the current velocity for one or all positioners of the selected group.
          
     - Author: Steven DiGregorio
      
       - returns:
          -  velocity: velocity of selected stage

       - parameters:
         - stage: The Stage to get information from

       # Example #
       ````
       // Setup Controller, StageGroup, and Stage
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
       let stage = Stage(stageGroup: stageGroup, stageName: "X")
    
       // Tell stage to move
       do {
           let groupStatus = try group.getStatusString(code: code)
       } catch {print(error)}
       ````
    */
    func getCurrentVelocity(forStage stage: Stage) throws -> Double? {
        // Generate the complete stage name for the stage.
        let completeStageName = stage.completeStageName()
        
        let currentVelocity = try controller?.group.getCurrentVelocity(forStage: completeStageName)
        
        return currentVelocity
    }
    
    
} // END: Move Functions Extensions




// MARK: - Jog Functions
public extension StageGroup {
    /**
     Returns a tuple containing the current velocity and acceration of the specified stage.
     
      Implements  the ````void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))```` XPS function at the Stage Group through the Controller getCurrent function.
     
      - Authors: Owen Hildreth
     
     - returns:
        - velocity:  The current velocity in mm/s of the specified stage.
        - acceleration:   The current acceration in mm/s^2 of the specified stage.
     
     - parameters:
        - forStage: The stage that will be moved.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let current = try group.jogGetCurrent(forStage: stage) {
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
    func jogGetCurrent(forStage stage: Stage) throws -> (velocity: Double, acceleration: Double)? {
        // Generate the complete stage name for the stage.
        let completeStageName = stage.completeStageName()
        let currentVelocityAndAcceleration = try controller?.group.jog.getCurrent(stage: completeStageName)
        return currentVelocityAndAcceleration
    }
    
    
    /**
     Disable Jog mode on selected group.
     
     Implements  the ````int GroupJogModeDisable (int SocketID, char *GroupName)````  XPS function.
     
      Disables the Jog mode. To use this function, the group must be in the “JOGGING” state and all positioners must be idle (meaning velocity must be 0).
      This function exits the “JOGGING” state and to returns to the “READY” state. If the group state is not in the “JOGGING” state or if the profiler velocity is not null then the error ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
     - Author: Owen Hildreth

     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.disableJog()
     } catch {
         print(error)
     }
     ````
    */
    func disableJog() throws {
        try controller?.group.jog.disable(group: self.stageGroupName)
    }
    
    
    /**
     Enable Jog mode on selected group.
     
     Implements  the ````int GroupJogModeEnable (int SocketID, char *GroupName)````  XPS function.
     
      Enables the Jog mode. To use this function, the group must be in the “READY” state and all positioners must be idle (meaning velocity must be 0).
      This function goes to the “JOGGING” state. If the group state is not “READY”, ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
     - Author: Owen Hildreth

     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         try stageGroup.enableJog()
     } catch {
         print(error)
     }
     ````
    */
    func enableJog() throws {
        try controller?.group.jog.enable(group: self.stageGroupName)
    }
    
    
    /**
     Returns a tuple containing the  current jog velocity and acceration settings of the specified stage.
     
     Implements  the ````int GroupJogParametersGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)````  XPS function.
     
      This function returns the velocity and the acceleration set by the user to use the jog mode for one positioner or for all positioners of the selected group.
      So, this function must be called when the group is in “JOGGING” mode else the velocity and the acceleration will be null.
      To change the velocity and the acceleration on the fly, in the jog mode, call the “GroupJogParametersSet” function.
     
    - Authors: Owen Hildreth
     
     - returns:
        - velocity:  The current velocity in mm/s of the specified stage.
        - acceleration:   The current acceration in mm/s^2 of the specified stage.
     
     - parameters:
        - forStage: The stage that will be moved.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         if let currentParameters = try group.getJogParameters(forStage: stage) {
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
    func getJogParameters(forStage stage: Stage) throws -> (velocity: Double, acceleration: Double)? {
        // Generate the complete stage name for the stage.
        let completeStageName = stage.completeStageName()
        let currentVelocityAndAcceleration = try controller?.group.jog.getParameters(stage: completeStageName)
        return currentVelocityAndAcceleration
    }
}



// MARK: - Group.Position Functions
public extension StageGroup {
    /**
      Returns the setpoint position for one or all positioners of the selected group.
      
       Returns the setpoint position for one or all positioners of the selected group.
       The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
     
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
         let currentPostition = try group.getCurrentPosition(forStage: stage) {
     } catch {
         print(error)
     }
     
     print("Current Position = \(currentPostition)")
      ````
     */
    func getCurrentPosition(forStage stage: Stage) throws -> Double? {
        let completeStageName = stage.completeStageName()
        let currentPosition = try controller?.group.position.getCurrent(stage: completeStageName)
        
        return currentPosition
    }

    
    /**
      Returns the setpoint position of the selected stage.
      
     Implements the ````void GroupPositionSetpointGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group through the Controller getCurrent function.  The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
          
     - Authors: Owen Hildreth
      
      - Returns:
         - setPoint: position setpoint of the specified stage
     
      - Parameters:
         - stage: The name of the stage to find the positon setpoint of
      
      # Example #
      ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
     let stage = Stage(stageGroup: stageGroup, stageName: "X")
     
     do {
         let currentSetPoint = try group.getSetpoint(forStage: stage) {
     } catch {
         print(error)
     }
     
     print("Current Setpoint = \(currentSetPoint)")
      ````
     */
    func getSetpoint(forStage stage: Stage) throws -> Double? {
        let completeStageName = stage.completeStageName()
        let currentSetPoint = try controller?.group.position.getSetpoint(stage: completeStageName)
        
        return currentSetPoint
    }

    
    /**
     Returns the target position for one or all positioners of the selected group.
     
     Implements the ````void GroupPositionTargetGet(char groupName[250], double *CurrentEncoderPosition)````  XPS function at the Stage Group.
     
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
         let currenTarget = try group.getTarget(forStage: stage) {
     } catch {
         print(error)
     }
     
     print("Current Target = \(currenTarget)")
     ````
     */
    func getTarget(forStage stage: Stage) throws -> Double? {
        let completeStageName = stage.completeStageName()
        let currentTarget = try controller?.group.position.getTarget(stage: completeStageName)
        
        return currentTarget
    
    }
}



// MARK: - Access Positioner Namespace
public extension StageGroup {
    var positioner: Positioner {
        return Positioner(controller: self.controller)
    }
}


// MARK: - Positioner Functions
public extension StageGroup.Positioner {
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
         let currenAccelerationAutoScaling = try group.positioner.accelerationAutoScaling(forStage: stage) {
     } catch {
         print(error)
     }
     
     print("Current Acceleration Auto Scalling = \(currenAccelerationAutoScaling)")
     ````
     */
    func accelerationAutoScaling(forStage stage: Stage) throws -> Double? {
        let completeStageName = stage.completeStageName()
        
        let currentAccelerationAutoScaling = try self.controller?.positioner.accelerationAutoScaling(positioner: completeStageName)
        
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
         try group.positioner.backlashDisable(forStage: stage) {
     } catch {
         print(error)
     }
      ````
    */
    func backlashDisable(forStage stage: Stage) throws {
        let completeStageName = stage.completeStageName()
        try self.controller?.positioner.backlashDisable(positioner: completeStageName)
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
         try group.positioner.backlashEnable(forStage: stage) {
     } catch {
         print(error)
     }
      ````
    */
    func backlashEnable(forStage stage: Stage) throws {
        let completeStageName = stage.completeStageName()
        try self.controller?.positioner.backlashEnable(positioner: completeStageName)
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
         let hardwareStatus = try group.positioner.getHardwareStatus(forStage: stage)
     print("hardwareStatus = \(hardwareStatus)"){
     } catch {
         print(error)
     }
       ````
      */
    func getHardwareStatus(forStage stage: Stage) throws -> Int? {
        let completeStageName = stage.completeStageName()
        
        let hardwareStatus = try self.controller?.positioner.getHardwareStatus(positioner: completeStageName)
        
        return hardwareStatus
    }
}
