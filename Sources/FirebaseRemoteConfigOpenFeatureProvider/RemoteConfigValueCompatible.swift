//
//  RemoteConfigValueCompatible.swift
//
//
//  Created by Fumito Ito on 2024/02/01.
//

import Foundation
import FirebaseRemoteConfig

public protocol RemoteConfigValueCompatible {
    var stringValue: String? { get }
    var numberValue: NSNumber { get }
    var boolValue: Bool { get }
    var jsonValue: Any? { get }
    var source: RemoteConfigSource { get }
}
