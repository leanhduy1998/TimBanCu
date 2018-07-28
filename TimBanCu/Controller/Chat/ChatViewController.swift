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

    var messages = [JSQMessage]()
    
    var classDetail:ClassDetail!
    
    var messageRef: DatabaseReference!
    var newMessageRefHandle: DatabaseHandle!
    var updatedMessageRefHandle: DatabaseHandle!
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var typingIndicatorRef: DatabaseReference!
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
    var usersTypingQuery: DatabaseQuery!
    let imageURLNotSetKey = "NOTSET"
    
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDBReference()
        
        senderId = Auth.auth().currentUser?.uid
        senderDisplayName = UserHelper.student.fullName
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        observeMessages()
        observeTyping()
    }
    
    func setupDBReference(){
        messageRef = Database.database().reference().child("messages").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className)
        typingIndicatorRef = Database.database().reference().child("typingIndicator").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className)
        
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


