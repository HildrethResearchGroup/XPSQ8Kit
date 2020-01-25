//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation
public extension XPSQ8Controller {
	// TODO: Fix groupName to thrown an error if the String is larger than 250 characters (instrument is limited to 250 character strings)
	struct GroupController {
		var controller: XPSQ8Controller
		//var stages: [Stage] = []
		//let globalGroupName: String
		//let stageName: String?
	}
}


// MARK: Access Gathering Namespace
public extension XPSQ8Controller {
	/// The set of commands dealing with globals.
	//func group(named name: String) -> GroupController {
	//	return GroupController(controller: self, globalGroupName: name)
	//}

	var group: GroupController {
		return GroupController(controller: self)
	}
}



// MARK: Functions
public extension XPSQ8Controller.GroupController {
	/*func groupName () -> String {
		if let stageName = stageName {
			return globalGroupName + "." + stageName
		}
		else {
			return globalGroupName
		}
	}
*/
	
    
    internal func moveRelative(stageName: String, targetDisplacment: Double) throws {
        let command = "GroupMoveRelative(\(stageName),\(targetDisplacment))"
        
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
	
    
	internal func moveRelative(stage: Stage, targetDisplacment: Double) throws {
		let command = "GroupMoveRelative(\(stage.completeStageName),\(targetDisplacment))"
		
		try controller.communicator.write(string: command)
		try controller.communicator.validateNoReturn()
	}
}

