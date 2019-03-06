//
//  Message.swift
//  MessageApp
//
//  Created by Tara Singh M C on 01/03/19.
//  Copyright © 2019 Tara Singh. All rights reserved.
//

import Foundation

// MessageKind will be either "Text" or "Graph"
public enum MessageKind {
    case text
    case graph
}

// Member
public struct Member {
    
    private var id: String
    private var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
}

// Message
public struct Message {
   
    private var sender: Member?
    private var kind: MessageKind
    public var text: String?
    public var date: Date
    public var isIncoming: Bool
    
    init(isIncoming: Bool, kind: MessageKind, date: Date, text: String?) {
        
        self.isIncoming = isIncoming
        self.kind = kind
        self.text = text
        self.date = date
        
    }

}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    static func customStringFromCustomDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from:date)
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
}
