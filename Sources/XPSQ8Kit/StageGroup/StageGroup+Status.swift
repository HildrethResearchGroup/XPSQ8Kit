//
//  StageGroup+Status.swift
//
//
//  Created by Connor Barnes on 7/28/21.
//

import Foundation

public extension StageGroup {
  /// The status of the group.
  ///
  /// # Example #
  /// ````
  /// let status = try await group.status
  /// ````
  var status: Status {
    get async throws {
      let command = "GroupStatusGet(\(name), int *)"
      try await controller.communicator.write(string: command)
      let code = try await controller.communicator.read(as: (Int.self))
      if let status = Status(rawValue: code) {
        return status
      } else {
        throw Error.unknownStatus
      }
    }
  }
  
  enum Status: Int, Equatable, Hashable {
    case notInitialized = 0
    case notInitializedDueToEmergencyBreak
    case notInitializedDueToEmergencyStop
    case notInitializedDueToFollowingErrorDuringHoming
    case notInitializedDueToFollowingError
    case notInitializedDueToHomingTimeout
    case notInitializedDueToMotionDoneTimeoutDuringHoming
    case notInitializedDueToKillAll
    case notInitializedDueToEndOfRunAfterHoming
    case notInitializedDueToEncoderCalibrationError
    case readyDueToAbortMove
    case readyFromHoming
    case readyFromMotion
    case readyDueToEnableMotion
    case readyFromSlave
    case readyFromJogging
    case readyFromAnalogTracking
    case readyFromTrajectory
    case readyFromSpinning
    case readyDueToGroupInterlockErrorDuringMotion
    case disabled
    case disabledDueToFollowingErrorOnReady
    case disabledDueToFollowingErrorDuringMotion
    case disabledDueToMotionDoneTimeoutDuringMoving
    case disabledDueToFollowingErrorOnSlave
    case disabledDueToFollowingErrorOnJogging
    case disabledDueToFollowingErrorDuringTrajectory
    case disabledDueToMotionDoneTimeoutDuringTrajectory
    case disabledDueToFollowingErrorDuringAnalogTracking
    case disabledDueToSlaveErrorDuringMotion
    case disabledDueToSlaveErrorOnSlave
    case disabledDueToSlaveErrorOnJogging
    case disabledDueToSlaveErrorDuringTrajectory
    case disabledDueToSlaveErrorDuringAnalogTracking
    case disabledDueToSlaveErrorOnReady
    case disabledDueToFollowingErrorOnSpinning
    case disabledDueToSlaveErrorOnSpinning
    case disabledDueToFollowingErrorOnAutoTuning
    case disabledDueToSlaveErrorOnAutoTuning
    case disabledDueToEmergencyStopOnAutoTuning
    case emergencyBraking
    case motorInitialization
    case notReferenced
    case homing
    case moving
    case trajectory
    case slaveDueToEnableSlave
    case joggingDueToEnableJogging
    case analogTrackingDueToEnableTracking
    case analogInterpolatedCalibrating
    case notInitializedDueToMechanicalZeroInconsistencyDuringHoming
    case spinningDueToSetSpinParameters
    case notInitializedDueToClampingTimeout
    case clamped = 55
    case readyFromClamped
    case disabledDueToFollowingErrorDuringClamped = 58
    case disabledDueToMotionDoneTimeoutDuringClamped
    case notInitializedDueToGroupInterlockErrorOnNotReferenced
    case notInitializedDueToGroupInterlockErrorDuringHoming
    case notInitializedDueToMotorInitializationError = 63
    case referencing
    case clampingInitialization
    case notInitializedDueToPerpendicularityErrorHoming
    case notInitializedDueToMasterSlaveErrorDuringHoming
    case autoTuning
    case scalingCalibration
    case readyFromAutoTuning
    case notInitializedFromScalingCalibration
    case notInitializedDueToScalingCalibrationError
    case excitationSignalGeneration
    case disabledDueToFollowingErrorOnExcitationSignalGeneration
    case disabledDueToMasterSlaveErrorOnExcitationSignalGeneration
    case disabledDueToEmergencyStopOnExcitationSignalGeneration
    case readyFromExcitationSignalGeneration
    case focus
    case readyFromFocus
    case disabledDueToFollowingErrorOnFocus
    case disabledDueToMasterSlaveErrorOnFocus
    case disabledDueToEmergencyStopOnFocus
    case disabledDueToNotInterlockedError
    case disabledDueToGroupInterlockErrorDuringMoving
    case disabledDueToGroupInterlockErrorDuringJogging
    case disabledDueToGroupInterlockErrorOnSlave
    case disabledDueToGroupInterlockErrorDuringTrajectory
    case disabledDueToGroupInterlockErrorDuringAnalogTracking
    case disabledDueToGroupInterlockErrorDuringSpinning
    case disabledDueToGroupInterlockErrorOnReady
    case disabledDueToGroupInterlockErrorOnAutoTuning
    case disabledDueToGroupInterlockErrorOnExcitationSignalGeneration
    case disabledDueToGroupInterlockErrorOnFocus
    case disabledDueToMotionDoneTimeoutDuringJogging
    case disabledDueToMotionDoneTimeoutDuringSpinning
    case disabledDueToMotionDoneTimeoutDuringSlave
  }
}

// MARK: - Helpers
public extension StageGroup {
  func waitForStatus(
    _ statuses: Set<Status>,
    interval: TimeInterval = 0.25,
    timeout: TimeInterval = 10.0
  ) async throws {
    let start = Date()
    while true {
      let now = Date()
      guard now.timeIntervalSince(start) < timeout else { throw Error.timeout }
      
      let status = try await self.status
      if statuses.contains(status) {
        return
      }
      
      await Task.sleep(UInt64(1_000_000_000 * interval))
    }
  }
  
  func waitForStatus(
    _ status: Status,
    interval: TimeInterval = 0.25,
    timeout: TimeInterval = 10.0
  ) async throws {
    try await waitForStatus([status], interval: interval, timeout: timeout)
  }
}
