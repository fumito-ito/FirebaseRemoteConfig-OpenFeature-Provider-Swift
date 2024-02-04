//
//  Notification.Name+Extensions.swift
//
//
//  Created by 伊藤史 on 2024/02/04.
//

import Foundation

// FirebaseRemoteConfig internal notification name, see also https://github.com/firebase/firebase-ios-sdk/blob/main/FirebaseRemoteConfig/Swift/PropertyWrapper/RemoteConfigValueObservable.swift
extension Notification.Name {
    // Listens to FirebaseRemoteConfig SDK if new configs are activated.
    static let onRemoteConfigActivated = Notification.Name("FIRRemoteConfigActivateNotification")
}
