//
//  Decoding.swift
//  
//
//  Created by Connor Barnes on 12/20/19.
//

import Foundation

protocol XPSQ8Decodable {
  init(xpsq8String: String) throws
}

// MARK: - String Decoding
extension String: XPSQ8Decodable {
  init(xpsq8String: String) throws {
    self = xpsq8String
  }
}

// MARK: - Int Decoding
extension Int: XPSQ8Decodable {
  init(xpsq8String: String) throws {
    guard let integer = Int(xpsq8String) else { throw XPSQ8Communicator.Error.couldNotDecode }
    self = integer
  }
}

// MARK: - Double Decoding
extension Double: XPSQ8Decodable {
  init(xpsq8String: String) throws {
    guard let double = Double(xpsq8String) else { throw XPSQ8Communicator.Error.couldNotDecode }
    self = double
  }
}

// MARK: - Components
private extension XPSQ8Communicator {
  func readComponents() async throws -> [String] {
    let (message, code) = try await read()
    guard code == 0 else { throw Error.couldNotDecode }
    
    return message.split(separator: ",").map { String($0) }
  }
}

// MARK: - Reading
extension XPSQ8Communicator {
  /// Called when writing a message that does not return a value. This ensures that a code of 0 was received.
  func validateNoReturn() async throws {
    let components = try await readComponents()
    guard components.isEmpty else { throw Error.couldNotDecode }
  }
  
  /// Read for 1 variadic components.
  func read<T: XPSQ8Decodable>(as: T.Type) async throws -> T {
    let components = try await readComponents()
    guard components.count == 1 else { throw Error.couldNotDecode }
    
    return try T.init(xpsq8String: components[0])
  }
  
  /// Read for 2 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable>(as: (T0.Type, T1.Type)) async throws -> (T0, T1) {
    let components = try await readComponents()
    guard components.count == 2 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String: components[0]),
                T1.init(xpsq8String: components[1]))
  }
  
  /// Read for 3 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type)) async throws -> (T0, T1, T2) {
    let components = try await readComponents()
    guard components.count == 3 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String: components[0]),
                T1.init(xpsq8String: components[1]),
                T2.init(xpsq8String: components[2]))
  }
  
  
  /// Read for 4 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type)) async throws -> (T0, T1, T2, T3) {
    let components = try await readComponents()
    guard components.count == 4 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String: components[0]),
                T1.init(xpsq8String: components[1]),
                T2.init(xpsq8String: components[2]),
                T3.init(xpsq8String: components[3]))
  }
  
  
  /// Read for 5 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type)) async throws -> (T0, T1, T2, T3, T4) {
    let components = try await readComponents()
    guard components.count == 5 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String: components[0]),
                T1.init(xpsq8String: components[1]),
                T2.init(xpsq8String: components[2]),
                T3.init(xpsq8String: components[3]),
                T4.init(xpsq8String: components[4]))
  }
  
  
  /// Read for 6 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type)) async throws -> (T0, T1, T2, T3, T4, T5) {
    let components = try await readComponents()
    guard components.count == 6 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String: components[0]),
                T1.init(xpsq8String: components[1]),
                T2.init(xpsq8String: components[2]),
                T3.init(xpsq8String: components[3]),
                T4.init(xpsq8String: components[4]),
                T5.init(xpsq8String: components[5]))
  }
  
  
  /// Read for 7 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6) {
    let components = try await readComponents()
    guard components.count == 7 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]))
  }
  
  
  /// Read for 8 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7) {
    let components = try await readComponents()
    guard components.count == 8 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]))
  }
  
  
  /// Read for 9 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8) {
    let components = try await readComponents()
    guard components.count == 9 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]))
  }
  
  
  /// Read for 10 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) {
    let components = try await readComponents()
    guard components.count == 10 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]))
  }
}
  
  /*

  /// Read for 11 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) {
    let components = try await readComponents()
    guard components.count == 11 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]))
  }
  
  
  /// Read for 12 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable, T11: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type, T11.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) {
    let components = try await readComponents()
    guard components.count == 12 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]),
                T11.init(xpsq8String:components[11]))
  }
  
  
  /// Read for 13 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable, T11: XPSQ8Decodable, T12: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type, T11.Type, T12.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) {
    let components = try await readComponents()
    guard components.count == 13 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]),
                T11.init(xpsq8String:components[11]),
                T12.init(xpsq8String:components[12]))
  }
  
  /// Read for 14 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable, T11: XPSQ8Decodable, T12: XPSQ8Decodable, T13: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type, T11.Type, T12.Type, T13.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) {
    let components = try await readComponents()
    guard components.count == 14 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]),
                T11.init(xpsq8String:components[11]),
                T12.init(xpsq8String:components[12]),
                T13.init(xpsq8String:components[13]))
  }
  
  /// Read for 15 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable, T11: XPSQ8Decodable, T12: XPSQ8Decodable, T13: XPSQ8Decodable, T14: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type, T11.Type, T12.Type, T13.Type, T14.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) {
    let components = try await readComponents()
    guard components.count == 15 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]),
                T11.init(xpsq8String:components[11]),
                T12.init(xpsq8String:components[12]),
                T13.init(xpsq8String:components[13]),
                T14.init(xpsq8String:components[14]))
  }
  
  /// Read for 16 variadic components.
  func read<T0: XPSQ8Decodable, T1: XPSQ8Decodable, T2: XPSQ8Decodable, T3: XPSQ8Decodable, T4: XPSQ8Decodable, T5: XPSQ8Decodable, T6: XPSQ8Decodable, T7: XPSQ8Decodable, T8: XPSQ8Decodable, T9: XPSQ8Decodable, T10: XPSQ8Decodable, T11: XPSQ8Decodable, T12: XPSQ8Decodable, T13: XPSQ8Decodable, T14: XPSQ8Decodable, T15: XPSQ8Decodable>(as: (T0.Type, T1.Type, T2.Type, T3.Type, T4.Type, T5.Type, T6.Type, T7.Type, T8.Type, T9.Type, T10.Type, T11.Type, T12.Type, T13.Type, T14.Type, T15.Type)) async throws -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) {
    let components = try await readComponents()
    guard components.count == 16 else { throw Error.couldNotDecode }
    
    return try (T0.init(xpsq8String:components[0]),
                T1.init(xpsq8String:components[1]),
                T2.init(xpsq8String:components[2]),
                T3.init(xpsq8String:components[3]),
                T4.init(xpsq8String:components[4]),
                T5.init(xpsq8String:components[5]),
                T6.init(xpsq8String:components[6]),
                T7.init(xpsq8String:components[7]),
                T8.init(xpsq8String:components[8]),
                T9.init(xpsq8String:components[9]),
                T10.init(xpsq8String:components[10]),
                T11.init(xpsq8String:components[11]),
                T12.init(xpsq8String:components[12]),
                T13.init(xpsq8String:components[13]),
                T14.init(xpsq8String:components[14]),
                T15.init(xpsq8String:components[15]))
  }
*/
