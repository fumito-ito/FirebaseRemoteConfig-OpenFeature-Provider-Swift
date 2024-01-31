// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenFeature
import FirebaseRemoteConfig

public let firebaseRemoteConfigOpenFeatureProviderStaleTimeIntervalKey = "firebaseRemoteConfigOpenFeatureProviderStaleTimeIntervalKey"
public let firebaseRemoteConfigOpenFeatureProviderOldContextKey = "firebaseRemoteConfigOpenFeatureProviderOldContextKey"
public let firebaseRemoteConfigOpenFeatureProviderNewContextKey = "firebaseRemoteConfigOpenFeatureProviderNewContextKey"

public final class FirebaseRemoteConfigOpenFeatureProvider: FeatureProvider {
    public private(set) var remoteConfig: RemoteConfig
    public private(set) var timeIntervalUntilStale: TimeInterval

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
            case .stale:
                emit(event: .stale)
            case .error:
                emit(event: .error)
            }
        }
    }

    public init(remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
        self.timeIntervalUntilStale = remoteConfig.configSettings.minimumFetchInterval
        updateStatus(for: remoteConfig, timeIntervalUntilStale: remoteConfig.configSettings.minimumFetchInterval)
    }

    public func initialize(initialContext: EvaluationContext?) {
        if case .double(let timeIntervalUntilStale) = initialContext?.getValue(key: firebaseRemoteConfigOpenFeatureProviderStaleTimeIntervalKey) {
            self.timeIntervalUntilStale = timeIntervalUntilStale
            updateStatus(for: remoteConfig, timeIntervalUntilStale: timeIntervalUntilStale)
        }
    }

    public func onContextSet(oldContext: EvaluationContext?, newContext: EvaluationContext) {
        initialize(initialContext: newContext)

        emit(event: .configurationChanged, details: [
            firebaseRemoteConfigOpenFeatureProviderOldContextKey: oldContext as Any,
            firebaseRemoteConfigOpenFeatureProviderNewContextKey: newContext as Any
        ])
    }

    func updateStatus(for remoteConfig: RemoteConfig, timeIntervalUntilStale: TimeInterval) {
        switch remoteConfig.lastFetchStatus {
        case .noFetchYet:
            status = .notReady
        case .success, .throttled:
            let lastFetchTime = remoteConfig.lastFetchTime ?? Date()
            if lastFetchTime.timeIntervalSinceNow > timeIntervalUntilStale {
                status = .stale
            } else {
                status = .ready
            }
        case .failure:
            status = .error
        @unknown default:
            status = .ready
        }
    }

    public func getBooleanEvaluation(key: String, defaultValue: Bool, context: EvaluationContext?) throws -> ProviderEvaluation<Bool> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return remoteConfig.configValue(forKey: key).toBooleanEvaluation
    }

    public func getStringEvaluation(key: String, defaultValue: String, context: EvaluationContext?) throws -> ProviderEvaluation<String> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return remoteConfig.configValue(forKey: key).toStringEvaluation
    }

    public func getIntegerEvaluation(key: String, defaultValue: Int64, context: EvaluationContext?) throws -> ProviderEvaluation<Int64> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return remoteConfig.configValue(forKey: key).toInt64Evaluation
    }

    public func getDoubleEvaluation(key: String, defaultValue: Double, context: EvaluationContext?) throws -> ProviderEvaluation<Double> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return remoteConfig.configValue(forKey: key).toDoubleEvaluation
    }

    public func getObjectEvaluation(key: String, defaultValue: Value, context: EvaluationContext?) throws -> ProviderEvaluation<Value> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return try remoteConfig.configValue(forKey: key).toObjectEvaluation
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    public func getDateEvaluation(key: String, defaultValue: Date, context: EvaluationContext?) throws -> ProviderEvaluation<Date> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return try remoteConfig.configValue(forKey: key).toDateEvaluation
    }

    public func getListEvaluation(key: String, defaultValue: [Value], context: EvaluationContext?) throws -> ProviderEvaluation<[Value]> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return try remoteConfig.configValue(forKey: key).toValueArrayEvaluation
    }

    public func getStructureEvaluation(key: String, defaultValue: [String: Value], context: EvaluationContext?) throws -> ProviderEvaluation<[String: Value]> {
        let remoteConfig = try getRemoteConfigIfContains(key: key, with: context)

        return try remoteConfig.configValue(forKey: key).toValueStructureEvaluation
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    private func getRemoteConfig(with context: EvaluationContext?) -> RemoteConfig {
        // TODO: contextを考慮して取得する
        remoteConfig
    }

    private func getRemoteConfigIfContains(key: String, with context: EvaluationContext?) throws -> RemoteConfig {
        let remoteConfig = getRemoteConfig(with: context)

        guard remoteConfig.has(key: key) else {
            throw OpenFeatureError.flagNotFoundError(key: key)
        }

        return remoteConfig
    }
}

extension FirebaseRemoteConfigOpenFeatureProvider {
    func emit(event: ProviderEvent, error: Error? = nil, details: [String: Any]? = nil) {
        OpenFeatureAPI.shared.emitEvent(event, provider: self, error: error, details: details)
    }
}
