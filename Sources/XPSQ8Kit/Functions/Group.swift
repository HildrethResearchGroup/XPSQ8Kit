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
     
     - Author: Owen Hildreth
     
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
     
      This function initiates a home search for each positioner of the selected group.
      The group must be initialized and the group must be in “NOT REFERENCED” state else this function returns the ERR_NOT_ALLOWED_ACTION (-22) error. If no error then the group status becomes “HOMING”.
      The home search can fail due to:
      1) a following error: ERR_FOLLOWING_ERROR (-25)
      2) a ZM detection error: ERR_GROUP_HOME_SEARCH_ZM_ERROR (-49)
      3) a motion done time out when a dynamic error of the positioner is detected during one of the moves during the home search process: ERR_GROUP_MOTION_DONE_TIMEOUT (-33)
      4) a home search timeout when the complete (and complex) home search procedure was not executed in the allowed time: ERR_HOME_SEARCH_TIMEOUT (-28)
     
      For all these errors, the group returns to the “NOTINIT” state.
      After the home search sequence, each positioner error is checked. If an error is detected, the hardware status register is reset (motor on) and the positioner error is cleared before checking it again. If a positioner error is always present, ERR_TRAVEL_LIMITS (-35) is returned and the group becomes “NOTINIT”.
      Once the home search is successful, the group is in “READY” state.
     
     - Author: Steven DiGregorio

     - parameters:
       - group: The name of the stage group
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.homeSearch(group: "M")
         print("Home Search completed")
     } catch {
         print(error)
     }
     ````
    */
    func homeSearch(group groupName: String) throws {
        let command = "GroupHomeSearch(\(groupName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Kills the selected group to go to “NOTINIT” status.
     
      Kills the selected group to stop its action. The group returns to the “NOTINIT” state. If the group is already in this state then it stays in the “NOT INIT” state.
      The GroupKill is a high priority command that is executed in any condition.
     
     - Author: Steven DiGregorio

     - parameters:
       - group: The name of the stage group
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)

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
     
      Turns OFF the motors, stops the corrector servo loop and disables the position compare mode if active. The group status becomes “DISABLE”.
      If the group is not in the “READY” state then an ERR_NOT_ALLOWED_ACTION (- 22) is returned.
     
     - Author: Steven DiGregorio

     - parameters:
       - group: The name of the stage to disable
          
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.disableMotion(group: "M")
         print("Motion disabled")
     } catch {
         print(error)
     }
     ````
    */
    func disableMotion(group groupName: String) throws {
        let command = "GroupMotionDisable(\(groupName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Enables a group in a DISABLE state to turn the motors on and to restart corrector loops.

     Turns ON the motors and restarts the corrector servo loops. The group state becomes “READY”.
     If the group is not in the “DISABLE” state then the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
     
     - Author: Steven DiGregorio

     - parameters:
       - group: The name of the stage that will be moved.
          
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.enableMotion(group: "M")
         print("Motion enabled")
     } catch {
         print(error)
     }
     ````
    */
    func enableMotion(group groupName: String) throws {
        let command = "GroupMotionEnable(\(groupName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Returns the motion status for one or all positioners of the selected group.
     
      Returns the motion status for one or all positioners of the selected group.
      The motion status possible values are :
      0 : Not moving state (group status in NOT_INIT, NOT_REF or READY).
      1 : Busy state (positioner in moving, homing, referencing, spinning, analog tracking, trajectory, encoder calibrating, slave mode).
     
     - Author: Steven DiGregorio
    
     - returns:
        -  status: group or positioner status

     - parameters:
       - stage: The name of the stage or group
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let status = try controller?.group.getMotionStatus(stage: "M.X"){
             print("Status: \(status)")
         }
         print("get motion status completed")
     } catch {
         print(error)
     }
     ````
    */
    func getMotionStatus(stageOrGroupName name: String) throws -> Int {
        let command = "GroupMotionStatusGet(\(name), int *)"
        try controller.communicator.write(string: command)
        let status = try controller.communicator.read(as: (Int.self))
        return status
    }
    
    
    /**
     Aborts the motion or the jog in progress for a group or a positioner.
     
      This function aborts a motion or a jog in progress. The group state must be “MOVING” or “JOGGING” else the “ERR_NOT_ALLOWED_ACTION (-22)” is returned.
     
      For a group:
      1) If the group status is “MOVING”, this function stops all motion in progress.
      2) If the group status is “JOGGING”, this function stops all “jog” motions in progress and disables the jog mode. After this “group move abort” action, the group status becomes “READY”.
     
      For a positioner:
      1) If the group status is “MOVING”, this function stops the motion of the selected positioner.
      2) If the group status is “JOGGING”, this function stops the “jog” motion of the selected positioner.
      3) If the positioner is idle, an ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
      After this “positioner move abort” action, if all positioners are idle then the group status becomes “READY”, else the group stays in the same state.
     
     - Author: Steven DiGregorio

     - parameters:
       - stage: The name of the stage or group.
     
     # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.abortMove(stage: "M.X")
         print("Move aborted")
     } catch {
         print(error)
     }
     ````
    */
    func abortMove(_ stageName: String) throws {
        let command = "GroupMoveAbort(\(stageName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }

    
    /**
      Returns the group status code
     
      Returns the group status code. The group status codes are listed in the “Group status list” § 0.
      The description of the group status code can be retrieved from the “GroupStatusStringGet” function.
     
     - Author: Steven DiGregorio
      
     - returns:
          -  status: group status code

     - parameters:
         - group: The name of the stage group
       
       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
           if let status = try controller?.group.getStatus(group: "M"){
               print("Status code: \(status)")
           }
           print("get status completed")
       } catch {
           print(error)
       }
       ````
      */
      func getStatus(group groupName: String) throws -> Int {
          let command = "GroupStatusGet(\(groupName), int *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (Int.self))
          return (status)
      }
    
    
    /**
       Get the group state description from a group state code.
     
       This function returns the group state description corresponding to a group state code (see § 0 Group state list).
       If the group state code is not referenced then the “Error: undefined status” message will be returned.
     
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
           if let status = try controller?.group.getStatusString(code: 12){
               print("Status: \(status)")
           }
           print("get status completed")
       } catch {
           print(error)
       }
       ````
      */
    func getStatusString(code: Int) throws -> String {
          let command = "GroupStatusStringGet(\(code), char *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (String.self))
          return (status)
      }
    
    
    /**
      Returns the current velocity for one or all positioners of the selected group.
          
     - Author: Steven DiGregorio
      
       - returns:
          -  velocity: velocity of selected stage

       - parameters:
         - stage: The name of the stage

       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
           if let velocity = try controller?.group.getCurrentVelocity(stage: "M.X"){
               print("velocity = \(velocity)")
           }
           print("Get velocity completed")
       } catch {
           print(error)
       }
       ````
      */
    func getCurrentVelocity(forStage stageName: String) throws -> Double {
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
     
     Implements  the ````int GroupJogModeDisable (int SocketID, char *GroupName)````  XPS function.
     
      Disables the Jog mode. To use this function, the group must be in the “JOGGING” state and all positioners must be idle (meaning velocity must be 0).
      This function exits the “JOGGING” state and to returns to the “READY” state. If the group state is not in the “JOGGING” state or if the profiler velocity is not null then the error ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
     - Author: Steven DiGregorio
     
     - parameters:
        - group: The name of the stage  group
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.jog.disable(group: "M")
         print("Jog disabled")
     } catch {
         print(error)
     }
     ````
    */
    func disable(group groupName: String) throws {
        let message = "GroupJogModeDisable(\(groupName))"
        try controller.communicator.write(string: message)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Enable Jog mode on selected group.
     
     Implements  the ````int GroupJogModeEnable (int SocketID, char *GroupName)````  XPS function.
     
      Enables the Jog mode. To use this function, the group must be in the “READY” state and all positioners must be idle (meaning velocity must be 0).
      This function goes to the “JOGGING” state. If the group state is not “READY”, ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
     - Author: Steven DiGregorio
     
     - parameters:
        - group: The name of the stage
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         try controller?.group.jog.enable(group: "M")
         print("Jog enabled")
     } catch {
         print(error)
     }
     ````
    */
    func enable(group groupName: String) throws {
        let message = "GroupJogModeEnable(\(groupName))"
        try controller.communicator.write(string: message)
        try controller.communicator.validateNoReturn()
    }
    

    /**
     Returns the velocity and acceleration set by “GroupJogParametersSet” for a specific stage
     
     Implements  the ````int GroupJogParametersGet (int SocketID, char *GroupName, int NbPositioners, double * Velocity, double * Acceleration)````  XPS function.
     
     
      This function returns the velocity and the acceleration set by the user to use the jog mode for one positioner or for all positioners of the selected group.
      So, this function must be called when the group is in “JOGGING” mode else the velocity and the acceleration will be null.
      To change the velocity and the acceleration on the fly, in the jog mode, call the “GroupJogParametersSet” function.
     
     - Authors: Steven DiGregorio
     
     - returns:
        - velocity:  The set velocity parameter in mm/s of the specified stage.
        - acceleration:   The set acceration parameter in mm/s^2 of the specified stage.
     
     - parameters:
        - stage: The name of the stage to find the parameters of.
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let params = try controller?.group.jog.getParameters(stage: "M.X"){
             print("set velocity = \(params.0)")
             print("set acceleration = \(params.1)")
         }
         print("Get job parameters completed")
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
} // END:  Group.Jog Functions


// MARK: - Group.Position Functions
public extension XPSQ8Controller.GroupController.PositionController {
    /**
     Returns the current position for one or all positioners of the selected group.
     
     Implements  the ````void GroupPositionCurrentGet(char groupName[250], double *CurrentEncoderPosition)````  XPS function.
     
      Returns the current position for one or all positioners of the selected group. The current position is defined as:
      CurrentPosition = SetpointPosition - FollowingError
     
     - Authors: Steven DiGregorio
     
     - returns:
        - currentEncoderPosition: current encoder position of the specified stage
     
     - parameters:
        - stage: The name of the stage to find the positon of
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
         if let position = try controller?.group.position.getCurrent(stage: "M.X"){
             print("position = \(position)")
         }
         print("Get position completed")
     } catch {
         print(error)
     }
     ````
    */
    func getCurrent(stage stageName: String) throws -> Double {
        let message = "GroupPositionCurrentGet(\(stageName), double *)"
        try controller.communicator.write(string: message)
        let currentEncoderPosition = try controller.communicator.read(as: Double.self)
        return currentEncoderPosition
    }
    
    
    /**
      Returns the setpoint position for one or all positioners of the selected stage.
      
     Implements the ````void GroupPositionSetpointGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group.  The “setpoint” position is calculated by the motion profiler and represents the “theoretical” position to reach.
          
     - Author: Steven DiGregorio
      
      - returns:
         - setPoint: position setpoint of the specified stage
     
      - parameters:
         - stage: The name of the stage to find the positon setpoint of
      
      # Example #
      ````
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
      
      do {
          if let setPoint = try controller?.group.position.getSetpoint(stage: "M.X"){
              print("set point = \(setPoint)")
          }
          print("Get set point completed")
      } catch {
          print(error)
      }
      ````
     */
     func getSetpoint(stage stageName: String) throws -> Double {
         let message = "GroupPositionSetpointGet(\(stageName), double *)"
         try controller.communicator.write(string: message)
         let setPoint = try controller.communicator.read(as: Double.self)
         return setPoint
     }
    
    
    /**
     Returns the target position for one or all positioners of the selected group.
     
     Implements the ````void GroupPositionTargetGet(char groupName[250], double *CurrentEncoderPosition)```` XPS function at the Stage Group.
     
     Returns the target position for one or all positioners of the selected group. The target position represents the “end” position after the move.
     
     For instance, during a move from 0 to 10 units, the position values are: GroupPositionTargetGet => 10.0000
     GroupPositionCurrentGet => 5.0005 GroupPositionSetpointGet => 5.0055
     
     - Authors: Steven DiGregorio
     
     - Returns:
        - target: position target of the specified stage
     
     - Parameters:
        - stage: The name of the stage to find the positon target of
     
     # Example #
     ````
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
     do {
     if let target = try controller?.group.position.getTarget(stage: "M.X"){
     print("target = \(target)")
     }
     print("Get target completed")
     } catch {
     print(error)
     }
     ````
     */
        func getTarget(stage stageName: String) throws -> Double {
            let message = "GroupPositionTargetGet(\(stageName), double *)"
            try controller.communicator.write(string: message)
            let target = try controller.communicator.read(as: Double.self)
            return target
        }
}
