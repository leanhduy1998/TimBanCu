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
    var classDetail:ClassDetail!
    
    
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
            let userIsTypingRef = typingIndicatorRef.child(senderId)
            userIsTypingRef.setValue(newValue)
        }
    }
    
    let imageURLNotSetKey = "NOTSET"
    
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    // firebase
    var messageRef: DatabaseReference!
    var newMessageRefHandle: DatabaseHandle!
    var updatedMessageRefHandle: DatabaseHandle!
    var typingIndicatorRef: DatabaseReference!
    var usersTypingQuery: DatabaseQuery!
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the reason this method is here instead of init because the classDetail from the previous class wasn't passed to here yet
        setupDBReference()
        observeMessages()
        observeTyping()
        //
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        senderId = CurrentUserHelper.getUid()
        senderDisplayName = CurrentUserHelper.getFullname()
    }
    
    
    func setupDBReference(){
        messageRef = Database.database().reference().child("messages").child(classDetail.getFirebasePathWithSchoolYear())
        typingIndicatorRef = Database.database().reference().child("typingIndicator").child(classDetail.getFirebasePathWithSchoolYear())
        
        usersTypingQuery = typingIndicatorRef!.queryOrderedByValue().queryEqual(toValue: true)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage() 
        isTyping = false
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }

}


