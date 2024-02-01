//
//  RemoteConfigCompatible+Extensions.swift
//
//
//  Created by Fumito Ito on 2024/01/25.
//

import FirebaseRemoteConfig

extension RemoteConfigCompatible {
    func has(key: String) -> Bool {
        allKeys(from: .remote).contains(key) || allKeys(from: .default).contains(key)
    }
}
