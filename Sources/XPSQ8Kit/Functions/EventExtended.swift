//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/10/20.
//

// MARK: Types

public extension XPSQ8Controller {
  struct EventExtendedController {
    var controller: XPSQ8Controller
  }
}

// MARK: - Access Event Extended Namespace
public extension XPSQ8Controller {
  /// The set of commands dealing with extended events.
  var eventExtended: EventExtendedController {
    return EventExtendedController(controller: self)
  }
}


// MARK: - Event Extended Functions
public extension XPSQ8Controller.EventExtendedController {
  /// Returns all event and action configurations.
  func getAllConfigurations() throws -> String {
    let message = "EventExtendedAllGet(char *)"
    
    try controller.communicator.write(string: message)
    let configurations = try controller.communicator.read(as: String.self)
    
    return configurations
  }
  
  /// Returns the action configuration.
  func getActionConfiguration() throws -> String {
    let message = "EventExtendedConfigurationActionGet(char *)"
    
    try controller.communicator.write(string: message)
    let configuration = try controller.communicator.read(as: String.self)
    
    return configuration
  }
  
  /// Configures one or several actions.
  /// - Parameters:
  ///   - name: The name of the action.
  ///   - p1: The first action parameter.
  ///   - p2: The second action parameter.
  ///   - p3: The third action parameter.
  ///   - p4: The fourth action paramter.
  func setActionConfiguration(name: String,
                              _ p1: String,
                              _ p2: String,
                              _ p3: String,
                              _ p4: String) throws {
    let message = "EventExtendedConfigurationActionSet(\(name),\(p1),\(p2),\(p3),\(p4))"
    
    try controller.communicator.write(string: message)
    try controller.communicator.validateNoReturn()
  }
  
  /// Returns the event configuration.
  func getTriggerConfiguration() throws -> String {
    let message = "EventExtendedConfigurationTriggerGet(char *)"
    
    try controller.communicator.write(string: message)
    let configuration = try controller.communicator.read(as: String.self)
    
    return configuration
  }
  
  /// Configures one or several events.
  /// - Parameters:
  ///   - name: The event name.
  ///   - p1: The first event parameter.
  ///   - p2: The second event parameter.
  ///   - p3: The thrid event parameter.
  ///   - p4: The fourth event parameter.
  func setTriggerConfiguration(name: String,
                               _ p1: String,
                               _ p2: String,
                               _ p3: String,
                               _ p4: String) throws {
    let message = "EventExtendedConfigurationTriggerGet(\(name),\(p1),\(p2),\(p3),\(p4))"
    
    try controller.communicator.write(string: message)
    try controller.communicator.validateNoReturn()
  }
  
  /// Returns the event and action configuration defined by the ID.
  /// - Parameter id: The ID of the event and action configuration.
  func getConfiguration(id: Int) throws -> (eventTriggerConfiguration: String, actionConfiguration: String) {
    let message = "EventExtendedGet(\(id), char *, char *)"
    
    try controller.communicator.write(string: message)
    let configuration = try controller.communicator.read(as: (String.self, String.self))
    
    return (eventTriggerConfiguration: configuration.0, actionConfiguration: configuration.1)
  }
  
  /// Removes the event and action configuration defined by the ID.
  /// - Parameter id: The ID of the event and action configuration to remove.
  func remove(id: Int) throws {
    let message = "EventExtendedRemove(\(id))"
    
    try controller.communicator.write(string: message)
    try controller.communicator.validateNoReturn()
  }
  
  /// Launches the last event and action configuration.
  ///
  /// - Returns: The id of the event and action configuration.
  @discardableResult func start() throws -> Int {
    let message = "EventExtendedStart(int *)"
    
    try controller.communicator.write(string: message)
    let id = try controller.communicator.read(as: Int.self)
    
    return id
  }
  
  /// Waits events from the last configuration.
  func wait() throws {
    let message = "EventExtendedWaid()"
    
    try controller.communicator.write(string: message)
    try controller.communicator.validateNoReturn()
  }
}
