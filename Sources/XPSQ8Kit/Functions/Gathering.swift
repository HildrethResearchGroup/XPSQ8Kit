//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation

public extension XPSQ8Controller {
	struct GatheringController {
		var controller: XPSQ8Controller
	}
}


// MARK: Access Gathering Namespace
public extension XPSQ8Controller {
	/// The set of commands dealing with globals.
	var gathering: GatheringController {
		return GatheringController(controller: self)
	}
}



// MARK: Functions

// func Gathering.getConfiguration() -> String
public extension XPSQ8Controller.GatheringController {
	/// Gets a value in the global double array at the given index.
	/// - Parameter index: The index of the array.
	func getConfiguration() throws -> String {
		try controller.communicator.write(string: "GatheringConfigurationGet(char *)")
		return try controller.communicator.read(as: String.self)
	}
    
    // TODO: make a list of accetpable configurations
    /**
    Sets the configuration of the controller
       
     Implements  the void GatheringConfigurationSet(char Type[250]) XPS function
     
            do {
                let configurationString = "Some correct configuration string"
                try controller?.setConfiguration(configurationString)
            } catch {print(error)}
     
     - parameters:
       - type: A string containing a valid configuration command.  See XPS documentation for examples.
     */
    func setConfiguration(type: String) throws {
        let command = "GatheringConfigurationSet(\(type))"
        try controller.communicator.write(string: command)
    }
    
    
}



