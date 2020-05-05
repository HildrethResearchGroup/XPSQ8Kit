//
//  File.swift
//  
//
//  Created by Connor Barnes on 1/13/20.
//

import Foundation
public extension XPSQ8Controller {
	struct GroupController {
		var controller: XPSQ8Controller
        
        public struct JogController {
            var controller: XPSQ8Controller
        }
            
        public struct PositionController {
            var controller: XPSQ8Controller
        }
	}
}


// MARK: - Access Group Namespace
public extension XPSQ8Controller {
	/// The set of commands dealing with globals.
	var group: GroupController {
		return GroupController(controller: self)
	}
}

public extension XPSQ8Controller.GroupController {
    ///The set of commands dealing with Jog
    var jog: JogController {
        return JogController(controller: controller)
    }
}

public extension XPSQ8Controller.GroupController {
    ///The set of commands dealing with Position
    var position: PositionController {
        return PositionController(controller: controller)
    }
}



// MARK: - Group Functions
public extension XPSQ8Controller.GroupController {
    /**
     This function moves the provided stage by the provided target displacement in mm.
     
     This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
     
     - Author:
     
     - Parameters:
       - stage: The name of the stage that will be moved.
       - byDisplacement: The distance in mm to move the specified stage.
     
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
    func moveRelative(stage stageName: String, byDisplacement targetDisplacement: Double) throws {
        let command = "GroupMoveRelative(\(stageName),\(targetDisplacement))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Move the specified stage to the specified position in mm.
     
     This name should be set in the XPS hardward controller softare.  An example stageName would be: "MacroStages.X", where "MacroStages" is the name of the group that the stage belongs to while "X" is the name of the specific stage you want to move.
     
     - Author:
     
     - parameters:
       - stageName: The name of the stage that will be moved.
       - toLocation: The absolute position in mm to move the specified stage.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        let data = try controller?.group.moveAbsolute(stage: "M.X", toLocation: 10)
     } catch {print(error)}
     ````
    */
    func moveAbsolute(stage stageName: String, toLocation targetLocation: Double) throws {
        let command = "GroupMoveAbsolute(\(stageName),\(targetLocation))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Start home seach sequence on specified stage
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio

     - parameters:
       - stageName: The name of the stage that will be moved.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        let data = try controller?.group.homeSearch(stage: "M.X")
     } catch {print(error)}
     ````
    */
    func homeSearch(stage stageName: String) throws {
        let command = "GroupHomeSearch(\(stageName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Kills the selected group to go to “NOTINIT” status.
     
      Kills the selected group to stop its action. The group returns to the “NOTINIT” state. If the group is already in this state then it stays in the “NOT INIT” state.
      The GroupKill is a high priority command that is executed in any condition.
     
     - Author: Steven DiGregorio

     - parameters:
       - groupName: The name of the stage group
     
     # Example #
     ````
     do {
         try controller?.group.kill(group: "M")
         print("Group killed")
     } catch {
         print(error)
     }
     ````
    */
    func kill(group groupName: String) throws {
        let command = "GroupKill(\(groupName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Set motion disable on selected group
     
      Implements  the ```` add here ```` XPS function

     - Author: Steven DiGregorio

     - parameters:
       - stageName: The name of the stage that will be moved.
          
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        try controller?.group.disableMotion(stage: "M.X")
     } catch {print(error)}
     ````
    */
    func disableMotion(stage stageName: String) throws {
        let command = "GroupMotionDisable(\(stageName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Set motion enable on selected group
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio

     - parameters:
       - stageName: The name of the stage that will be moved.
          
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        try controller?.group.enableMotion(stage: "M.X")
     } catch {print(error)}
     ````
    */
    func enableMotion(stage stageName: String) throws {
        let command = "GroupMotionEnable(\(stageName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Return or group positioner status
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
    
     - returns:
        -  status: group of positioner status

     - parameters:
       - stageName: The name of the stage that will be moved.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        let data = try controller?.group.enableMotion(stage: "M.X")
     } catch {print(error)}
     ````
    */
    func getMotionStatus(stage stageName: String) throws -> Int {
        let command = "GroupMotionStatusGet(\(stageName), int *)"
        try controller.communicator.write(string: command)
        let status = try controller.communicator.read(as: (Int.self))
        return status
    }
    
    /**
     Abort a move
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio

     - parameters:
       - stageName: The name of the stage that will be moved.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
        let data = try controller?.group.enableMotion(stage: "M.X")
     } catch {print(error)}
     ````
    */
    func abortMove(stage stageName: String) throws {
        let command = "GroupMoveAbort(\(stageName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }

    /**
      Return group status
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
      
     - returns:
          -  status: group status code

     - parameters:
         - stageName: The name of the stage that will be moved.
       
       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
          let data = try controller?.group.enableMotion(stage: "M.X")
       } catch {print(error)}
       ````
      */
      func getStatus(stage stageName: String) throws -> Int {
          let command = "GroupStatusGet(\(stageName), int *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (Int.self))
          return (status)
      }
    
    /**
       Return the group status string corresponding to the group status code
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
      
       - returns:
          -  status: group status

       - parameters:
         - code: integer code given from group.getStatus
       
       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
          let data = try controller?.group.enableMotion(stage: "M.X")
       } catch {print(error)}
       ````
      */
    func getStatusString(code: Int) throws -> String {
          let command = "GroupStatusStringGet(\(code), char *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (String.self))
          return (status)
      }
    
    /**
       Return the current velocity of the selected stage
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
      
       - returns:
          -  velocity: velocity of selected stage

       - parameters:
         - stageName: The name of the stage that will be moved.

       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
          let data = try controller?.group.enableMotion(stage: "M.X")
       } catch {print(error)}
       ````
      */
    func getCurrentVelocity(stage stageName: String) throws -> Double {
          let command = "GroupVelocityCurrentGet(\(stageName), double *)"
          try controller.communicator.write(string: command)
          let velocity = try controller.communicator.read(as: (Double.self))
          return (velocity)
      }
}


// MARK: - Group.Jog Functions
public extension XPSQ8Controller.GroupController.JogController {
    
    /**
     Returns a tuple containing the current velocity and acceration of the specified stage.]
     
      Implements  the ````void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))```` XPS function
     
     - Author: Owen Hildreth

     - returns:
        - velocity:  The current velocity in mm/s of the specified stage.
        - acceleration:   The current acceration in mm/s^2 of the specified stage.
     - parameters:
        - stage: The name of the stage that will be moved.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let current = try controller?.group.jog.getCurrent(stage: "M.X") {
             let velocity = current.velocity
             let acceleration = current.acceleration
             print("Velocity = \(velocity)")
             print("Acceleartion = \(acceleration)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func getCurrent(stage stageName: String) throws -> (velocity: Double, acceleration: Double) {
        // implements void GroupJogCurrentGet(char GroupName[250], double* Velocity, double* Acceleration)
        // GroupJogCurrentGet(M.X,double *,double *)
        let message = "GroupJogCurrentGet(\(stageName), double *, double *)"
        
        try controller.communicator.write(string: message)
        
        let currentJog = try controller.communicator.read(as: (Double.self, Double.self))
        
        return (velocity: currentJog.0, acceleration: currentJog.1)
    }
    
    /**
     Disable Jog mode on selected group.
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
     
     - parameters:
        - stage: The name of the stage to have jog mode disabled.
     
     # Example #
     ````

     ````
    */
    func disable(stage stageName: String) throws {
        // implements void GroupJogModeDisable(char GroupName[250])
        // GroupJogModeDisable(M.X)
        let message = "GroupJogModeDisable(\(stageName))"
        try controller.communicator.write(string: message)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Enable Jog mode on selected group.
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
     
     - parameters:
        - stage: The name of the stage to have jog mode Enabled.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let current = try controller?.group.jog.getCurrent(stage: "M.X") {
             let velocity = current.velocity
             let acceleration = current.acceleration
             print("Velocity = \(velocity)")
             print("Acceleartion = \(acceleration)")
         } else { print("current = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func enable(stage stageName: String) throws {
        // implements void GroupJogModeEnable(char GroupName[250])
        // GroupJogModeEnable(M.X)
        let message = "GroupJogModeEnable(\(stageName))"
        try controller.communicator.write(string: message)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Returns a tuple containing the parameters for velocity and acceration set for the specified stage.
     
      Implements  the ````add here```` XPS function
     
     - Author: Steven DiGregorio
     
     - returns:
        - velocity:  The set velocity parameter in mm/s of the specified stage.
        - acceleration:   The set acceration parameter in mm/s^2 of the specified stage.
     - parameters:
        - stage: The name of the stage to find the parameters of.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let parameters = try controller?.group.jog.getParameters(stage: "M.X") {
             let velocity = parameters.velocity
             let acceleration = parameters.acceleration
             print("Velocity = \(velocity)")
             print("Acceleartion = \(acceleration)")
         } else { print("parameters = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func getParameters(stage stageName: String) throws -> (velocity: Double, acceleration: Double) {
        // implements void GroupJogParametersGet(char GroupName[250], double* Velocity, double* Acceleration)
        // GroupJogParametersGet(M.X,double *,double *)
        let message = "GroupJogParametersGet(\(stageName), double *, double *)"
        
        try controller.communicator.write(string: message)
        
        let parameters = try controller.communicator.read(as: (Double.self, Double.self))
        
        return (velocity: parameters.0, acceleration: parameters.1)
    }
    
}

// MARK: - Group.Position Functions
public extension XPSQ8Controller.GroupController.PositionController {
    /**
     Returns the current position of the specified stage.
     
      Implements  the ````add here```` XPS function
     
     - Author: Steven DiGregorio
     
     - returns:
        - currentEncoderPosition: current encoder position of the specified stage
     - parameters:
        - stage: The name of the stage to find the positon of
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let parameters = try controller?.group.jog.getParameters(stage: "M.X") {
             let velocity = parameters.velocity
             let acceleration = parameters.acceleration
             print("Velocity = \(velocity)")
             print("Acceleartion = \(acceleration)")
         } else { print("parameters = nil") }
     } catch {
         print(error)
     }
     ````
    */
    func getCurrent(stage stageName: String) throws -> Double {
        // implements void GroupJogParametersGet(char GroupName[250], double* Velocity, double* Acceleration)
        // GroupJogParametersGet(M.X,double *,double *)
        let message = "GroupPositionCurrentGet(\(stageName), double *)"
        try controller.communicator.write(string: message)
        let currentEncoderPosition = try controller.communicator.read(as: Double.self)
        return currentEncoderPosition
    }
    
    /**
      Returns the position setpoint of the specified stage.
      
       Implements  the ````add here```` XPS function
     
     - Author: Steven DiGregorio
      
      - returns:
         - setPoint: position setpoint of the specified stage
      - parameters:
         - stage: The name of the stage to find the positon setpoint of
      
      # Example #
      ````
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
      
      do {
          if let parameters = try controller?.group.jog.getParameters(stage: "M.X") {
              let velocity = parameters.velocity
              let acceleration = parameters.acceleration
              print("Velocity = \(velocity)")
              print("Acceleartion = \(acceleration)")
          } else { print("parameters = nil") }
      } catch {
          print(error)
      }
      ````
     */
     func getSetpoint(stage stageName: String) throws -> Double {
         // implements void GroupJogParametersGet(char GroupName[250], double* Velocity, double* Acceleration)
         // GroupJogParametersGet(M.X,double *,double *)
         let message = "GroupPositionSetpointGet(\(stageName), double *)"
         try controller.communicator.write(string: message)
         let setPoint = try controller.communicator.read(as: Double.self)
         return setPoint
     }
    
    /**
         Returns the position targer of the specified stage.
         
          Implements  the ````add here```` XPS function
     
        - Author: Steven DiGregorio
         
         - returns:
            - targett: position target of the specified stage
         - parameters:
            - stage: The name of the stage to find the positon target of
         
         # Example #
         ````
         let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
         
         do {
             if let parameters = try controller?.group.jog.getParameters(stage: "M.X") {
                 let velocity = parameters.velocity
                 let acceleration = parameters.acceleration
                 print("Velocity = \(velocity)")
                 print("Acceleartion = \(acceleration)")
             } else { print("parameters = nil") }
         } catch {
             print(error)
         }
         ````
        */
        func getTarget(stage stageName: String) throws -> Double {
            // implements void GroupJogParametersGet(char GroupName[250], double* Velocity, double* Acceleration)
            // GroupJogParametersGet(M.X,double *,double *)
            let message = "GroupPositionTargetGet(\(stageName), double *)"
            try controller.communicator.write(string: message)
            let target = try controller.communicator.read(as: Double.self)
            return target
        }
    
}
