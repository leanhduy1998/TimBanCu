//
//  LYRTypingIndicator.h
//  Pods
//
//  Created by Andrew Mcknight on 3/13/17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LYRIdentity;

///-----------------------
/// @name Typing Indicator
///-----------------------

/**
 @abstract The `LYRTypingIndicatorAction` enumeration describes the states of a typing status of a participant in a conversation.
 */
typedef NS_ENUM(NSUInteger, LYRTypingIndicatorAction) {
    LYRTypingIndicatorActionBegin   = 0,
    LYRTypingIndicatorActionPause   = 1,
    LYRTypingIndicatorActionFinish  = 2
};

extern NSString *const LYRTypingIndicatorContentType;

NSString *LYRStringFromTypingIndicator(LYRTypingIndicatorAction typingIndicatorValue);

/**
 @abstract The `LYRTypingIndicator` object encapsulated the typing indicator action value and the participant
 identity which is bundled in the `LYRConversationDidReceiveTypingIndicatorNotification`'s userInfo.
 */
@interface LYRTypingIndicator : NSObject

/**
 @abstract The action value that represents the last typing indicator state that the participant caused.
 */
@property (nonatomic, readonly) LYRTypingIndicatorAction action;

/**
 @abstract Participant that caused the last typing indicator action.
 */
@property (nonatomic, readonly) LYRIdentity *sender;

@end

NS_ASSUME_NONNULL_END
