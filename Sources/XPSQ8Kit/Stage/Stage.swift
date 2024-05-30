//
//  Stage.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

/// A container class to manage stages.
/// This class is used to implement stage-specific commands owned by various controllers.
public class Stage {
  /// Many stages are part of a larger ``StageGroup``
  ///
  /// Example: "MacroStages.X", where "MacroStages" is the stage group and "X" is this specific stage name.
  public let stageGroup: StageGroup
  
  /// The name of this stage.  Example: "X" might be a stage that moves in the "X" direction.
  public let name: String
  
  /// Creates a stage in the specified ``StageGroup``.
  ///
  /// Stage instance links it to the provided ``StageGroup``, and sets the name of the stage's ``stageName``.  Additionally, it adds the instance to the ``stageGroup.stages``.
  ///
  /// # Example #
  /// ````
  /// // Setup Controller, StageGroup, and Stage
  /// let stageGroup = try StageGroup(controller: controller, stageGroupName: "M")
  /// let stage = try Stage(in: stageGroup, stageName: "X")
  /// ````
  ///
  /// - Parameters:
  ///  - stageGroup: The ``StageGroup`` that the stage instance belongs to.  This is actually set on the hardware itself.  The ``StageGroup`` is used to hold the name of the group (e.g. "MacroStages") and the ``name`` holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary string (e.g. MacroStages.X) using ``completeStageName``
  ///  - stageName: The name of the stage as set on the hardware itself.
  init(in stageGroup: StageGroup, named name: String) throws {
    // The full resource name must be at most 250 chars
    guard stageGroup.name.count + name.count + 1 <= 250 else {
      throw XPSQ8Communicator.Error.stringTooLong
    }
    
    self.stageGroup = stageGroup
    self.name = name
    
    stageGroup.stages.append(self)
  }
}

// MARK: - Public Factory
public extension StageGroup {
  /// Creates a stage in the specified ``StageGroup``.
  ///
  /// # Example #
  /// ````
  /// let xStage = try group.makeStage(named: "X")
  /// ````
  /// 
  /// - Parameter name: The name of the stage.
  /// - Returns: The newly created stage.
  func makeStage(named name: String) throws -> Stage {
    try .init(in: self, named: name)
  }
}

// MARK: - Helpers
extension Stage {
  var controller: XPSQ8Controller {
    stageGroup.controller
  }
}

// MARK: - Types
public extension Stage {
  typealias MotionDoneParameters = (
    positionWindow: Double,
    velocityWindow: Double,
    checkingTime: Double,
    meanPeriod: Double,
    timeout: Double
  )
  
  typealias Jog = (
    velocity: Double,
    acceleration: Double
  )
  
  typealias UserTravelLimits = (
    userMinimumTarget: Double,
    userMaximumTarget: Double
  )
  
  typealias SGammaParameters = (
    velocity: Double,
    acceleration: Double,
    minimumTjerkTime: Double,
    maximumTjerkTime: Double
  )
  
  typealias MotionTimes = (
    setting: Double,
    settling: Double
  )
}
