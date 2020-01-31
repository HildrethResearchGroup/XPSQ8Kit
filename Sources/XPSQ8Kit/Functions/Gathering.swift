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



// MARK: - Functions
public extension XPSQ8Controller.GatheringController {
	/// Gets a value in the global double array at the given index.
    ///
	/// - returns:  A String containing the current configuration.
	func getConfiguration() throws -> String {
        let message = "GatheringConfigurationGet(char *)"
		try controller.communicator.write(string: message)
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
    func setConfiguration(withConfiguration type: String) throws {
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
            let data = try controller?.gathering.getData(fromIndex: 0)
           } catch {print(error)}
    */
    func getData(fromIndex indexPoint: Int) throws -> String {
        let message = "GatheringDataGet(\(indexPoint), char *)"
        try controller.communicator.write(string: message)
        let data = try controller.communicator.read(as: (String.self))
        return data
    }
    


    /**
    Get a data line from gathering buffer.  Implements the void GatheringDataMultipleLinesGet(int IndexPoint, int NumberOfLines, char DataBufferLine[]) XPS function.
     
     - parameters:
        - indexPoint: The starting index of the data buffer.
        - numberOfLines: The number of lines to collect data
    
     - returns: A string containing the current firmware vision.
    
           do {
            let data = try controller.gathering.getData(fromIndex: 0, forMultipleLines: 10)
           } catch {print(error)}
    */
    func getData(fromIndex indexPoint: Int, forMultipleLines numberOfLines: Int) throws -> String {
        var data = ""
        if numberOfLines == 0 {return data}
        
        for line in 1 ... numberOfLines {
            let index = indexPoint + ((line - 1) * 1024)
            let message = "GatheringDataMultipleLinesGet(\(index), char *)"
            try controller.communicator.write(string: message)
            let nextLine = try controller.communicator.read(as: (String.self))
            data.append(contentsOf: nextLine)
        }
        return data
    }
    
    
    /**
    Empty the gathered data in memory to start new gathering from scratch.
       
     Implements the void GatheringReset() XPS function.
     
            do {
                try controller?.gathering.reset()
            } catch {print(error)}
     */
    func reset() throws {
        let message = "GatheringReset()"
        try controller.communicator.write(string: message)
    }
    
    
    /**
    Re-start the stopped gathering to add new data.
     
     Implements the void GatheringRunAppend() XPS function.
     
        do {
            let data = try controller.gathering.runAppend()
        } catch {print(error)}
     

    */
    func runAppend() throws {
        let message = "GatheringRunAppend()"
        try controller.communicator.write(string: message)
    }
    
    
    /**
    Start a new gathering.
     
     Implements the void GatheringRun(int DataNumber, int Divisor) XPS function.
     
        do {
            let data = try controller.gathering.run(fromDataNumber: 0, withDivisor:  4)
        } catch {print(error)}
     
     - parameters:
        - dataNumber: The number of data to collect? (need to consult XPS documentation).
        - divisor: The divisor separating the data.
    */
    func run(fromDataNumber dataNumber: Int, withDivisor divisor: Int) throws {
        let message = "GatheringRun(\(dataNumber), \(divisor))"
        try controller.communicator.write(string: message)
    }
    
    /**
    Stop acquisition and save data.
     
     Implements the void GatheringStopAndSave() XPS function.
     
        do {
            let data = try controller.gathering.stopAndSave()
        } catch {print(error)}
     

    */
    func stopAndSave() throws {
        let message = "GatheringStopAndSave()"
        try controller.communicator.write(string: message)
    }
    
    
    
    /**
    Stop the data gathering (without saving to file).
     
     Implements the void GatheringStop() XPS function.
     
        do {
            let data = try controller.gathering.stop()
        } catch {print(error)}
    */
    func stop() throws {
        let message = "GatheringStop()"
        try controller.communicator.write(string: message)
    }
    
}

    
    
// MARK: - External Functions
public extension XPSQ8Controller.GatheringController {

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
    func getExternalConfiguration() throws -> String {
        let message = "GatheringExternalConfigurationGet(char *)"
        try controller.communicator.write(string: message)
        let externalConfiguration = try controller.communicator.read(as: (String.self))
        
        return externalConfiguration
    }

    
    // TODO: make a list of accetpable configurations
    /**
    Sets the configuration of the controller using an External Configuration acquisition
       
     Implements  the void GatheringExternalConfigurationSet(char Type[250]) XPS function
     
            do {
                let configurationString = "Some correct configuration string"
                try controller?.gathering.setExternalConfiguration(configurationString)
            } catch {print(error)}
     
     - parameters:
       - type: A string containing a valid configuration command.  See XPS documentation for examples.
     */
    func setExternalConfiguration(withConfiguration type: String) throws {
        let message = "GatheringExternalConfigurationSet(\(type))"
        try controller.communicator.write(string: message)
    }
    
    
    /**
     Returns the current maximum number of samples and current number during acquisition as set by the External configuration.
     
      Implements  the void GatheringExternalCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber)) XPS function
     
            do {
                let tuple = try controller?.gathering.getExternalCurrentNumber()
                let currentNumber = tuple?.currentNumber
                let maximumSamples = tuple?.maximumSamples
                print("currentNumber = \(currentNumber ?? -1)")
                print("maximumSamples = \(maximumSamples ?? -1)")
            } catch {print(error)}
     
     - returns:
       - currentNumber:  The current number of samples that have been gathered.
       - maximumSamples:  The maximum number of samples that can be gathered.
    */
    func getExternalCurrentNumber() throws -> (currentNumber: Int, maximumSamples: Int) {
        let message = "GatheringExternalCurrentNumberGet(int *,int *)"
        
        try controller.communicator.write(string: message)
        let configuration = try controller.communicator.read(as: (Int.self, Int.self))
        
        return (currentNumber: configuration.0, maximumSamples: configuration.1)
    }
    
    
    /**
    Get a data line from an external gathering buffer.  Implements the void GatheringExternalDataGet(int IndexPoint, char DataBufferLine[]) XPS function.
     
     - parameters:
       - indexPoint: The starting index of the data buffer.
    
     - returns: A string containing the current firmware vision.
    
           do {
            let data = try controller?.gathering.getExternalData(fromIndex: 0)
           } catch {print(error)}
    */
    func getExternalData(fromIndex indexPoint: Int) throws -> String {
        let message = "GatheringExternalDataGet(\(indexPoint), char *)"
        try controller.communicator.write(string: message)
        let data = try controller.communicator.read(as: (String.self))
        return data
    }
    
    
    /**
    Stop acquisition and save data
       
     Implements the void GatheringExternalStopAndSave() XPS function
     
            do {
                try controller?.gathering.externalStopAndSave()
            } catch {print(error)}
     */
    func externalStopAndSave() throws {
        let message = "GatheringExternalStopAndSave()"
        try controller.communicator.write(string: message)
    }
}


