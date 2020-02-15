//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation
public extension XPSQ8Controller {
	struct GroupController {
		var controller: XPSQ8Controller
	}
}


// MARK: - Access Group Namespace
public extension XPSQ8Controller {
	/// The set of commands dealing with globals.
	//func group(named name: String) -> GroupController {
	//	return GroupController(controller: self, globalGroupName: name)
	//}

	var group: GroupController {
		return GroupController(controller: self)
	}
}



// MARK: - Group Functions
public extension XPSQ8Controller.GroupController {
	
    /** This function moves the provided stage by the provided target displacement.
     
     do {
         let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
     } catch {print(error)}

    - parameters:
      - stage: The name of the stage that will be moved.  This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
      - byDisplacement: The distance in mm to move the specified stage.
     
     */
    
    func moveRelative(stage stageName: String, byDisplacement targetDisplacement: Double) throws {
        let command = "GroupMoveRelative(\(stageName),\(targetDisplacement))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**  Move the specified stage to the specified position in mm.
       
        do {
            let data = try controller?.group.moveAbsolute(stage: "M.X", toLocation: 10)
        } catch {print(error)}
     
     - parameters:
       - stageName: The name of the stage that will be moved.  This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
       - toLocation: The absolute position in mm to move the specified stage.
    */
    func moveAbsolute(stageName: String, toLocation: Double) throws {
        let command = "GroupMoveAbsolute(\(stageName),\(targetDisplacement))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    
    
}

