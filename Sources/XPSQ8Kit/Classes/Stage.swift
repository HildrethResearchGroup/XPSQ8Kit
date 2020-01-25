//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation

class Stage {
	//let controller: XPSQ8Controller.GroupController
    
    let stageGroup: StageGroup
	let stageName: String
	
	public init(stageGroup: StageGroup, stageName: String) {
		self.stageGroup = stageGroup
		self.stageName = stageName
	}
	
    var groupName: String {
        return self.stageGroup.stageGroupName
    }
    
	var groupWithStageName:String {
		get {
			return groupName + "." + stageName
		}
	}
	
}
