//
//  LYRIdentity.h
//  LayerKit
//
//  Created by Klemen Verdnik on 7/16/15.
//  Copyright (c) 2015 Layer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRQuery.h"

typedef NS_ENUM(NSUInteger, LYRIdentityPresenceStatus) {
    /**
     @abstract No clients associated with the Identity are currently online or are explicitly marked as invisible.
     */
    LYRIdentityPresenceStatusOffline,

    /**
     @abstract One or more clients associated with the Identity are online and available.
     */
    LYRIdentityPresenceStatusAvailable,

    /**
     @abstract One or more clients associated with the Identity are online, but marked as busy.
     */
    LYRIdentityPresenceStatusBusy,

    /**
     @abstract One or more clients associated with the Identity are online, but marked as away from the device.
     */
    LYRIdentityPresenceStatusAway,

    /**
     @abstract The current authenticated user is set as invisible. This status is only available for the authenticated user. Invisible followed users appear as unavailable.
     */
    LYRIdentityPresenceStatusInvisible
};

@class LYRMessage;

/**
 @abstract The `LYRIdentity` class represents an identity synchronized to the client with information provided
 by the provider application. `LYRIdentity` objects are used as `LYRConversation` participants and as `LYRMessage` sender values.
 */
@interface LYRIdentity : NSObject <LYRQueryable>

/**
 @abstract A unique identifier for the identity.
 @discussion The `identifier` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, readonly, nonnull) NSURL *identifier LYR_QUERYABLE_PROPERTY;

/**
 @abstract The userID associated with the identity.
 @discussion The `userID` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, readonly, nonnull) NSString *userID LYR_QUERYABLE_PROPERTY LYR_QUERYABLE_FROM(LYRMessage);

/**
 @abstract The display name for the identity.
 @discussion The `displayName` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`,  `LYRPredicateOperatorIsNotIn`, and `LYRPredicateOperatorLike` operators.
 */
@property (nonatomic, readonly, nullable) NSString *displayName LYR_QUERYABLE_PROPERTY LYR_QUERYABLE_FROM(LYRMessage);

/**
 @abstract The first name for the identity.
 @discussion The `firstName` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, `LYRPredicateOperatorIsNotIn`,and `LYRPredicateOperatorLike` operators.
 */
@property (nonatomic, readonly, nullable) NSString *firstName LYR_QUERYABLE_PROPERTY;

/**
 @abstract The last name for the identity.
 @discussion The `lastName` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, `LYRPredicateOperatorIsNotIn`, and `LYRPredicateOperatorLike` operators.
 */
@property (nonatomic, readonly, nullable) NSString *lastName LYR_QUERYABLE_PROPERTY;

/**
 @abstract The email address for the identity.
 @discussion The `emailAddress` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, `LYRPredicateOperatorIsNotIn`, and `LYRPredicateOperatorLike`x operators.
 */
@property (nonatomic, readonly, nullable) NSString *emailAddress LYR_QUERYABLE_PROPERTY;

/**
 @abstract The phone number for the identity.
 @discussion The `phoneNumber` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, readonly, nullable) NSString *phoneNumber LYR_QUERYABLE_PROPERTY;

/**
 @abstract The avatar image url for the identity.
 @discussion The `avatarImageURL` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, readonly, nullable) NSURL *avatarImageURL LYR_QUERYABLE_PROPERTY;

/**
 @abstract Returns the metadata associated with the identity.
 @discussion Metadata is a free form dictionary of string key-value pairs that allows arbitrary developer supplied information to be associated with the identity. The `metadata` property is queryable in 2 forms.  The first is key path form eg:`metadata.first.second`, and is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`,
 `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.  The second is querying against `metadata` and passing in a dictionary object value, and is only queryable via the `LYRPredicateOperatorIsEqualTo` operator.
 */
@property (nonatomic, readonly, nullable) NSDictionary *metadata LYR_QUERYABLE_PROPERTY;

/**
 @abstract The public key for the identity.
 @discussion The `publicKey` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, readonly, nullable) NSString *publicKey LYR_QUERYABLE_PROPERTY;

/**
 @abstract The followed property indicates if an identity has been synchronized with Layer's platform.
 @discussion The `followed` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.  `YES` if the identity has been synchronized with Layer's platform.
 */
@property (nonatomic, readonly) BOOL followed LYR_QUERYABLE_PROPERTY;

/**
 @abstract The presence status of the identity.
 @discussion The `presenceStatus` property is queryable via the `LYRPredicateOperatorIsEqualTo`, `LYRPredicateOperatorIsNotEqualTo`, `LYRPredicateOperatorIsIn`, and `LYRPredicateOperatorIsNotIn` operators.
 */
@property (nonatomic, assign, readonly) LYRIdentityPresenceStatus presenceStatus LYR_QUERYABLE_PROPERTY;

/**
 @abstract A timestamp indicating when the user was last seen online.
 @discussion The `createdAt` property is queryable using all predicate operators except for `LYRPredicateOperatorLike`.
 */
@property (nonatomic, readonly, nullable) NSDate *lastSeenAt LYR_QUERYABLE_PROPERTY;

@end
