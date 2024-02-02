//
//  MockRemoteConfig.swift
//
//
//  Created by Fumito Ito on 2024/02/01.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigOpenFeatureProvider

struct MockRemoteConfig: RemoteConfigCompatible {
    var lastFetchTime: Date?
    
    var lastFetchStatus: RemoteConfigFetchStatus
    
    func configValue(for: String) -> RemoteConfigValueCompatible {
        MockRemoteConfigValue(
            stringValue: stringValueClosure(),
            numberValue: numberValueClosure(),
            boolValue: boolValueClosure(),
            jsonValue: jsonValueClosure(),
            source: remoteConfigSourceClosure()
        )
    }
    
    func allKeys(from: RemoteConfigSource) -> [String] {
        allKeysClosure()
    }

    private var stringValueClosure: () -> String?

    private var numberValueClosure: () -> NSNumber

    private var boolValueClosure: () -> Bool

    private var jsonValueClosure: () -> Any?

    private var allKeysClosure: () -> [String]

    private var remoteConfigSourceClosure: () -> RemoteConfigSource

    init(
        lastFetchTime: Date? = nil,
        lastFetchStatus: RemoteConfigFetchStatus = .noFetchYet,
        stringValueClosure: @escaping () -> String? = ({ () -> String? in "" }),
        numberValueClosure: @escaping () -> NSNumber = ({ () -> NSNumber in 0 }),
        boolValueClosure: @escaping () -> Bool = ({ () -> Bool in false }),
        jsonValueClosure: @escaping () -> Any? = ({ () -> Any? in nil }),
        allKeysClosure: @escaping () -> [String] = ({ () -> [String] in [] }),
        remoteConfigSourceClosure: @escaping () -> RemoteConfigSource = ({ () -> RemoteConfigSource in .remote })
    ) {
        self.lastFetchTime = lastFetchTime
        self.lastFetchStatus = lastFetchStatus
        self.stringValueClosure = stringValueClosure
        self.numberValueClosure = numberValueClosure
        self.boolValueClosure = boolValueClosure
        self.jsonValueClosure = jsonValueClosure
        self.allKeysClosure = allKeysClosure
        self.remoteConfigSourceClosure = remoteConfigSourceClosure
    }
}
