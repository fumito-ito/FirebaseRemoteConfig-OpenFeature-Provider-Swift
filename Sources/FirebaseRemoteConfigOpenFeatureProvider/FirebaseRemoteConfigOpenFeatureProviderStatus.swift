//
//  FirebaseRemoteConfigOpenFeatureProviderStatus.swift
//
//
//  Created by Fumito Ito on 2024/01/25.
//

import Foundation

/// Status of provider
///
/// Note: This provider and RemoteConfig does not support `STALED` status.
public enum FirebaseRemoteConfigOpenFeatureProviderStatus: String {
    case notReady = "NOT_READY"
    case ready = "READY"
    case error = "ERROR"
}
