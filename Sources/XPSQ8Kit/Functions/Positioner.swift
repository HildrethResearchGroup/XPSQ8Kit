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
public extension XPSQ8Controller.GroupController {
    
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
     Disable the backlash
     
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
    func disableBacklash(positioner positionerName: String) throws {
        let command = "PositionerBacklashDisable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
     Enable the backlash
     
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
    func enableBacklash(positioner positionerName: String) throws {
        let command = "PositionerBacklashEnable(\(positionerName))"
        try controller.communicator.write(string: command)
        try controller.communicator.validateNoReturn()
    }
    
    /**
       Return positioner hardware status code
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
      
       - returns:
          -  status: positioner hardware status code

       - parameters:
         - positionerName: The name of the stage that will be moved.
       
       # Example #
       ````
       // Setup Controller
       let controller = XPSQ8Controller(address: "192.168.0.254", port: 5001)
       
       do {
          let data = try controller?.group.enableMotion(stage: "M.X")
       } catch {print(error)}
       ````
      */
      func getHardwareStatus(positioner positionerName: String) throws -> Int {
          let command = "PositionerHardwareStatusGet(\(positionerName), int *)"
          try controller.communicator.write(string: command)
          let status = try controller.communicator.read(as: (Int.self))
          return (status)
      }
    
    /**
    Return maximum velocity and acceleration of the positioner
     
      Implements  the ```` add here ```` XPS function
     
     - Author: Steven DiGregorio
     
      - Parameters:
         - positioner: The name of the positioner that will be moved.
     
      - returns:
         -  velocity: Maximum velocity
         - acceleration: Maximum acceleration
     
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
     func getMaximumVelocityAndAcceleration(positioner positionerName: String) throws -> (velocity: Double, acceleration: Double) {
        let command = "PositionerMaximumVelocityAndAccelerationGet(\(positionerName), Double *, Double *)"
        try controller.communicator.write(string: command)
        let maximums = try controller.communicator.read(as: (Double.self, Double.self))
        return (velocity: maximums.0, acceleration: maximums.1)
     }
    
    /**
    Read motion done parameters
     
      Implements  the ```` add here ```` XPS function
     
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
        let command = "PositionerMotionDoneGet(\(positionerName), Double *, Double *, Double *, Double *, Double *)"
        try controller.communicator.write(string: command)
        let motionDone = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self, Double.self))
        return (positionWindow: motionDone.0, velocityWindow: motionDone.1, checkingTime: motionDone.2, meanPeriod: motionDone.3, timeout: motionDone.4)
     }
    
    /**
    Return the stage parameter

      Implements  the ```` add here ```` XPS function
     
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
//     func getStageParameter(positioner positionerName: String) throws -> String {
//        let command = "PositionerStageParameterGet(\(positionerName), Double *, Double *, Double *, Double *, Double *)"
//        try controller.communicator.write(string: command)
//        let motionDone = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self, Double.self))
//        return (positionWindow: motionDone.0, velocityWindow: motionDone.1, checkingTime: motionDone.2, meanPeriod: motionDone.3, timeout: motionDone.4)
//     }
    
    /**
    Read user minimum target and user maximum target
     
      Implements  the ```` add here ```` XPS function
     
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
     func getUserTravelLimits(positioner positionerName: String) throws -> (userMinimumTarget: Double, userMaximumTarget: Double) {
        let command = "PositionerUserTravelLimitsGet(\(positionerName), Double *, Double *)"
        try controller.communicator.write(string: command)
        let targets = try controller.communicator.read(as: (Double.self, Double.self))
        return (userMinimumTarget: targets.0, userMaximumTarget: targets.1)
     }

}


// MARK: - Positioner.SGamma Functions
public extension XPSQ8Controller.PositionerController.SGammaController {
    
    /**
    Read dynamic parameters for one axe of a group for a future displacement
     
      Implements  the ```` add here ```` XPS function
     
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
     
      // use moveRelative function
        do {
         let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
        } catch {print(error)}
       ````
     */
     func getParameters(positioner positionerName: String) throws -> (velocity: Double, acceleration: Double, minimumTjerkTime: Double, maximumTjerkTime: Double) {
        let command = "PositionerSGammaParametersGet(\(positionerName), Double *, Double *, Double *, Double *)"
        try controller.communicator.write(string: command)
        let parameters = try controller.communicator.read(as: (Double.self, Double.self, Double.self, Double.self))
        return (velocity: parameters.0, acceleration: parameters.1, minimumTjerkTime: parameters.2, maximumTjerkTime: parameters.3)
     }
    
    /**
    Read setting time and settling time
     
      Implements  the ```` add here ```` XPS function
     
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
     
      // use moveRelative function
        do {
         let data = try controller?.group.moveRelative(stage: "M.X", byDisplacement: 10)
        } catch {print(error)}
       ````
     */
     func getPreviousMotionTimes(positioner positionerName: String) throws -> (setting: Double, settling: Double) {
        let command = "PositionerSGammaParametersGet(\(positionerName), Double *, Double *)"
        try controller.communicator.write(string: command)
        let times = try controller.communicator.read(as: (Double.self, Double.self))
        return (setting: times.0, settling: times.1)
     }
}


