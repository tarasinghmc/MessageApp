//
//  InputView.swift
//  MessageApp
//
//  Created by Tara Singh M C on 02/03/19.
//  Copyright © 2019 Tara Singh. All rights reserved.
//

import UIKit

public protocol InputViewDelegate: class {
    func sendMessage(_ text: String, completion: @escaping (_ result: Bool)->())
}

@IBDesignable class InputView: UIView {
    
    private var containerView = UIView()
    private var textView = UITextView()
    private var sendButton = UIButton()
    private var placeholderLabel = UILabel()
    
    private let space: CGFloat = 12
    private let maxInputViewHeight: CGFloat = 150
    private var inputViewHeightConstraint: NSLayoutConstraint!
    
    
    // Delegate used to notifiy conterverl to send message
    weak var delegate: InputViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
        configureSubViews()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContainerView()
        configureSubViews()
    }
    
    private func configureContainerView() {
        self.backgroundColor = .white
        //  self.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.5
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: space),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -space),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: space),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxInputViewHeight)
            ])
        
        
        
    }
    
    private func configureSubViews() {
        
        // Input text view
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        containerView.addSubview(textView)
        
        
        
        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
                                     textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
                                     textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: space/2)])
        
        
        // Send Button
        sendButton.addTarget(self, action: #selector(sendMessage(sender:)), for: .touchUpInside)
        sendButton.backgroundColor = .clear
        // sendButton.setImage(UIImage.init(named: "sendDeselect"), for: .normal)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.contentMode = .center
        
        containerView.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
                                     sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: space),
                                     sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -space),
                                     sendButton.widthAnchor.constraint(equalToConstant: 44),
                                     sendButton.heightAnchor.constraint(equalToConstant: 22)])
        
        //PlaceHolder Label
        
        placeholderLabel.text = "Text Message"
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: space/2),
                                     placeholderLabel.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: space),
                                     placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor)])
        
        print(self.frame.size)
    }
    
    //    public override var intrinsicContentSize: CGSize {
    //
    //        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    //    }
    
    // Send Button Action
    @objc func sendMessage(sender : UIButton) {
        
        // Call SendMessage Delegate if Text lenght is greater than 0
        if !textView.text.isEmpty {
            
            // Disable send button Action still replay come back from server
            self.sendButton.isUserInteractionEnabled = false
            
            
            //Call SendMessage Delegate, to notifiy Observer
            delegate?.sendMessage(textView.text, completion: { enable in
                
                self.sendButton.isUserInteractionEnabled = enable
            })
            
            // Remove entered text
            textView.text = ""
            // Dismiss the text field
            self.endEditing(true)
            
            // Show PlaceholderLabel
            placeholderLabel.isHidden = false
            textView.becomeFirstResponder()
            
            
            
        }
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
}

extension InputView: UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        // Hide placehoder label if Text is empty
        hidePlaceholderLabel(!textView.text.isEmpty)
        
        // Enable Textview scroll if Inputview height is greter than 200
        textView.isScrollEnabled = (self.frame.size.height < maxInputViewHeight) ? false : true
        
        /* if self.frame.size.height < maxInputViewHeight {
         textView.isScrollEnabled = false
         
         //            let fixedWidth = textView.frame.size.width
         //
         //            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
         //
         //            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
         //
         //            var newFrame = textView.frame
         //            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
         //            textView.frame = newFrame
         
         } else {
         textView.isScrollEnabled = true
         }*/
        
        
    }
    
    
    
    private func hidePlaceholderLabel(_ hide: Bool) {
        
        placeholderLabel.isHidden = hide
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //        if textView.text.isEmpty {
        //            inputViewHeightConstraint.constant = 44
        //            textView.isScrollEnabled = false
        //        } else {
        //
        //            textView.isScrollEnabled = (self.frame.size.height < maxInputViewHeight) ? false : true
        //        }
        
    }
    
    //   func textViewDidEndEditing(_ textView: UITextView) {
    //
    //     let fixedWidth = textView.frame.size.width
    //
    //     textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //
    //     let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //
    //     var newFrame = textView.frame
    //     newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    //     textView.frame = newFrame
    //
    //     }
    
}
