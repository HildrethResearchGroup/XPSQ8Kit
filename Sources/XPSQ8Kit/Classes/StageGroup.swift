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
    var stages:[Stage] = []
    
    // TODO: Fix groupName to thrown an error if the String is larger than 250 characters (instrument is limited to 250 character strings)
    /// The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    let stageGroupName: String
    
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
    
    - parameters:
        - stage: The Stage that will be moved.
        - targetDisplacement: The distance in mm to move the specified stage.
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
}

// MARK: - Jog Functions
public extension StageGroup {
    func jogGetCurrent(stage: Stage) throws -> (velocity: Double, acceleration: Double)? {
        // Generate the complete stage name for the stage.
        let completeStageName = stage.completeStageName()
        let currentVelocityAndAcceleration = try controller?.group.jog.getCurrent(stage: completeStageName)
        return currentVelocityAndAcceleration
    }
}

