//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Дмитрий on 19.07.2024.
//

import Foundation

@objc
final class DaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDays] else { return nil }
        let data = try? JSONEncoder().encode(days)
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDays].self, from: data as Data)
    }
    
    static func register() {
        let name = NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        ValueTransformer.setValueTransformer(DaysValueTransformer(), forName: name)
    }
}
