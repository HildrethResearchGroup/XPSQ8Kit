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
    
    /// An array of Stages that belong to the StageGroup
    var stages:[Stage] = []
    
    /// The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    let stageGroupName: String
    
    /// Creates an instance with the specified  Stage Group Name.
    ///
    /// - Parameters:
    ///   - stageGroupName: The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
    
    public init(stageGroupName:String) {
        self.stageGroupName = stageGroupName
    }
}
