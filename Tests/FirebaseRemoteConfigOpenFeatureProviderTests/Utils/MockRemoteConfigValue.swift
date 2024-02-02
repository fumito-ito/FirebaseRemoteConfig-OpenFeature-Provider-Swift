//
//  MockRemoteConfigValue.swift
//
//
//  Created by Fumito Ito on 2024/02/01.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigOpenFeatureProvider

struct MockRemoteConfigValue: RemoteConfigValueCompatible {
    var stringValue: String?

    var numberValue: NSNumber

    var boolValue: Bool

    var jsonValue: Any?

    var source: RemoteConfigSource

    init(stringValue: String? = nil, numberValue: NSNumber, boolValue: Bool, jsonValue: Any? = nil, source: RemoteConfigSource) {
        self.stringValue = stringValue
        self.numberValue = numberValue
        self.boolValue = boolValue
        self.jsonValue = jsonValue
        self.source = source
    }
}
