//
//  ExternalGathering.swift
//  
//
//  Created by Connor Barnes on 7/4/21.
//

public extension XPSQ8Controller.Gathering {
  /// A namespace for external gathering commands.
  struct External {
    var controller: XPSQ8Controller
  }
}

// MARK: - Access External Gathering Namespace
public extension XPSQ8Controller.Gathering {
  /// A namespace for external gathering commands.
  var external: External {
    return External(controller: controller)
  }
}

// MARK: - External Gathering Functions
public extension XPSQ8Controller.Gathering.External {
  // TODO: Convert the configuration string into a Configuration
  /// The current configuration as a string.
  ///
  /// Implements the `void GatheringExternalConfigurationGet(char Type[]))` XPS function.
  ///
  /// # Example #
  /// ````
  /// let configuration = try controller.gathering.external.configuration
  /// ````
  var configuration: String {
    get async throws {
      let message = "GatheringExternalConfigurationGet(char *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: (String.self))
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
  /// try controller.gathering..external.setConfiguration(configuration)
  /// ````
  ///
  /// - Parameter configuration: A configuration of the types of data to collect.
  func setConfiguration(_ configuration: XPSQ8Controller.Gathering.Configuration) async throws {
    let message = "GatheringExternalConfigurationSet(\(configuration.rawValue))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// The current sample number during acquisition and maximum sample count as set by the configuration.
  ///
  /// Implements the `void GatheringExternalCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))` XPS function.
  ///
  /// # Example #
  /// ````
  /// let (currentSampleNumber, maximumSamples) = try controller.gathering.external.sampleInformation
  /// ````
  ///
  /// - Returns:
  ///   - `currentSampleNumber`: The current number of samples that have been gathered.
  ///   - `maximumSamples`: The maximum number of samples that can be gathered.
  var sampleInformation: (currentSampleNumber: Int, maximumSampleCount: Int) {
    get async throws {
      let message = "GatheringExternalCurrentNumberGet(int *,int *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: (Int.self, Int.self))
    }
  }
  
  /// Get a data line from the gathering buffer.
  ///
  /// Implements the `void GatheringDataGet(int IndexPoint, char DataBufferLine[])`  XPS function.
  ///
  /// # Example #
  /// ````
  /// let lineData = try controller.gathering.external.data(atIndex: 0)
  /// ````
  ///
  /// - Parameter index: The starting index of the data.
  /// - Returns: The string data.
  func data(atIndex index: Int) async throws -> String {
    let message = "GatheringExternalDataGet(\(index), char *)"
    try await controller.communicator.write(string: message)
    return try await controller.communicator.read(as: (String.self))
  }
  
  /// Stops internally and externally trigged data gathering and saves the data to disk.
  ///
  /// The data is saved to the file GatheringExternal.dat in the "..\\Public" folder which can be accessed over FTP. If any previous data is here, it will be overwritten. See the XPS manual for more information about this file.
  ///
  /// Implements the `void GatheringExternalStopAndSave()` XPS function.
  ///
  /// # Example #
  /// ````
  /// try controller.gathering.external.stop(saveToDisk: true)
  /// ````
  ///
  /// - Parameter saveToDisk: Wether to save the data to disk or not. (`false` by default).
  func stop() async throws {
    let message = "GatheringExternalStopAndSave()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
}
