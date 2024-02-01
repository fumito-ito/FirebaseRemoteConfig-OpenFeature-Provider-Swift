//
//  RemoteConfig+Extensions.swift
//
//
//  Created by Fumito Ito on 2024/02/01.
//

import FirebaseRemoteConfig

extension RemoteConfig: RemoteConfigCompatible {
    public func configValue(for key: String) -> RemoteConfigValueCompatible {
        configValue(forKey: key)
    }
}
