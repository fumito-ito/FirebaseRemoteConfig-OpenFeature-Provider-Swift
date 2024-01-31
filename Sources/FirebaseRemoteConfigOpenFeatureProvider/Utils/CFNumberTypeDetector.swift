//
//  CFNumberTypeDetector.swift
//
//
//  Created by Fumito Ito on 2024/01/24.
//

import Foundation

enum CFNumberTypeDetector {
    enum DetectedType {
        case integer
        case double
        case unknown
    }

    static func detectType(from number: CFNumber) -> DetectedType {
        let numberType = CFNumberGetType(number)
        switch numberType {
        case
            .sInt8Type,
            .sInt16Type,
            .sInt32Type,
            .sInt64Type,
            .charType,
            .shortType,
            .intType,
            .longType,
            .longLongType,
            .cfIndexType,
            .nsIntegerType:
            return .integer

        case
            .float32Type,
            .float64Type,
            .floatType,
            .doubleType,
            .cgFloatType:
            return .double

        @unknown default:
            return .unknown
        }
    }
}
