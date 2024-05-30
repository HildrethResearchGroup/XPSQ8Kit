//
//  Arrays.swift
//  
//
//  Created by Connor Barnes on 12/20/19.
//

public extension XPSQ8Controller {
  /// A namespace for global commands.
  struct Global {
    var controller: XPSQ8Controller
    
    /// A namespace for commands dealing with the global double array.
    public struct DoubleArray {
      var controller: XPSQ8Controller
    }
    
    /// A namespace for commands dealing with the global string array.
    public struct StringArray {
      var controller: XPSQ8Controller
    }
  }
}

// MARK: - Access Arrays Namespace
public extension XPSQ8Controller {
  /// The set of commands dealing with globals.
  var global: Global {
    return Global(controller: self)
  }
}

public extension XPSQ8Controller.Global {
  /// The set of commands dealing with the global double array.
  var doubleArray: DoubleArray {
    return DoubleArray(controller: controller)
  }
  
  /// The set of commands dealing with the global string array.
  var stringArray: StringArray {
    return StringArray(controller: controller)
  }
}


// MARK: - Double Array Functions
public extension XPSQ8Controller.Global.DoubleArray {
  /// Gets a value in the global double array at the given index.
  /// - Parameter index: The index of the array.
  func get(at index: Int) async throws -> Double {
    try await controller.communicator.write(string: "DoubleGlobalArrayGet(\(index),double *)")
    return try await controller.communicator.read(as: Double.self)
  }
  
  /// Sets a value in the global double array at the given index.
  /// - Parameters:
  ///   - value: The new value to set.
  ///   - index: The index of the array.
  func set(to value: Double, at index: Int) async throws {
    try await controller.communicator.write(string: "DoubleGlobalArraySet(\(index),\(value))")
    try await controller.communicator.validateNoReturn()
  }
}

// MARK: - String Array Functions
public extension XPSQ8Controller.Global.StringArray {
  /// Gets a value in the global string array at the given index.
  /// - Parameter index: The index of the array.
  func get(at index: Int) async throws -> String {
    // TODO: The 'char *' portion may be incorrect, this needs to be tested in the lab
    try await controller.communicator.write(string: "GlobalArrayGet(\(index)),char *")
    return try await controller.communicator.read(as: String.self)
  }
  
  /// Sets a value in the global string array at the given index.
  /// - Parameters:
  ///   - value: The new value to set.
  ///   - index: The index of the array.
  func set(to value: String, at index: Int) async throws {
    try await controller.communicator.write(string: "GlobalArraySet(\(index),\(value))")
    try await controller.communicator.validateNoReturn()
  }
}
