//
//  LYRMIMETypeComponents.h
//  Pods
//
//  Created by Klemen Verdnik on 3/26/18.
//

#import <Foundation/Foundation.h>

/**
 @abstract An object that parses MIMEType string into and constructs
   MIME-Type string from their constituent parts.

   The @c LYRMIMETypeComponents class is a class that is designed to parse
   string containing MIMETypes based on RFC 2045 and to construct the string
   from their constituent parts.

   You create a MIMEType components object in one of three ways:

   - from an @c NSString object that contains a MIMEType structure; or
 
   - from scratch by using the default initializer. From there, you can modify
     the MIMEType's individual components and subcomponents by modifying
     various properties.
 */
@interface LYRMIMETypeComponents : NSObject

#pragma mark - Components

/**
 @abstract The high-level media type, such as "text", "application", "image", etc.
 @note Type specification is mandatory to construct a string representation
   of the MIMEType.
 */
@property (nonatomic, nullable, readwrite, copy) NSString *type;

/**
 @abstract The media subtype, such as "plain", "octet-stream", "jpeg", etc.
 @note Subtype specification is mandatory to construct a string representation
   of the MIMEType.
 */
@property (nonatomic, nullable, readwrite, copy) NSString *subtype;

/**
 @abstract IANA token, which is a publicly-defined extension token, such as
   "xml", "json", etc.
 */
@property (nonatomic, nullable, readwrite, copy) NSString *extensionToken;

/**
 @abstract A dictionary containing attribute values keyed off of attribute names.
 */
@property (nonatomic, nullable, readwrite, copy) NSDictionary <NSString *, NSString *> *attributes;

#pragma mark - Initialization

/**
 @abstract The default initializer.
 @return Returns an empty @c LYRMIMETypeComponents instance.
 */
+ (nonnull instancetype)components;

/**
 @abstract Initializer that parses a MIMEType string conforming to RFC 2045.
 @param string The string representing a composed MIMEType.
 @return An instance of @c LYRMIMETypeComponents having all MIMEType values
   parsed into components; In case of failure, the initlizer returns @c nil.
 */
+ (nullable instancetype)componentsWithString:(nonnull NSString *)string;

/**
 @abstract Initializer that takes each MIMEType component individually.
 @param type The high-level media type string.
 @param subtype The media subtype string.
 @param extensionToken The IANA token string.
 @param attributes A dictionary of string-to-string keys and values
   representing MIMEType attributes.
 @return An instance of @c LYRMIMETypeComponents containing components passed
   in as arguments to the initializer.
 */
+ (nonnull instancetype)componentsWithType:(nonnull NSString *)type subtype:(nonnull NSString *)subtype extensionToken:(nullable NSString *)extensionToken attributes:(nullable NSDictionary<NSString *, NSString *> *)attributes;

#pragma mark - Validation and Composition

/**
 @abstract Validates components for RFC 2045 conformance.
 @return Returns @c YES if the receiver can compose a string representation
   of MIMEType from the components; otherwise @c NO.
 */
- (BOOL)isValid;

/**
 @abstract Composes an RFC 2045 compliant MIMEType representation string.
 @return Returns a string if the receiver can compose a string representation
   of MIMEType from the components; otherwise @c nil.
 */
- (nullable NSString *)stringValue;

@end
