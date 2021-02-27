//
//  Data+Keychain.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation

extension Data {
  init<T>(from value: T) {
    var value = value
    self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }
    
  func to<T>(type: T.Type) -> T {
    return self.withUnsafeBytes { $0.load(as: T.self) }
  }
}
