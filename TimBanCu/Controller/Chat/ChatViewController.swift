//
//  ChatViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/27/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChatViewController: JSQMessagesViewController {

    // from previous class
    var classDetail:ClassProtocol!
    
    // chat
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            controller.updateUserTypingStatusToFB(typing: newValue)
        }
    }
    
    
    func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    private var uiController:ChatUIController!
    private var controller:ChatController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiController = ChatUIController(viewcontroller: self, didFinishPickingImage: {uiimage in
            self.controller.uploadImageToStorage(image: uiimage, completionHandler: { uploadStatus in
                
            })
        })
        controller = ChatController(viewcontroller: self)
        
        senderId = CurrentUser.getUid()
        senderDisplayName = CurrentUser.getFullname()

        // the reason this method is here instead of init because the classDetail from the previous class wasn't passed to here yet
        controller.observeMessages()
        controller.observeTyping()
        //
        
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        controller.uploadMessageToFB(text: text, senderId: senderId, senderDisplayName: senderDisplayName)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage() 
        isTyping = false
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        uiController.showImagePickerController()
    }
    
    deinit {
        controller.removeAllObservers()
    }

}


