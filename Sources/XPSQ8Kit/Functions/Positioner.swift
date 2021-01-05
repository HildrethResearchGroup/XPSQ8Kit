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
     Auto-scaling process for determining the stage scaling acceleration
     
     Implements the  ````void PositionerAccelerationAutoScaling( char PositionerName[250],  double* Scaling)````  XPS Controller function.
     
      The function executes an auto-scaling process and returns the calculated scaling acceleration. The selected group must be in “NOTINIT” state, else ERR_NOT_ALLOWED_ACTION (-22) is returned. More information in the programmer manual
     
     Takes a long time to return a value
     
     - Authors:
        - Steven DiGregorio
     
     - Returns:
        -  scaling: Astrom & Hägglund based auto-scaling
    
     - Parameters:
       - positioner: The name of the positioner
    
    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         if let scaling = try controller?.positioner.accelerationAutoScaling(positioner: "M.X"){
             print("scaling = \(scaling)")
         }
         print("Auto-scaling complete")
     } catch {
         print(error)
     }
      ````
    */
    func accelerationAutoScaling(positioner positionerName: String) throws -> Double {
        let command = "PositionerAccelerationAutoScaling(\(positionerName), double *)"
        try controller.communicator.write(string: command)
        let scaling = try controller.communicator.read(as: (Double.self))
        return scaling
    }
    
    
    /**
     Disables the backlash compensation
     
     Implements the  ````void PositionerBacklashDisable(char PositionerName[250])````  XPS Controller function.
     
      This function disables the backlash compensation. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
     
      In the “stages.ini” file the parameter “Backlash” will enable or disable this feature as follows:
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Authors:
        - Steven DiGregorio
    
     - Parameters:
       - positioner: The name of the positioner

    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         try controller?.positioner.backlashDisable(positioner: "M.X")
         print("Backlash compensation disabled")
     } catch {
         print(error)
     }
      ````
    */
    func backlashDisable(positioner positionerName: String) throws {
        let command = "PositionerBacklashDisable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Enables the backlash compensation
     
     Implements the  ````void PositionerBacklashEnable(char PositionerName[250])````  XPS Controller function.
     
     This function enables the backlash compensation defined in the “stages.ini” file or defined by the “PositionerBacklashSet” function. If the backlash compensation value is null then this function will have not effect, and backlash compensation will remain disabled. For a more thorough description of the backlash compensation, please refer to the XPS Motion Tutorial section Compensation/Backlash compensation.
     
      The group state must be NOTINIT to enable the backlash compensation. If it is not the case then ERR_NOT_ALLOWED_ACTION (-22) is returned.
     
      In the “stages.ini” file the parameter “Backlash” allows the user to enable or disable the backlash compensation.
     
      Backlash = 0 —> Disable backlash Backlash > 0 —> Enable backlash
     
     - Authors:
        - Steven DiGregorio
    
     - Parameters:
        - positioner: The name of the positioner
    
    # Example #
     ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         try controller?.positioner.backlashEnable(positioner: "M.X")
         print("Backlash compensation enabled")
     } catch {
         print(error)
     }
      ````
    */
    func backlashEnable(positioner positionerName: String) throws {
        let command = "PositionerBacklashEnable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    
    /**
     Gets the positioner hardware status code
     
     Implements the  ````void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)````  XPS Controller function.
     
     This function returns the hardware status of the selected positioner. The positioner hardware status is composed of the “corrector” hardware status and the “servitudes” hardware status:
     
     The “Corrector” returns the motor interface and the position encoder hardware status.
     The “Servitudes” returns the general inhibit and the end of runs hardware status.
     
     - Authors:
        - Steven DiGregorio
      
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
     
     Implements the  ````void PositionerHardwareStatusGet(char PositionerName[250], int* HardwareStatus)````  XPS Controller function.
     
     This function returns the maximum velocity and acceleration of the profile generators. These parameters represent the limits for the profiler and are defined in the stages.ini file:
     
     MaximumVelocity = ; unit/second
     
     MaximumAcceleration = ; unit/second2
     
     - Authors:
        - Steven DiGregorio
     
      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         - velocity: Maximum velocity in units/sec (units most likely  mm/sec)
         - acceleration: Maximum acceleration in units/sec^2 (units most likely  mm/sec^2)
     
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
     
     Implements the  ````void PositionerMotionDoneGet(char PositionerName[250], double* positionWindow, double* velocityWindow, double* checkingTime, double* meanPeriod, double* timeOut)````  XPS Controller function.
     
      This function returns the motion done parameters only for the “VelocityAndPositionWindow” MotionDone mode. If the MotionDone mode is defined as “Theoretical” then ERR_WRONG_OBJECT_TYPE (-8) is returned.
     
      The “MotionDoneMode” parameter from the stages.ini file defines the motion done mode. The motion done can be defined as “Theoretical” (the motion done mode is not used) or “VelocityAndPositionWindow”. For a more thorough description of the motion done mode, please refer to the XPS Motion Tutorial section Motion/Motion Done.
     
     - Authors:
        - Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         - positionWindow:  Position Window in units (most likely mm)
         - velocityWindow:  Velocity window in units/seconds ( most likely mm/sec)
         - checkingTime:  Checking time in seconds
         - meanPeriod:  Mean period in seconds
         - timeout:   Motion done time out in seconds
     
     # Example #
      ````
     // Setup Controller
     let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
    
     do {
         if let params = try controller?.positioner.getMotionDone(positioner: "M.X"){
            print("positionWindow   = \(params.0)")
            print("velocityWindow   = \(params.1)")
            print("checkingTime     = \(params.2)")
            print("meanPeriod       = \(params.3)")
            print("timeout          = \(params.4)")
         }
         print("Get maximums completed")
     } catch {
         print(error)
     }
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
     
     - Authors:
        - Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner
     
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
     
     Implements the  ````void PositionerUserTravelLimitsGet(char PositionerName[250], double* UserMinimumTarget, double* UserMaximumTarget)````  XPS Controller function.
     
     This function returns the user-defined travel limits for the selected positioner.
     
     - Authors:
        - Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner
     
      - Returns:
         - userMinimumTarget in units (likely mm )
         - userMaximumTarget in units (likely mm )
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      do {
          if let limits = try controller?.positioner.getUserTravelLimits(positioner: "M.X"){
              print("Minimum target = \(limits.0)")
              print("Maximum target = \(limits.1)")
          }
          print("Get user travel limits completed")
      } catch {
          print(error)
      }
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
     
     Implements the  ````void PositionerSGammaParametersGet(char PositionerName[250], double* Velocity, double* Acceleration, double* MinimumTjerkTime, double* MaximumTjerkTime)````  XPS Controller function.
     
     This function gets the current SGamma profiler values that are used in displacements.
     
     - Authors:
        - Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner
     
      - returns:
         - velocity (units/sec)
         - acceleration (units/sec^2)
         - minumumTjerkTime (sec)
         - maximumTjerkTime (sec)
     
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
     Sets new motion values for the SGamma profiler
     
     Implements the  ````int PositionerSGammaParametersSet (int SocketID, char FullPositionerName[250] , double Velocity, double Acceleration, double MinimumJerkTime, double MaximumJerkTime)````  XPS Controller function.
     
     This function defines the new SGamma profiler values that will be used in future displacements.
     
     - Authors:
        - Steven DiGregorio

     - Parameters:
        - positioner: The name of the positioner
        - velocity: motion velocity (units/seconds)
        - acceleration: motion acceleration (units/seconds^2)
        - minimumJerkTime: Minimum jerk time (seconds)
        - maximumJerkTime: Maximum jerk time (seconds)
     
     # Example #
      ````
      // Setup Controller
      let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
     
      do {
          try controller?.positioner.SGamma.setParameters(positioner: "M.X", velocity: 1, acceleration: 1, minimumTjerkTime: 1, maximumTjerkTime: 1)
          print("Set SGamma parameters completed")
      } catch {
          print(error)
      }
       ````
     */
     func setParameters(positioner positionerName: String, velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double) throws {
        let command = "PositionerSGammaParametersSet(\(positionerName), \(velocity), \(acceleration), \(minimumTjerkTime), \(maximumTjerkTime))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
     }
    
    
    /**
     Gets the motion and the settling time
     
     Implements the  ````void PositionerSGammaPreviousMotionTimesGet( char PositionerName[250], double* SettingTime, double* SettlingTime)````  XPS Controller function.
     
     This function returns the motion (setting) and settling times from the previous motion. The motion time represents the defined time to complete the previous displacement. The settling time represents the effective settling time for a motion done.
     
     - Authors:
        - Steven DiGregorio

      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - Returns:
         - settingTime (seconds)
         - settlingTime (seconds)
     
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


