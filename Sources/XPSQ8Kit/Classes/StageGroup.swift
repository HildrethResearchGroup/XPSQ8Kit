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

class StageGroup {
    
    let controller: XPSQ8Controller?
    /// An array of Stages that belong to the StageGroup
    var stages:[Stage] = []
    
    /// The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    let stageGroupName: String
    
    /// Creates an instance with the specified  Stage Group Name.
    ///
    /// - Parameters:
    ///   - controller: The XPSQ8Controller that is handling communication to the XPS Controller.
    ///   - stageGroupName: The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    
    public init(controller: XPSQ8Controller, stageGroupName:String) {
        self.controller = controller
        self.stageGroupName = stageGroupName
    }
    
    // MARK: Functions
    
    
    /// This function moves the provided stage by the provided target displacement.
    ///
    /// - Parameters:
    ///   - stage: The Stage that will be moved.
    ///   - targetDisplacement: The distance in mm to move the specified stage.
    ///
    
    func moveRelative(stage: Stage, targetDisplacment: Double) throws {
        // Generate the stageName
        let completeStageName = stage.completeStageName()
        
        do {
            try self.controller?.group.moveRelative(stageName: completeStageName, targetDisplacment: targetDisplacment)
        } catch {
            print(error)
        }
    }
}
