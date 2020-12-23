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
    
}

// MARK: - Jog Functions
public extension StageGroup {
    
    
    /**
     Returns a tuple containing the current velocity and acceration of the specified stage.
     
      Implements  the ````void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))```` XPS function at the Stage Group through the Controller getCurrent function.
     
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
}

