//
//  File.swift
//  
//
//  Created by Connor Barnes on 12/20/19.
//

// MARK: Types

public extension XPSQ8Controller {
	struct GlobalController {
		var controller: XPSQ8Controller
		
		public struct DoubleArrayController {
			var controller: XPSQ8Controller
		}
		
		public struct StringArrayController {
			var controller: XPSQ8Controller
		}
	}
}

// MARK: - Access Arrays Namespace
public extension XPSQ8Controller {
	/// The set of commands dealing with globals.
	var global: GlobalController {
		return GlobalController(controller: self)
	}
}

public extension XPSQ8Controller.GlobalController {
	/// The set of commands dealing with the global double array.
	var doubleArray: DoubleArrayController {
		return DoubleArrayController(controller: controller)
	}
	
	/// The set of commands dealing with the global string array.
	var stringArray: StringArrayController {
		return StringArrayController(controller: controller)
	}
}


// MARK: - Arrays Functions
public extension XPSQ8Controller.GlobalController.DoubleArrayController {
	/// Gets a value in the global double array at the given index.
	/// - Parameter index: The index of the array.
	func get(at index: Int) throws -> Double {
		try controller.communicator.write(string: "DoubleGlobalArrayGet(\(index),double *)")
		return try controller.communicator.read(as: Double.self)
	}
	
	/// Sets a value in the global double array at the given index.
	/// - Parameters:
	///   - value: The new value to set.
	///   - index: The index of the array.
	func set(to value: Double, at index: Int) throws {
		try controller.communicator.write(string: "DoubleGlobalArraySet(\(index),\(value))")
		try controller.communicator.validateNoReturn()
	}
}


public extension XPSQ8Controller.GlobalController.StringArrayController {
	func get(at index: Int) throws -> String {
		// TODO: The 'char *' portion may be incorrect, this needs to be tested in the lab
		try controller.communicator.write(string: "GlobalArrayGet(\(index)),char *")
		return try controller.communicator.read(as: String.self)
	}
	
	func set(to value: String, at index: Int) throws {
		try controller.communicator.write(string: "GlobalArraySet(\(index),\(value))")
		try controller.communicator.validateNoReturn()
	}
}
