//
//  MessageConversation.swift
//  MessageApp
//
//  Created by Tara Singh M C on 01/03/19.
//  Copyright © 2019 Tara Singh. All rights reserved.
//

import UIKit
import CoreData

public class MessageConversation {
    
    
    // Stores Messages
   // private var groupDateBy: [String:[ChatbotMessage]] = [:]
    /*[
     Message(isIncoming: false, kind: .text, date: Date(), text: "Here's my first message"),
     Message(isIncoming: true, kind: .text, date: Date(), text: "I'm going to message another long message that will more wrap."),
     Message(isIncoming: false, kind: .text, date: Date(), text: "A very common task in iOS is to provide auto sizing cells for UITableView components. In today's lesson we look at how to implement a custom cell that provides auto sizing using anchor constraints.  This technique is very easy and requires very little customization. Enjoy."),
     Message(isIncoming: true, kind: .text, date: Date(), text: "Yo, dawg, Whaddup!")
     ]*/
    
    
    private var chatbotMessages = [[ChatbotMessage]]()
    
    // Retuns message count
 
    
    // Insert Message
    open func insert(text: String?, isIncoming: Bool, date: Date,  completionHandler: ((Bool) -> Void)? = nil) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completionHandler?(false)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        guard let chatbotMessageEntity = NSEntityDescription.entity(forEntityName: "ChatbotMessage", in: managedContext),  let chatbotMessage = NSManagedObject(entity: chatbotMessageEntity, insertInto: managedContext) as? ChatbotMessage else {
            completionHandler?(false)
            return
        }
        //messages.append(message)
        chatbotMessage.setValue(text, forKey: "text")
        chatbotMessage.setValue(date, forKey: "date")
        chatbotMessage.setValue(isIncoming, forKey: "isIncoming")
        
        do {
            try managedContext.save()

            if self.chatbotMessages.count == 0 {
                
                let newChatbotMessages : [ChatbotMessage] = [chatbotMessage]
                self.chatbotMessages.append(newChatbotMessages)
                
            } else {
                
                // Append object to last section array
                self.chatbotMessages[self.chatbotMessages.count-1].append(chatbotMessage)

                
            }


            completionHandler?(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completionHandler?(false)
        }
        
        
    }
    
    public func fetchData(_ completionHandler: ((Bool) -> Void)? = nil) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completionHandler?(false)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let chatbotMessageFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatbotMessage")
        // chatbotMessageFetch.returnsObjectsAsFaults = false
        //chatbotMessageFetch.predicate = NSPredicate(format: "name = %@", "John")
        //chatbotMessageFetch.propertiesToGroupBy = ["date","text"]
      //  chatbotMessageFetch.propertiesToFetch = ["date", "text"]
        
//        chatbotMessageFetch.propertiesToFetch = ["info1", "info2"]
     //chatbotMessageFetch.includesSubentities = true
//        
       // chatbotMessageFetch.resultType = .dictionaryResultType
        do {
            let chatbotMessages = try managedContext.fetch(chatbotMessageFetch) as? [ChatbotMessage]
       
            if let chatbotMessages = chatbotMessages {
//                let groupDateBy = Dictionary(grouping: chatbotMessages) {$0.date}
                
                
                
                let groupedMessages = Dictionary(grouping: chatbotMessages) { (element) -> Date in
                    return element.date!.reduceToMonthDayYear()
                }
                
                // provide a sorting for your keys somehow
                let sortedKeys = groupedMessages.keys.sorted()
                sortedKeys.forEach { (key) in
                    let values = groupedMessages[key]
                    self.chatbotMessages.append(values ?? [])
                }
                
//                for dict in groupDateBy {
//
//                    let values = dict.value
//
//                    self.chatbotMessages.append(values)
//                }

            }



            completionHandler?(true)
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
            completionHandler?(false)

        }
   
        
    }
    
    public func getMessageForSection(_ section: Int) -> ChatbotMessage? {
        
        guard section < chatbotMessages.count, chatbotMessages[section].count >= 1 else {
            return nil
        }
        
        
        return chatbotMessages[section][0]
    }
    
    public func getMessageForIndex(_ indexPath: IndexPath) -> ChatbotMessage? {
        
        guard indexPath.section < chatbotMessages.count, indexPath.row < chatbotMessages[indexPath.section].count else {
            return nil
        }
        
        
        return chatbotMessages[indexPath.section][indexPath.row]
    }
    
    
    public func sectionCount() -> Int {
        return chatbotMessages.count
    }
    
    public func rowCountAtSection(_ section: Int) -> Int {
        return chatbotMessages[section].count
    }
}
