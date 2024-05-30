//
//  Gathering.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation
import CoreImage

public extension XPSQ8Controller {
  /// A namespace for gathering commands.
  struct Gathering {
    var controller: XPSQ8Controller
  }
}

// MARK: - Access Gathering Namespace
public extension XPSQ8Controller {
  /// A namespace for gathering commands
  var gathering: Gathering {
    return Gathering(controller: self)
  }
}

// MARK: - Gathering Functions
public extension XPSQ8Controller.Gathering {
  // TODO: Convert the configuration string into a Configuration
  /// The current configuration as a string.
  ///
  /// Implements the `void GatheringConfigurationGet()` XPS function.
  ///
  /// # Example #
  /// ````
  /// let configuration = try await controller.gathering.configuration
  /// ````
  var configuration: String {
    get async throws {
      let message = "GatheringConfigurationGet(char *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: String.self)
    }
  }
  
  /// Sets the configuration.
  ///
  /// Implements the `void GatheringConfigurationSet(char Type[250])` XPS function.
  ///
  /// # Example #
  /// ````
  /// let configuration = Configuration(
  ///   dataTypes: [.currentPosition(xStage), .currentVelocity(xStage)]
  /// )
  /// try await controller.gathering..external.setConfiguration(configuration)
  /// ````
  ///
  /// - Parameter configuration: A configuration of the types of data to collect.
  func setConfiguration(_ configuration: Configuration) async throws {
    let message = "GatheringConfigurationSet(\(configuration.dataTypes.count), \(configuration.rawValue))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// The current sample number during acquisition and maximum sample count as set by the configuration.
  ///
  /// Implements the `void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))` XPS function.
  ///
  /// # Example #
  /// ````
  /// let (currentSampleNumber, maximumSamples) = try await controller.gathering.sampleInformation
  /// ````
  ///
  /// - Returns:
  ///   - `currentSampleNumber`: The current number of samples that have been gathered.
  ///   - `maximumSamples`: The maximum number of samples that can be gathered.
  var sampleInformation: (currentSampleNumber: Int, maximumSampleCount: Int) {
    get async throws {
      let message = "GatheringCurrentNumberGet(int *,int *)"
      try await controller.communicator.write(string: message)
      let configuration = try await controller.communicator.read(as: (Int.self, Int.self))
      return (currentSampleNumber: configuration.0, maximumSampleCount: configuration.1)
    }
  }
  
  /// Acquire one set of the configured data.
  ///
  /// Implements the `void GatheringDataAcquire()` XPS function.
  ///
  /// # Example #
  /// ````
  /// try await controller.gathering.configure(...)
  /// try await controller.gathering.acquireData()
  /// ````
  func acquireData() async throws {
    let message = "GatheringDataAcquire()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Get a data line from the gathering buffer.
  ///
  /// Implements the `void GatheringDataGet(int IndexPoint, char DataBufferLine[])`  XPS function.
  ///
  /// # Example #
  /// ````
  /// let lineData = try await controller.gathering.data(atIndex: 0)
  /// ````
  ///
  /// - Parameter index: The starting index of the data.
  /// - Returns: The string data.
  func data(atIndex index: Int) async throws -> String {
    let message = "GatheringDataGet(\(index), char *)"
    try await controller.communicator.write(string: message)
    let data = try await controller.communicator.read(as: (String.self))
    return data
  }
  
  /// Get multiple data lines from the gathering buffer.
  ///
  /// Implements the `void GatheringDataMultipleLinesGet(int IndexPoint, int NumberOfLines, char DataBufferLine[])` XPS function.
  ///
  /// # Example #
  /// ````
  /// let data = try await controller.gathering.data(atIndex: 0, numberOfLines: 10)
  /// ````
  ///
  /// - Parameters:
  ///   - index: The staring index of the data.
  ///   - numberOfLines: The number of lines to collect.
  /// - Returns: The joined string data.
  func data(atIndex index: Int, numberOfLines: Int) async throws -> String {
    guard numberOfLines > 0 else { throw XPSQ8Communicator.Error.parameterError }
    
    let message = "GatheringDataMultipleLinesGet(\(index), \(numberOfLines), char *)"
    try await controller.communicator.write(string: message)
    return try await controller.communicator.read(as: (String.self))
  }
  
  /// Empties the gathered data in memory in order to start a new gathering from scratch.
  ///
  /// Implements the `void GatheringReset()` XPS function.
  ///
  /// # Example #
  /// ````
  /// try await controller.gathering.reset()
  /// ````
  func reset() async throws {
    let message = "GatheringReset()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Resumes the stopped gathering and appends new data.
  ///
  /// Implements the `void GatheringRunAppend()` XPS function.
  ///
  /// # Example #
  /// ````
  /// // Collect data for 5 seconds
  /// try await controller.gathering.setConfiguration(...)
  /// try await controller.gathering.run(count: 5, divisor: 10)
  /// sleep(5)
  /// // Stop collecting data for 60 seconds
  /// try await controller.gathering.stop()
  /// sleep(60)
  /// // Resume collecting data (without discarding the first 5 seconds of data)
  /// try await controller.gathering.runAppending()
  /// ````
  ///
  /// - Note: The gathering must be configured, executed, and stopped before calling this function.
  func resume() async throws {
    let message = "GatheringRunAppend()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Runs a new gathering.
  ///
  /// Implements the `void GatheringRun(int DataNumber, int Divisor)`  XPS function.
  ///
  /// ## Example #
  /// ````
  /// // Must set the configuration before running
  /// try await controller.gathering.setConfiguration(...)
  /// try await controller.gathering.run(count: 5, divisor: 10)
  /// ````
  ///
  /// - Note: You must set the configuration using ``setConfiguration(_:)`` before calling this.
  ///
  /// - Parameters:
  ///   - count: The number of datapoints to be gathered
  ///   - divisor: The divisor the the frequency (servo frequency) at which the data gathering will be done.
  func run(count: Int, divisor: Int) async throws {
    let message = "GatheringRun(\(count), \(divisor))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Stops internally and externally trigged data gathering and saves the data to disk.
  ///
  /// If `saveToDisk` is set to `true`, the data is saved to the file GATHERING.DAT in the "..\\Public" folder which can be accessed over FTP. If any previous data is here, it will be overwritten. See the XPS manual for more information about this file.
  ///
  /// Implements the `void GatheringStop()` or `void GatheringStopAndSave()` XPS functions depending on if `saveToDisk` is set.
  ///
  /// # Example #
  /// ````
  /// // Stop gathering after 2 seconds and save to disk
  /// try await controller.gathering.setConfiguration(...)
  /// try await controller.gathering.run(count: 10, divisor: 5)
  /// sleep(2)
  /// try await controller.gathering.stop(saveToDisk: true)
  /// ````
  ///
  /// - Parameter saveToDisk: Wether to save the data to disk or not. (`false` by default).
  func stop(saveToDisk: Bool = false) async throws {
    let message = saveToDisk ? "GatheringStopAndSave()" : "GatheringStop()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
}

