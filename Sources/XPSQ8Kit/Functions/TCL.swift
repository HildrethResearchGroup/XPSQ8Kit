//
//  TCL.swift
//  
//
//  Created by Steven DiGregorio on 4/30/20.
//

import Foundation
public extension XPSQ8Controller {
  /// A namespace for TCL commands.
  struct TCL {
    var controller: XPSQ8Controller
  }
}

// MARK: - Access Positioner Namespace
public extension XPSQ8Controller {
  /// The set of commands dealing with globals.
  var tcl: TCL {
    return TCL(controller: self)
  }
}

// MARK: - TCL Functions
public extension XPSQ8Controller.TCL {
  /// Kills the TCL task with the given name.
  ///
  /// # Example #
  /// ````
  /// try await controller.tcl.killScript(named: "MyScript")
  /// ````
  ///
  /// - Parameter taskName: the name of the TCL task to kill.
  func killScript(named taskName: String) async throws {
    let command = "TCLScriptKill(\(taskName))"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
  
  /// Kills all running TCL scripts.
  ///
  /// # Example #
  /// ````
  /// try await controller.tcl.killAllScripts()
  /// ````
  func killAllScripts() async throws {
    let command = "TCLScriptKillAll()"
    try await controller.communicator.write(string: command)
    try await controller.communicator.validateNoReturn()
  }
}
