//
//  StageGroup.swift
//  
//
//  Created by Owen Hildreth on 1/24/20.
//

import Foundation

/// An External class to manage a Group of Stages for use by the XPS Hardware. Many stages are part of a larger Stage Group (Example: "MacroStages.X", where "MacroStages" is the stage group and "X" is this specific name.
///
/// This actor groups stages together and implements group-specific commends owned by various controllers.
public class StageGroup {
  let controller: XPSQ8Controller
  
  /// The stages that belong to the group.
  public internal(set) var stages:[Stage] = []
  
  /// The name of the group.  This name must match the stage group name defined on the XPS Hardware Controller.
  public let name: String
  
  /**
   Creates an instance of Stage Group with the specified  Stage Group Name.
   
   From the XPS Controller manual, all stages belong to a Stage Group and are addressed by stageGroupName.name.   This is actually set on the hardware itself.  The StageGroup is used to hold the name of the Group (e.g. "MacroStages") and the name holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary characterstring (e.g. MacroStages.X) using the completeStageName function.
   
   This initilizer creates a Stage Group with the specificed StageGroupName.  Stages that belong to this controller are stored in the stages array.
   
   - Parameters:
   - controller: The XPSQ8Controller that is handling communication to the XPS Controller.
   - stageGroupName: The name of the Stage Group.  This name must match the Stage Group Name defined on the XPS Hardware Controller.
   
   # Example #
   ````
   // Setup Controller, StageGroup, and Stage
   let controller = try XPSQ8Controller(address: "192.168.0.254", port: 5001)
   let stageGroup = try StageGroup(controller: controller, stageGroupName: "M")
   ````
   */
  init(controller: XPSQ8Controller, stageGroupName: String) throws {
    guard stageGroupName.count <= 250 else {
      throw  XPSQ8Communicator.Error.stringTooLong
    }
    
    self.controller = controller
    self.name = stageGroupName
  }
}

// MARK: - Public Factory
public extension XPSQ8Controller {
  /// Creates an instance of Stage Group with the specified name.
  ///
  /// From the XPS Controller manual, all stages belong to a Stage Group and are addressed by stageGroupName.name.   This is actually set on the hardware itself.  The StageGroup is used to hold the name of the Group (e.g. "MacroStages") and the name holds the name of the specific stage (e.g. "X" for a stage that moves in the "x" direction).  Setting these values will make sure function calls can pass the stage and the stage will provide the necessary characterstring (e.g. MacroStages.X) using the completeStageName function.
  ///
  /// # Example #
  /// ````
  /// let group = try controller.makeStageGroup(named: "M")
  /// ````
  ///
  /// - Parameter name: The name of the stage group.
  /// - Returns: The stage group.
  func makeStageGroup(named name: String) throws -> StageGroup {
    try .init(controller: self, stageGroupName: name)
  }
}

// MARK: - Helpers
public extension StageGroup {
  func waitForStatus(
    withCodes codes: Set<Int>,
    interval: TimeInterval = 0.25,
    timeout: TimeInterval = 10.0
  ) async throws {
    let start = Date()
    while true {
      let now = Date()
      guard now.timeIntervalSince(start) < timeout else { throw Error.timeout }
      
      if let statusCode = try? await statusCode {
        if codes.contains(statusCode) {
          return
        }
      }
      
      await Task.sleep(UInt64(1_000_000_000 * interval))
    }
  }
  
  func waitForStatus(
    withCode code: Int,
    interval: TimeInterval = 0.25,
    timeout: TimeInterval = 10.0
  ) async throws {
    try await waitForStatus(withCodes: [code], interval: interval, timeout: timeout)
  }
  
  enum Error: Swift.Error {
    case timeout
  }
}
