//
//  Extensions.swift
//  infnote
//
//  Created by Vergil Choi on 2018/10/27.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import Foundation


func - (lhs: Date, rhs: Date) -> DateComponents {
    return Calendar.current.dateComponents([.second, .minute, .hour, .day, .month], from: rhs, to: lhs)
}


extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        let now = Date()
        let diff = now - self
        
        if diff.month! > 2 {
            formatter.dateFormat = "YYYY-MM-dd"
        }
        else if diff.month! > 0 {
            return "\(diff.month!) 个月前"
        }
        else if diff.day! >= 8 {
            formatter.dateFormat = "MM-dd"
        }
        else if diff.day! > 0 && diff.day! < 8 {
            return "\(diff.day!) 天前"
        }
        else if diff.hour! > 0 {
            return "\(diff.hour!) 小时前"
        }
        else if diff.minute! > 0 {
            return "\(diff.minute!) 分钟前"
        }
        else if diff.second! > 0 {
            return "\(diff.second!) 秒前"
        }
        
        return formatter.string(from: self)
    }
}


extension Dictionary where Key == String {
    func flatten(with indent: Int = 0) -> String {
        let maxWidth = self.keys.reduce(0) { Swift.max($0, $1.count) }
        return self.reduce("") { result, item in
            var content = "\(item.value)"
            if let value = item.value as? [String: Any] {
                content = value.flatten(with: indent + 4)
            }
            if let value = item.value as? String, value.count > 200 {
                content = String(value[..<String.Index(encodedOffset: 200)])
            }
            let spaces = String(repeating: " ", count: maxWidth - item.key.count)
            let indent = String(repeating: " ", count: indent)
            return result + "\n\(indent)[\(item.key)\(spaces)] \(content)"
        }
    }
}
