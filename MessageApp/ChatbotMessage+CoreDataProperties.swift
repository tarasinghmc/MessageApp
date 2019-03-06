//
//  ChatbotMessage+CoreDataProperties.swift
//  
//
//  Created by Tara Singh M C on 03/03/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ChatbotMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatbotMessage> {
        return NSFetchRequest<ChatbotMessage>(entityName: "ChatbotMessage")
    }

    @NSManaged public var date: Date?
    @NSManaged public var graphData: Data?
    @NSManaged public var isGraph: Bool
    @NSManaged public var isIncoming: Bool
    @NSManaged public var text: String?

}
