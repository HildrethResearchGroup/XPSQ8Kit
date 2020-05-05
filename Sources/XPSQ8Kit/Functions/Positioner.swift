//
//  Positioner.swift
//  
//
//  Created by Steven DiGregorio on 4/30/20.
//

import Foundation
public extension XPSQ8Controller {
    struct PositionerController {
        var controller: XPSQ8Controller
        
        public struct SGammaController {
            var controller: XPSQ8Controller
        }
    }
}



// MARK: - Access Positioner Namespace
public extension XPSQ8Controller {
    /// The set of commands dealing with globals.
    var positioner: PositionerController {
        return PositionerController(controller: self)
    }
}

public extension XPSQ8Controller.PositionerController {
    ///The set of commands dealing with Jog
    var SGamma: SGammaController {
        return SGammaController(controller: controller)
    }
}

// MARK: - Positioner Functions
public extension XPSQ8Controller.PositionerController {
    
    /**
     Astrom & Hägglund based auto-scaling
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
     
     - returns:
        -  scaling: Astrom & Hägglund based auto-scaling
    
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
    func accelerationAutoScaling(positioner positionerName: String) throws -> Double {
        let command = "PositionerAccelerationAutoScaling(\(positionerName), Double *)"
        try controller.communicator.write(string: command)
        let scaling = try controller.communicator.read(as: (Double.self))
        return scaling
    }
    
    /**
     Disables the backlash compensation
     
      This function disables the backlash compensation. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
      In the “stages.ini” file the parameter “Backlash” will enable or disable this feature as follows:
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Author: Steven DiGregorio
    
     - Parameters:
      - positioner: The name of the positioner

    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         try controller?.positioner.disableBacklash(positioner: "M.X")
         print("Backlash compensation disabled")
     } catch {
         print(error)
     }
      ````
    */
    func disableBacklash(positioner positionerName: String) throws {
        let command = "PositionerBacklashDisable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Enables the backlash compensation
     
     This function enables the backlash compensation defined in the “stages.ini” file or defined by the “PositionerBacklashSet” function. If the backlash compensation value is null then this function will have not effect, and backlash compensation will remain disabled. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
      The group state must be NOTINIT to enable the backlash compensation. If it is not the case then ERR_NOT_ALLOWED_ACTION (-22) is returned.
      In the “stages.ini” file the parameter “Backlash” allows the user to enable or disable the backlash compensation.
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Author: Steven DiGregorio
    
     - Parameters:
        - positioner: The name of the positioner
    
    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         try controller?.positioner.enableBacklash(positioner: "M.X")
         print("Backlash compensation enabled")
     } catch {
         print(error)
     }
      ````
    */
    func enableBacklash(positioner positionerName: String) throws {
        let command = "PositionerBacklashEnable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
       Gets the positioner hardware status code
     
       This function returns the hardware status of the selected positioner. The positioner hardware status is composed of the “corrector” hardware status and the “servitudes” hardware status:
       The “Corrector” returns the motor interface and the position encoder hardware status. The “Servitudes” returns the general inhibit and the end of runs hardware status.
     
     - Author: Steven DiGregorio
      
       - returns:
          -  status: positioner hardware status code

       - parameters:
         - positionerName: The name of the positioner
       
       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
           if let code = try controller?.positioner.getHardwareStatus(positioner: "M.X"){
               print("status code = \(code)")
           }
           print("Get positioner status code completed")
       } catch {
           print(error)
       }
       ````
      */
      func getHardwareStatus(positioner positionerName: String) throws -> Int {
          let command = "PositionerHardwareStatusGet(\(positionerName), int *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (Int.self))
          return (status)
      }
    
    /**
     Gets the maximum velocity and acceleration from the profiler generators.
     
      This function returns the maximum velocity and acceleration of the profile generators. These parameters represent the limits for the profiler and are defined in the stages.ini file:
      MaximumVelocity = ; unit/second
     MaximumAcceleration = ; unit/second2
     
     - Author: Steven DiGregorio
     
      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         -  velocity: Maximum velocity
         - acceleration: Maximum acceleration
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      do {
          if let params = try controller?.positioner.getMaximumVelocityAndAcceleration(positioner: "M.X"){
              print("max velocity = \(params.0)")
              print("max acceleration = \(params.1)")
          }
          print("Get maximums completed")
      } catch {
          print(error)
      }
       ````
     */
     func getMaximumVelocityAndAcceleration(positioner positionerName: String) throws -> (velocity: Double, acceleration: Double) {
        let command = "PositionerMaximumVelocityAndAccelerationGet(\(positionerName), double *, double *)"
        try controller.communicator.write(string: command)
        let maximums = try controller.communicator.read(as: (Double.self, Double.self))
        return (velocity: maximums.0, acceleration: maximums.1)
     }
    
    /**
      Gets the motion done parameters
     
      This function returns the motion done parameters only for the “VelocityAndPositionWindow” MotionDone mode. If the MotionDone mode is defined as “Theoretical” then ERR_WRONG_OBJECT_TYPE (-8) is returned.
     
      The “MotionDoneMode” parameter from the stages.ini file defines the motion done mode. The motion done can be defined as “Theoretical” (the motion done mode is not used) or “VelocityAndPositionWindow”. For a more thorough description of the motion done mode, please refer to the XPS Motion Tutorial section Motion/Motion Done.
     
     - Author: Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - returns:
         -  positionWindow:
         - velocityWindow:
         - checkingTime:
         - meanPeriod:
         - timeout: 
     
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
     func getMotionDone(positioner positionerName: String) throws -> (positionWindow: Double, velocityWindow: Double, checkingTime: Double, meanPeriod: Double, timeout: Double) {
        let command = "PositionerMotionDoneGet(\(positionerName), double *, double *, double *, double *, double *)"
        try controller.communicator.write(string: command)
        let motionDone = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self, Double.self))
        return (positionWindow: motionDone.0, velocityWindow: motionDone.1, checkingTime: motionDone.2, meanPeriod: motionDone.3, timeout: motionDone.4)
     }
    
    /**
     Gets a stage parameter value from the stages.ini file

      This function returns stage parameter values from the stages.ini file of a selected positioner.
     
      The positioner name is the stage name. And the parameter name is read in the section under this stage name.
     
     - Author: Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - returns:
         -  positionWindow:
         - velocityWindow:
         - checkingTime:
         - meanPeriod:
         - timeout:
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      // use moveRelative function
        do {
         let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
        } catch {print(error)}
       ````
//     */
//     func getStageParameter(positioner positionerName: String) throws -> String {
//        let command = "PositionerStageParameterGet(\(positionerName), Double *, Double *, Double *, Double *, Double *)"
//        try controller.communicator.write(string: command)
//        let motionDone = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self, Double.self))
//        return (positionWindow: motionDone.0, velocityWindow: motionDone.1, checkingTime: motionDone.2, meanPeriod: motionDone.3, timeout: motionDone.4)
//     }
    
    /**
    Gets the user travel limits
     
     This function returns the user-defined travel limits for the selected positioner.
     
     - Author: Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         -  userMinimumTarget
         - userMaximumTarget
     
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
     func getUserTravelLimits(positioner positionerName: String) throws -> (userMinimumTarget: Double, userMaximumTarget: Double) {
        let command = "PositionerUserTravelLimitsGet(\(positionerName), double *, double *)"
        try controller.communicator.write(string: command)
        let targets = try controller.communicator.read(as: (Double.self, Double.self))
        return (userMinimumTarget: targets.0, userMaximumTarget: targets.1)
     }

}


// MARK: - Positioner.SGamma Functions
public extension XPSQ8Controller.PositionerController.SGammaController {
    
    /**
      Gets the current motion values from the SGamma profiler
     
       This function gets the current SGamma profiler values that are used in displacements.
     
     - Author: Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - returns:
         -  velocity:
         - acceleration:
         - minumumTjerkTime:
         - maximumTjerkTime:
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      do {
          if let params = try controller?.positioner.SGamma.getParameters(positioner: "M.X"){
              print("velocity = \(params.0)")
              print("acceleration = \(params.1)")
              print("minimum T jerk time = \(params.2)")
              print("maximum T jerk time = \(params.3)")
          }
          print("Get parameters completed")
      } catch {
          print(error)
      }
       ````
     */
     func getParameters(positioner positionerName: String) throws -> (velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double) {
        let command = "PositionerSGammaParametersGet(\(positionerName), double *, double *, double *, double *)"
        try controller.communicator.write(string: command)
        let parameters = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self))
        return (velocity: parameters.0, acceleration: parameters.1, minimumTjerkTime: parameters.2, maximumTjerkTime: parameters.3)
     }
    
    /**
    Gets the motion and the settling time
     
      This function returns the motion (setting) and settling times from the previous motion. The motion time represents the defined time to complete the previous displacement. The settling time represents the effective settling time for a motion done.
     
     - Author: Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - returns:
         - settingTime
         - settlingTime
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      do {
          if let times = try controller?.positioner.SGamma.getPreviousMotionTimes(positioner: "M.X"){
              print("setting time = \(times.0)")
              print("settling time = \(times.1)")
          }
          print("Get previous motion times completed")
      } catch {
          print(error)
      }
       ````
     */
     func getPreviousMotionTimes(positioner positionerName: String) throws -> (setting: Double, settling: Double) {
        let command = "PositionerSGammaPreviousMotionTimesGet(\(positionerName), double *, double *)"
        try controller.communicator.write(string: command)
        let times = try controller.communicator.read(as: (Double.self, Double.self))
        return (setting: times.0, settling: times.1)
     }
}


