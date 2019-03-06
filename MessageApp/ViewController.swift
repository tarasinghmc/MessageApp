//
//  ViewController.swift
//  MessageApp
//
//  Created by Tara Singh M C on 01/03/19.
//  Copyright © 2019 Tara Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textInputView: InputView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var conversation = MessageConversation()
    
    fileprivate let cellId = "id123"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
      
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Chat"
        
        self.view.backgroundColor = .white

        
        //Observe Inputview Delegate to get text message
        textInputView.delegate = self
        
        // Swipe Down is used to hide keyboard by Swipe down action
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        
        //self.view.addGestureRecognizer(swipeDown)
        
        // Tableview
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        
        
        conversation.fetchData({ _ in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollTableViewToBottom()
            }
           
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        
        //Tableview User Interaction is disabled, to enable swipe down Gesture Recognization
        //tableView.isUserInteractionEnabled = false
        tableView.keyboardDismissMode = .onDrag

      adjustingHeight(show: true, notification: notification)
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        
        //Tableview User Interaction is enabled
       // tableView.isUserInteractionEnabled = true
        tableView.keyboardDismissMode = .interactive

        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDurarion = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
     
   
        let changeInHeight = (keyboardFrame.height-12) * (show ? 1 : 0)
       
        UIView.animate(withDuration: animationDurarion, animations: {
            self.bottomConstraint.constant = changeInHeight
        })
        
    }
    
    func scrollTableViewToBottom() {
        
        let sectionCount = self.conversation.sectionCount()
        
        guard sectionCount > 0 else {
            return
        }
        
        let lastSectionRowCount = self.conversation.rowCountAtSection(sectionCount-1)
        
        guard lastSectionRowCount > 0 else {
            return
        }
        

        self.tableView.scrollToRow(at: IndexPath(item:lastSectionRowCount-1, section: sectionCount-1), at: .bottom, animated: false)
        
    }


}

extension ViewController: InputViewDelegate {
   
    func sendMessage(_ text: String, completion: @escaping (Bool) -> ()) {
  
        print(text)

     //   let date = Date()
        
        conversation.insert(text: text, isIncoming: false, date: Date(), completionHandler: { _ in
            
            self.tableView.reloadData()
            
            
           // Scroll Table view to bottom
            self.scrollTableViewToBottom()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                
                self.conversation.insert(text: "Incoming Message", isIncoming: true, date: Date(), completionHandler: { _ in
                    self.tableView.reloadData()
                    self.inputView?.isUserInteractionEnabled = true
                    self.scrollTableViewToBottom()
                    
                    completion(true)
                })
                
            })
        })
    }
    
 
 
 
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversation.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let firstMessageInSection = conversation.getMessageForSection(section) else {
            
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: firstMessageInSection.date ?? Date())


        let label = DateHeaderLabel()
        label.text = dateString
        
        let containerView = UIView()
        
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        guard conversation.getMessageForSection(section) != nil else {
            return 0
        }
        
        return 50
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.rowCountAtSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
        
        cell.message = conversation.getMessageForIndex(indexPath)
      
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
 
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//   
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .lightGray
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }

}
