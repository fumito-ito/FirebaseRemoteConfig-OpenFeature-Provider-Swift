//
//  TypeDetector.swift
//
//
//  Created by Fumito Ito on 2024/01/24.
//

import Foundation

enum TypeDetector {
    enum DetectedType {
        case boolean
        case string
        case integer
        case double
        case date
        case array
        case dictionary
        case null
        case unknown
    }

    static func detectType(from object: Any) -> DetectedType {
        switch CFGetTypeID(object as CFTypeRef) {
        case CFBooleanGetTypeID():
            return .boolean

        case CFStringGetTypeID():
            return .string

        case CFNumberGetTypeID():
            // swiftlint:disable:next force_cast
            let number = object as! CFNumber
            switch CFNumberTypeDetector.detectType(from: number) {
            case .integer:
                return .integer

            case .double:
                return .double

            case .unknown:
                return .unknown
            }

        case CFDateGetTypeID():
            return .date

        case CFArrayGetTypeID():
            return .array

        case CFDictionaryGetTypeID():
            return .dictionary

        case CFNullGetTypeID():
            return .null

        default:
            return .unknown
        }
    }
}

