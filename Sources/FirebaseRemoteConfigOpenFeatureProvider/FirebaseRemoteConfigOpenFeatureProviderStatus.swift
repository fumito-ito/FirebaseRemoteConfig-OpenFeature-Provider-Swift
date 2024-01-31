//
//  FirebaseRemoteConfigOpenFeatureProviderStatus.swift
//
//
//  Created by Fumito Ito on 2024/01/25.
//

import Foundation

public enum FirebaseRemoteConfigOpenFeatureProviderStatus: String {
    case notReady = "NOT_READY"
    case ready = "READY"
    case stale = "STALE"
    case error = "ERROR"
}
