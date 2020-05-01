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
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
    
     - Parameters:
        - positioner: The name of the positioner that will be moved.
    
    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     // use moveRelative function
       do {
        let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
       } catch {print(error)}
      ````
    */
    func killScript(task taskName: String) throws {
        let command = "TCLScriptKill(\(taskName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Kill all TCL tasks
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
    
     - Parameters:
        - positioner: The name of the positioner that will be moved.
    
    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     // use moveRelative function
       do {
        let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
       } catch {print(error)}
      ````
    */
    func killAllScripts() throws {
        let command = "TCLScriptKillAll()"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
}
