//
//  ChatController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import JSQMessagesViewController

class ChatController{
    fileprivate var messageRef: DatabaseReference!
    private var newMessageRefHandle: DatabaseHandle!
    private var updatedMessageRefHandle: DatabaseHandle!
    private var typingIndicatorRef: DatabaseReference!
    private var usersTypingQuery: DatabaseQuery!
    private let storage = Storage.storage()
    
    
    private var classDetail:ClassProtocol!
    fileprivate var viewcontroller:ChatViewController!
    
    fileprivate let imageURLNotSetKey = "NOTSET"
    fileprivate var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    init(viewcontroller:ChatViewController){
        self.viewcontroller = viewcontroller
        classDetail = viewcontroller.classDetail
        setupDBReference()
    }
    
    func removeAllObservers(){
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    func updateUserTypingStatusToFB(typing:Bool){
        let userIsTypingRef = typingIndicatorRef.child(viewcontroller.senderId)
        userIsTypingRef.setValue(typing)
    }
    
    private func setupDBReference(){
        messageRef = Database.database().reference().child("messages").child(classDetail.getFirebasePathWithSchoolYear())
        typingIndicatorRef = Database.database().reference().child("typingIndicator").child(classDetail.getFirebasePathWithSchoolYear())
        
        usersTypingQuery = typingIndicatorRef!.queryOrderedByValue().queryEqual(toValue: true)
    }
}

// Firebase

extension ChatController{
    func uploadMessageToFB(text: String, senderId: String, senderDisplayName: String){
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId,
            "senderName": senderDisplayName,
            "text": text,
            ]
        
        itemRef.setValue(messageItem)
    }
}

// Chat Image
extension ChatController{
    func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        
        let storageRef = Storage.storage().reference(forURL: photoURL)
        
        storageRef.getData(maxSize: INT64_MAX){ [weak self] (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            mediaItem.image = UIImage.init(data: data!)
            self!.viewcontroller.collectionView.reloadData()
            
            guard key != nil else {
                return
            }
            self!.photoMessageMap.removeValue(forKey: key!)
        }
    }
    
    func uploadImageToStorage(image: UIImage, completionHandler:@escaping (Status)->()){
        let imageData = image.jpeg(.medium)
        
        if(imageData == nil){
            return
        }
        
        let imageRef = storage.reference().child("messages/\(classDetail.getFirebasePathWithSchoolYear())")
        
        
        if let key = sendPhotoMessage() {
            let path = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)))"
            
            imageRef.child(path).putData(imageData!, metadata: nil) { [weak self] (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error uploading photo: \(error?.localizedDescription)")
                    return
                }
                
                print()
                self!.setImageURL(imageRef.child(path).description, forPhotoMessageWithKey: key)
            }
        }
    }
    
    private func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
}

// Chat Messages
extension ChatController{
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            viewcontroller.messages.append(message)
        }
    }
    
    func observeMessages() {
        observeNewMessage()
        observeForUpdatedMessage()
    }
    
    private func observeNewMessage(){
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String?, let name = messageData["senderName"] as String?, let text = messageData["text"] as String!, text.characters.count > 0 {
                
                self!.addMessage(withId: id, name: name, text: text)
                self!.viewcontroller.finishReceivingMessage()
            }
            else if let id = messageData["senderId"] as String!,
                let photoURL = messageData["photoURL"] as String! {
                
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self!.viewcontroller.senderId) {
                    
                    self!.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                    
                    if photoURL.hasPrefix("gs://") {
                        self!.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            }
            else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    private func observeForUpdatedMessage(){
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { [weak self] (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let photoURL = messageData["photoURL"] as String? {
                // The photo has been updated.
                if let mediaItem = self!.photoMessageMap[key] {
                    self!.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
                }
            }
        })
    }
    
    fileprivate func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": viewcontroller.senderId!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        viewcontroller.finishSendingMessage()
        return itemRef.key
    }
    
    func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            viewcontroller.messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            viewcontroller.collectionView.reloadData()
        }
    }
    
    func observeTyping() {
        let userIsTypingRef = typingIndicatorRef.child(viewcontroller.senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        usersTypingQuery.observe(.value) { [weak self] (data: DataSnapshot) in
            // You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self!.viewcontroller.isTyping {
                return
            }
            
            // Are there others typing?
            self!.viewcontroller.showTypingIndicator = data.childrenCount > 0
            self!.viewcontroller.scrollToBottom(animated: true)
        }
    }
}
