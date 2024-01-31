//
//  RemoteConfigSource+Extensions.swift
//  
//
//  Created by Fumito Ito on 2024/01/25.
//

import Foundation
import FirebaseRemoteConfig
import OpenFeature

extension RemoteConfigSource {
    var reason: Reason {
        switch self {
        case .default:
            return .defaultReason
        case .remote:
            return .cached
        case .static:
            return .staticReason
        @unknown default:
            return .unknown
        }
    }
}
