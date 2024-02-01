//
//  RemoteConfigCompatible.swift
//  
//
//  Created by Fumito Ito on 2024/02/01.
//

import Foundation
import FirebaseRemoteConfig

public protocol RemoteConfigCompatible {
    var lastFetchTime: Date? { get }
    var lastFetchStatus: RemoteConfigFetchStatus { get }
    func configValue(for: String) -> RemoteConfigValueCompatible
    func allKeys(from: RemoteConfigSource) -> [String]
}
