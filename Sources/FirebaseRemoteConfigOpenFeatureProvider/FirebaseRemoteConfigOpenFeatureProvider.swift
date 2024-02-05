// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenFeature
import FirebaseRemoteConfig
import FirebaseCore

public let firebaseRemoteConfigOpenFeatureProviderStaleTimeIntervalKey = "firebaseRemoteConfigOpenFeatureProviderStaleTimeIntervalKey"
public let firebaseRemoteConfigOpenFeatureProviderOldContextKey = "firebaseRemoteConfigOpenFeatureProviderOldContextKey"
public let firebaseRemoteConfigOpenFeatureProviderNewContextKey = "firebaseRemoteConfigOpenFeatureProviderNewContextKey"

public final class FirebaseRemoteConfigOpenFeatureProvider: FeatureProvider {
    public private(set) var remoteConfig: RemoteConfigCompatible

    public var hooks: [any Hook] = []
    public let metadata: ProviderMetadata = FirebaseRemoteConfigOpenFeatureProviderMetadata()

    /// DateFormatter to format date value
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // swiftlint:disable:next force_unwrapping
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }()

    public private(set) var status: FirebaseRemoteConfigOpenFeatureProviderStatus = .notReady {
        didSet {
            switch status {
            case .notReady:
                break
            case .ready:
                emit(event: .ready)
            case .error:
                emit(event: .error)
            }
        }
    }

    public init(remoteConfig: RemoteConfigCompatible) {
        self.remoteConfig = remoteConfig
        updateStatus(for: remoteConfig)
        NotificationCenter.default.addObserver(self, selector: #selector(remoteConfigDidActivated), name: .onRemoteConfigActivated, object: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .onRemoteConfigActivated, object: nil)
    }
    
    public func initialize(initialContext: EvaluationContext?) {
        updateStatus(for: remoteConfig)
    }

    public func onContextSet(oldContext: EvaluationContext?, newContext: EvaluationContext) {
        initialize(initialContext: newContext)

        emit(event: .configurationChanged, details: [
            firebaseRemoteConfigOpenFeatureProviderOldContextKey: oldContext as Any,
            firebaseRemoteConfigOpenFeatureProviderNewContextKey: newContext as Any
        ])
    }

    func updateStatus(for remoteConfig: RemoteConfigCompatible) {
        switch remoteConfig.lastFetchStatus {
        case .noFetchYet:
            status = .notReady
        case .success, .throttled:
            status = .ready
        case .failure:
            status = .error
        @unknown default:
            status = .ready
        }
    }

    public func getBooleanEvaluation(key: String, defaultValue: Bool, context: EvaluationContext?) throws -> ProviderEvaluation<Bool> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return remoteConfig.configValue(for: key).toBooleanEvaluation
    }

    public func getStringEvaluation(key: String, defaultValue: String, context: EvaluationContext?) throws -> ProviderEvaluation<String> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return remoteConfig.configValue(for: key).toStringEvaluation
    }

    public func getIntegerEvaluation(key: String, defaultValue: Int64, context: EvaluationContext?) throws -> ProviderEvaluation<Int64> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return remoteConfig.configValue(for: key).toInt64Evaluation
    }

    public func getDoubleEvaluation(key: String, defaultValue: Double, context: EvaluationContext?) throws -> ProviderEvaluation<Double> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return remoteConfig.configValue(for: key).toDoubleEvaluation
    }

    public func getObjectEvaluation(key: String, defaultValue: Value, context: EvaluationContext?) throws -> ProviderEvaluation<Value> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return try remoteConfig.configValue(for: key).toObjectEvaluation
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    public func getDateEvaluation(key: String, defaultValue: Date, context: EvaluationContext?) throws -> ProviderEvaluation<Date> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return try remoteConfig.configValue(for: key).toDateEvaluation
    }

    public func getListEvaluation(key: String, defaultValue: [Value], context: EvaluationContext?) throws -> ProviderEvaluation<[Value]> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return try remoteConfig.configValue(for: key).toValueArrayEvaluation
    }

    public func getStructureEvaluation(key: String, defaultValue: [String: Value], context: EvaluationContext?) throws -> ProviderEvaluation<[String: Value]> {
        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return try remoteConfig.configValue(for: key).toValueStructureEvaluation
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    func emit(event: ProviderEvent, error: Error? = nil, details: [String: Any]? = nil) {
        OpenFeatureAPI.shared.emitEvent(event, provider: self, error: error, details: details)
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    @objc func remoteConfigDidActivated(notification: Notification) {
        // Make sure this key is consistent with kFIRGoogleAppIDKey in FirebaseCore SDK
        // see also https://github.com/firebase/firebase-ios-sdk/blob/main/FirebaseRemoteConfig/Swift/PropertyWrapper/RemoteConfigValueObservable.swift
        let firebaseRemoteConfigAppNameKey = "FIRAppNameKey"
        
        guard let appName = notification.userInfo?[firebaseRemoteConfigAppNameKey] as? String,
              FirebaseApp.app()?.name == appName else {
            return
        }
        
        if status != .ready {
            status = .ready
        }

        emit(event: .configurationChanged)
    }
}
