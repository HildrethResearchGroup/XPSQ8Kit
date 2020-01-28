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
    ///
	/// - returns:  A String containing the current configuration.
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
        let message = "GatheringConfigurationSet(\(type))"
        try controller.communicator.write(string: message)
    }
    

    /** Returns the current maximum number of samples and current number during acquisition as set by the configuration.
     
    Implements  the void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber)) XPS function
    
            do {
                let tuple = try controller?.getCurrentNumber()
                let currentNumber = tuple.currentNumber
                let maximumSamples = tupple.maximumSamples
            } catch {print(error)}
     
    */
    func getCurrentNumber() throws -> (currentNumber: Int, maximumSamples: Int) {
        let message = "GatheringCurrentNumberGet(int *,int *)"
        
        try controller.communicator.write(string: message)
        let configuration = try controller.communicator.read(as: (Int.self, Int.self))
        
        return (currentNumber: configuration.0, maximumSamples: configuration.1)
    }
    
    
}



