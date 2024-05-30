//
//  GatheringConfiguration.swift
//  
//
//  Created by Connor Barnes on 7/4/21.
//

// MARK: - Configuration
public extension XPSQ8Controller.Gathering {
  /// A gathering configuration.
  struct Configuration {
    /// The data types to collect while gathering.
    public internal(set) var dataTypes: [DataType]
    
    /// Creates a configuration with the given data types to collect.
    /// - Parameter dataTypes: The data types to collect (at most 25)
    public init(dataTypes: [DataType]) throws {
      // Maximum of 25 types can be gathered
      guard dataTypes.count <= 25 else {
        throw XPSQ8Communicator.Error.parameterError
      }
      
      self.dataTypes = dataTypes
    }
    
    /// A data type to collect.
    public enum DataType {
      case currentPosition (Stage)
      case setpointPosition (Stage)
      case followingError (Stage)
      case currentVelocity (Stage)
      case setpointVelocity (Stage)
      case currentAcceleration (Stage)
      case setpointAcceleration (Stage)
      case correctorOutput (Stage)
      case gpio1_di
      case gpio1_do
      case gpio2_di
      case gpio3_di
      case gpio3_do
      case gpio4_di
      case gpio4_do
      case gpio2_adc1
      case gpio2_adc2
      case gpio2_adc3
      case gpio2_adc4
      case gpio2_dac1
      case gpio2_dac2
      case gpio2_dac3
      case gpio2_dac4
      case fDeltaZ
      case fDiff
      case fDiffNrf
      case fAnDiff
      case fDigDiff
      case xPos
      case xAcc
      case yPos
      case yAcc
      case isrCorrectorTimePeriod
      case isrCorrectorTimeUsage
      case isrProfilerTimeUsage
      case isrServitudesTimeUsage
      case cpuTotalLoadRatio
    }
  }
}

// MARK: - Raw Value
extension XPSQ8Controller.Gathering.Configuration.DataType {
  /// The raw string value for the data type.
  var rawValue: String {
    let components: [String] = {
      switch self {
      case .currentPosition(let stage):
        return [stage.fullyQualifiedName, "CurrentPosition"]
      case .setpointPosition(let stage):
        return [stage.fullyQualifiedName, "SetpointPosition"]
      case .followingError(let stage):
        return [stage.fullyQualifiedName, "FollowingError"]
      case .currentVelocity(let stage):
        return [stage.fullyQualifiedName, "FollowingError"]
      case .setpointVelocity(let stage):
        return [stage.fullyQualifiedName, "SetpointVelocity"]
      case .currentAcceleration(let stage):
        return [stage.fullyQualifiedName, "CurrentAcceleration"]
      case .setpointAcceleration(let stage):
        return [stage.fullyQualifiedName, "SetpointAcceleration"]
      case .correctorOutput(let stage):
        return [stage.fullyQualifiedName, "CorrectorOutput"]
      case .gpio1_di:
        return ["GPIO1.DI"]
      case .gpio1_do:
        return ["GPIO1.DO"]
      case .gpio2_di:
        return ["GPIO2.DI"]
      case .gpio3_di:
        return ["GPIO3.DI"]
      case .gpio3_do:
        return ["GPIO3.DO"]
      case .gpio4_di:
        return ["GPIO4.DI"]
      case .gpio4_do:
        return ["GPIO4.DO"]
      case .gpio2_adc1:
        return ["GPIO2.ADC1"]
      case .gpio2_adc2:
        return ["GPIO2.ADC2"]
      case .gpio2_adc3:
        return ["GPIO2.ADC3"]
      case .gpio2_adc4:
        return ["GPIO2.ADC4"]
      case .gpio2_dac1:
        return ["GPIO2.DAC1"]
      case .gpio2_dac2:
        return ["GPIO2.DAC2"]
      case .gpio2_dac3:
        return ["GPIO2.DAC3"]
      case .gpio2_dac4:
        return ["GPIO2.DAC4"]
      case .fDeltaZ:
        return ["F_Delta_Z"]
      case .fDiff:
        return ["F_Diff"]
      case .fDiffNrf:
        return ["F_Diff_Nrf"]
      case .fAnDiff:
        return ["F_An_Diff"]
      case .fDigDiff:
        return ["F_Dig_Diff"]
      case .xPos:
        return ["XPos"]
      case .xAcc:
        return ["XAcc"]
      case .yPos:
        return ["YPos"]
      case .yAcc:
        return ["YAcc"]
      case .isrCorrectorTimePeriod:
        return ["ISRCorrectorTimePeriod"]
      case .isrCorrectorTimeUsage:
        return ["ISRCorrectorTimeUsage"]
      case .isrProfilerTimeUsage:
        return ["ISRProfilerTimeUsage"]
      case .isrServitudesTimeUsage:
        return ["ISRServitudesTimeUsage"]
      case .cpuTotalLoadRatio:
        return ["CPUTotalLoadRatio"]
      }
    }()
    
    return components.joined(separator: ".")
  }
}

extension XPSQ8Controller.Gathering.Configuration {
  /// The raw string value for the configuration.
  var rawValue: String {
    dataTypes
      .map { $0.rawValue }
      .joined(separator: " ")
  }
}
