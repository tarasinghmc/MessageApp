//
//  MessageTableViewCell.swift
//  MessageApp
//
//  Created by Tara Singh M C on 03/03/19.
//  Copyright © 2019 Tara Singh. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleBackgroundView: UIView!
    
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    var message: Message! {
        didSet {
            bubbleBackgroundView.backgroundColor = message.isIncoming ? .white : .darkGray
            messageLabel.textColor = message.isIncoming ? .black : .white
            
            messageLabel.text = message.text
            
//            if message.isIncoming {
//                leadingConstraint.isActive = true
//                trailingConstraint.isActive = false
//            } else {
//                leadingConstraint.isActive = false
//                trailingConstraint.isActive = true
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 12
        messageLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
