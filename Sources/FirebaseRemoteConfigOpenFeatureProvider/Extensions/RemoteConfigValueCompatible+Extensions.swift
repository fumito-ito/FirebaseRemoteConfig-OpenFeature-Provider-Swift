//
//  RemoteConfigValueCompatible+Extensions.swift
//  
//
//  Created by Fumito Ito on 2024/01/25.
//

import Foundation
import FirebaseRemoteConfig
import OpenFeature

extension RemoteConfigValueCompatible {
    var toBooleanEvaluation: ProviderEvaluation<Bool> {
        .init(value: boolValue, variant: "\(boolValue)", reason: source.reason.rawValue)
    }

    var toStringEvaluation: ProviderEvaluation<String> {
        guard let value = stringValue else {
            return .init(value: "", variant: "", reason: Reason.staticReason.rawValue)
        }

        return .init(value: value, variant: stringValue, reason: source.reason.rawValue)
    }

    var toInt64Evaluation: ProviderEvaluation<Int64> {
        .init(value: numberValue.int64Value, variant: "\(numberValue.int64Value)", reason: source.reason.rawValue)
    }

    var toDoubleEvaluation: ProviderEvaluation<Double> {
        .init(value: numberValue.doubleValue, variant: "\(numberValue.doubleValue)", reason: source.reason.rawValue)
    }

    var toDateEvaluation: ProviderEvaluation<Date> {
        get throws {
            guard let dateString = stringValue else {
                throw OpenFeatureError.parseError(message: "指定されたキーから文字列を取得することができない")
            }

            guard let date = FirebaseRemoteConfigOpenFeatureProvider.dateFormatter.date(from: dateString) else {
                throw OpenFeatureError.parseError(message: "指定されたキーから取得した文字列を日付に変換することができない")
            }

            return .init(
                value: date,
                variant: FirebaseRemoteConfigOpenFeatureProvider.dateFormatter.string(from: date),
                reason: source.reason.rawValue
            )
        }
    }

    var toValueArrayEvaluation: ProviderEvaluation<[Value]> {
        get throws {
            guard let jsonValue else {
                throw OpenFeatureError.parseError(message: "指定されたキーからJSONオブジェクトを取得することができない")
            }

            guard let array = jsonValue as? [Any] else {
                throw OpenFeatureError.parseError(message: "指定されたキーから配列を取得することができない")
            }

            let valuedArray = try array.wrapInValue()

            return .init(value: valuedArray, variant: valuedArray.description, reason: source.reason.rawValue)
        }
    }

    var toValueStructureEvaluation: ProviderEvaluation<[String: Value]> {
        get throws {
            guard let jsonValue else {
                throw OpenFeatureError.parseError(message: "指定されたキーからJSONオブジェクトを取得することができない")
            }

            guard let dictionary = jsonValue as? [String: Any] else {
                throw OpenFeatureError.parseError(message: "指定されたキーからディクショナリを取得することができない")
            }

            let valuedDictionary = try dictionary.wrapInValue()

            return .init(value: valuedDictionary, variant: valuedDictionary.description, reason: source.reason.rawValue)
        }
    }

    var toObjectEvaluation: ProviderEvaluation<Value> {
        get throws {
            let value: Value

            switch (jsonValue as? [Any], jsonValue as? [String: Any], stringValue) {
            case (let .some(array), _, _):
                value = .list(try array.wrapInValue())
            case (_, let .some(dictionary), _):
                value = .structure(try dictionary.wrapInValue())
            case (_, _, let .some(unwrappedString)):
                switch (
                    FirebaseRemoteConfigOpenFeatureProvider.dateFormatter.date(from: unwrappedString),
                    Int64(unwrappedString),
                    Double(unwrappedString),
                    Bool(unwrappedString)
                ) {
                case (let .some(date), _, _, _):
                    value = .date(date)
                case (_, let .some(int), _, _):
                    value = .integer(int)
                case (_, _, let .some(double), _):
                    value = .double(double)
                case (_, _, _, let .some(bool)):
                    value = .boolean(bool)
                case (.none, .none, .none, .none):
                    value = .string(unwrappedString)
                }
            case (.none, .none, .none):
                value = .null
            }

            return .init(value: value, variant: value.description, reason: source.reason.rawValue)
        }
    }
}
