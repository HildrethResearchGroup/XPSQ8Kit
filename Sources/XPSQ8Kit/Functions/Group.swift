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
        
        public struct JogController {
            var controller: XPSQ8Controller
        }
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

public extension XPSQ8Controller.GroupController {
    ///The set of commands dealing with Jog
    var jog: JogController {
        return JogController(controller: controller)
    }
}



// MARK: - Group Functions
public extension XPSQ8Controller.GroupController {
    /**
     This function moves the provided stage by the provided target displacement in mm.
     
     This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
     
     - Parameters:
       - stage: The name of the stage that will be moved.
       - byDisplacement: The distance in mm to move the specified stage.
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      // use moveRelative function
        do {
         let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
        } catch {print(error)}
       ````
     */
    func moveRelative(stage stageName: String, byDisplacement targetDisplacement: Double) throws {
        let command = "GroupMoveRelative(\(stageName),\(targetDisplacement))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Move the specified stage to the specified position in mm.
     
     This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
     
     - parameters:
       - stageName: The name of the stage that will be moved.
       - toLocation: The absolute position in mm to move the specified stage.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        let data = try controller?.group.moveAbsolute(stage: "M.X", toLocation: 10)
     } catch {print(error)}
     ````
    */
    func moveAbsolute(stage stageName: String, toLocation targetLocation: Double) throws {
        let command = "GroupMoveAbsolute(\(stageName),\(targetLocation))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    

}


// MARK: - Group.Jog Functions
public extension XPSQ8Controller.GroupController.JogController {
    
    // func Group.Jog.getCurrent() -> (velocity: Double, acceleration: Double)    Get Jog current on selected group
    
    func getCurrent(stage stageName: String) throws -> (velocity: Double, acceleration: Double) {
        // implements void GroupJogCurrentGet(char GroupName[250], double* Velocity, double* Acceleration)
        // GroupJogCurrentGet(M.X,double *,double *)
        let message = "GroupJogCurrentGet(\(stageName), double *, double *)"
        
        try controller.communicator.write(string: message)
        
        let currentJog = try controller.communicator.read(as: (Double.self, Double.self))
        
        return (velocity: currentJog.0, acceleration: currentJog.1)
    }
    
}
