//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation

/// An External class to manage stages.
///
/// This class is used to implement stage-specific commands owned by varioius controllers.

public class Stage {
    /// Many stages are part of a larger Stage Group (Example: "MacroStages.X", where "MacroStages" is the stage group and "X" is this specific stageName.
    let stageGroup: StageGroup
    
    /// The name of this stage.  Example: "X" might be a stage that moves in the "X" direction.
	let stageName: String
	
    
    /// Creates a Stage instance, links it to the provided StageGroup, and sets the name of the stage "stageName".  Additionally, it adds the instance to the StageGroup's stages array.
    ///
    /// - Parameters:
    ///     - stageGroup:  The StageGroup that the Stage instance belongs to.  This is actually set on the hardware itself.  The StageGroup is used to hold the name of the Group (e.g. "MacroStages") and the stageName holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary characterstring (e.g. MacroStages.X) using the completeStageName function
    ///     - stageName:  The name of the stage as set on the hardware itself.
    init(stageGroup: StageGroup, stageName: String) {
		self.stageGroup = stageGroup
		self.stageName = stageName
        
        stageGroup.stages.append(self)
	}
    
    
	// MARK: Names
    /// Returns the name of the StageGroup that the Stage instance is assigned to.
    /// - Returns: A string containing the name of the StageGroup
    private func groupName: String {
        return self.stageGroup.stageGroupName
    }
    
    
    /// Returns the complete stage name for the stage.  The complete stage name is a combination of the name of the StageGroup and the name of the Stage.  For example: "MacroStages.X" where "MacroStages" is the name of the group, "X" is the name of the stage, and "." is the deliniator.  These variables are set on the XPS hardware through the Administrator account.
    /// - Returns: A string containing the complete name of the Stage with the group.
	func completeStageName:String {
        return groupName + "." + stageName
	}
	
}
