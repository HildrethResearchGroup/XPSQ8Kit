//
//  EventExtended.swift
//  
//
//  Created by Connor Barnes on 1/10/20.
//

// MARK: - Types

public extension XPSQ8Controller {
  /// A namespace for extended events.
  struct EventExtended {
    var controller: XPSQ8Controller
  }
}

// MARK: - Access Event Extended Namespace
public extension XPSQ8Controller {
  /// A namespace for dealing with extended events.
  var eventExtended: EventExtended {
    return EventExtended(controller: self)
  }
}

// MARK: - ActionParameters
public extension XPSQ8Controller.EventExtended {
  typealias ActionParameters = (p1: String, p2: String, p3: String, p4: String)
  typealias TriggerParameters = (p1: String, p2: String, p3: String, p4: String)
}


// MARK: - Event Extended Functions
public extension XPSQ8Controller.EventExtended {
  /// All event and action configurations.
  var allConfigurations: String {
    get async throws {
      let message = "EventExtendedAllGet(char *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: String.self)
    }
  }
  
  /// The action configuration.
  var actionConfiguration: String {
    get async throws {
      let message = "EventExtendedConfigurationActionGet(char *)"
      try await controller.communicator.write(string: message)
      return try await controller.communicator.read(as: String.self)
    }
  }
  
  /// Configures one or several actions.
  /// - Parameters:
  ///   - name: The name of the action.
  ///   - parameters: The action parameters (a tuple of four strings).
  func setActionConfiguration(name: String, parameters: ActionParameters) async throws {
    let (p1, p2, p3, p4) = parameters
    let message = "EventExtendedConfigurationActionSet(\(name),\(p1),\(p2),\(p3),\(p4))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Returns the event configuration.
  func getTriggerConfiguration() async throws -> String {
    let message = "EventExtendedConfigurationTriggerGet(char *)"
    try await controller.communicator.write(string: message)
    return try await controller.communicator.read(as: String.self)
  }
  
  /// Configures one or several events.
  /// - Parameters:
  ///   - name: The event name.
  ///   - parameters: The trigger parameters (a tuple of four strings)
  func setTriggerConfiguration(name: String, parameters: TriggerParameters) async throws {
    let (p1, p2, p3, p4) = parameters
    let message = "EventExtendedConfigurationTriggerGet(\(name),\(p1),\(p2),\(p3),\(p4))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Returns the event and action configuration defined by the ID.
  /// - Parameter id: The ID of the event and action configuration.
  func eventConfiguration(withID id: Int) async throws -> (
    eventTriggerConfiguration: String,
    actionConfiguration: String
  ) {
    let message = "EventExtendedGet(\(id), char *, char *)"
    try await controller.communicator.write(string: message)
    return try await controller.communicator.read(as: (String.self, String.self))
  }
  
  /// Removes the event and action configuration defined by the ID.
  /// - Parameter id: The ID of the event and action configuration to remove.
  func removeEvent(withID id: Int) async throws {
    let message = "EventExtendedRemove(\(id))"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Launches the last event and action configuration.
  ///
  /// - Returns: The id of the event and action configuration.
  @discardableResult func start() async throws -> Int {
    let message = "EventExtendedStart(int *)"
    try await controller.communicator.write(string: message)
    return try await controller.communicator.read(as: Int.self)
  }
  
  /// Waits events from the last configuration.
  func wait() async throws {
    let message = "EventExtendedWait()"
    try await controller.communicator.write(string: message)
    try await controller.communicator.validateNoReturn()
  }
}
