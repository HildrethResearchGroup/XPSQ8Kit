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
                try controller?.gathering.setConfiguration(configurationString)
            } catch {print(error)}
     
     - parameters:
       - type: A string containing a valid configuration command.  See XPS documentation for examples.
     */
    func setConfiguration(type: String) throws {
        let message = "GatheringConfigurationSet(\(type))"
        try controller.communicator.write(string: message)
    }
    

    /**
     Returns the current maximum number of samples and current number during acquisition as set by the configuration.
     
      Implements  the void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber)) XPS function
     
            do {
                let tuple = try controller?.gathering.getCurrentNumber()
                let currentNumber = tuple?.currentNumber
                let maximumSamples = tuple?.maximumSamples
                print("currentNumber = \(currentNumber ?? -1)")
                print("maximumSamples = \(maximumSamples ?? -1)")
            } catch {print(error)}
     
     - returns:
       - currentNumber:  The current number of samples that have been gathered.
       - maximumSamples:  The maximum number of samples that can be gathered.
    */
    func getCurrentNumber() throws -> (currentNumber: Int, maximumSamples: Int) {
        let message = "GatheringCurrentNumberGet(int *,int *)"
        
        try controller.communicator.write(string: message)
        let configuration = try controller.communicator.read(as: (Int.self, Int.self))
        
        return (currentNumber: configuration.0, maximumSamples: configuration.1)
    }
    
    /**
    Acquire a configured data
       
     Implements the void GatheringDataAcquire() XPS function
     
            do {
                try controller?.gathering.acquireData()
            } catch {print(error)}
     */
    func acquireData() throws {
        let message = "GatheringDataAcquire()"
        try controller.communicator.write(string: message)
    }
    
    
    

    /**
    Get a data line from gathering buffer.  Implements the void GatheringDataGet(int IndexPoint, char DataBufferLine[]) XPS function.
     
     - parameters:
       - indexPoint: The starting index of the data buffer.
    
     - returns: A string containing the current firmware vision.
    
           do {
            let data = try controller?.gathering.getData(indexpoint: 0)
           } catch {print(error)}
    */
    func getData(indexPoint: Int) throws -> String {
        let message = "GatheringDataGet(\(indexPoint), char *)"
        try controller.communicator.write(string: message)
        let data = try controller.communicator.read(as: (String.self))
        return data
    }
    
    func getData() throws -> String {
        return "test"
    }
    
    // void GatheringDataMultipleLinesGet(int IndexPoint, int NumberOfLines, char DataBufferLine[])

    /**
    Get a data line from gathering buffer.  Implements the void GatheringDataMultipleLinesGet(int IndexPoint, int NumberOfLines, char DataBufferLine[]) XPS function.
     
     - parameters:
       - indexPoint: The starting index of the data buffer.
    
     - returns: A string containing the current firmware vision.
    
           do {
            let data = try controller.gathering.getData(indexpoint: 0, numberOfLines: 10)
           } catch {
               print(error)
           }
    */
    func getData(indexPoint: Int, numberOfLines: Int) throws -> String {
        var data = ""
        if numberOfLines == 0 {return data}
        
        for line in 1 ... numberOfLines {
            let index = indexPoint + ((line - 1) * 1024)
            let message = "GatheringDataGet(\(index), char *)"
            try controller.communicator.write(string: message)
            let nextLine = try controller.communicator.read(as: (String.self))
            data.append(contentsOf: nextLine)
        }
        return data
    }
    
    
    
    // MARK: External Functions
    // TODO: make a list of accetpable configurations
    /**
    Sets the configuration of the controller using a differnt mnumonique type.
       
     Implements  the void GatheringExternalConfigurationGet(char Type[])) XPS function
     
            do {
                let externalConfiguration = try controller?.gathering.getExternalConfiguration()
            } catch {print(error)}
     
     - returns:
       - type: A string with the external configuration.
     */
    func getExternalConfiguration(type: String) throws -> String {
        let message = "GatheringExternalConfigurationGet(char *)"
        try controller.communicator.write(string: message)
        let externalConfiguration = try controller.communicator.read(as: (String.self))
        
        return externalConfiguration
    }

    
    
    
}


