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
    
    
}

// MARK: - Jog Functions
public extension Stage {
    
    /**
     Returns a tuple containing the current velocity and acceration of the specified stage.
     
      Implements  the ````void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))```` XPS function at the Stage Group through the Controller getCurrent function.
     
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
}
