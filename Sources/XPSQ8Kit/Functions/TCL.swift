//
//  TCL.swift
//  
//
//  Created by Steven DiGregorio on 4/30/20.
//

import Foundation
public extension XPSQ8Controller {
  struct TCLController {
    var controller: XPSQ8Controller
  }
}



// MARK: - Access Positioner Namespace
public extension XPSQ8Controller {
  /// The set of commands dealing with globals.
  var TCL: TCLController {
    return TCLController(controller: self)
  }
}

// MARK: - TCL Functions
public extension XPSQ8Controller.TCLController {
  
  /**
   Kill TCL task
   
   This function kills a running TCL script selected using its task name. The task name is a user designation for the TCL script in execution.
   
   - Author: Steven DiGregorio
   
   - Parameters:
   - taskName: Name of the task
   
   # Example #
   ````
   
   ````
   */
  func killScript(task taskName: String) throws {
    let command = "TCLScriptKill(\(taskName))"
    try controller.communicator.write(string: command)
    try controller.communicator.validateNoReturn()
  }
  
  /**
   Kills all running TCL scripts
   
   This function kills all running TCL scripts
   
   - Author: Steven DiGregorio
   
   
   # Example #
   ````
   // Setup Controller
   let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
   
   do {
   try controller?.TCL.killAllScripts()
   print("All TCL tasks killed")
   } catch {
   print(error)
   }
   ````
   */
  func killAllScripts() throws {
    let command = "TCLScriptKillAll()"
    try controller.communicator.write(string: command)
    try controller.communicator.validateNoReturn()
  }
}
