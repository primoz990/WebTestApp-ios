//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/primozr/Intera/Android/Projects/WebTestApp-android/weblib/src/main/java/com/example/weblib/WebResult.java
//

#ifndef _WLWebResult_H_
#define _WLWebResult_H_

#include "J2ObjC_header.h"

@interface WLWebResult : NSObject {
 @public
  jint code_;
  NSString *message_;
  jboolean success_;
}

#pragma mark Public

- (instancetype)init;

- (instancetype)initWithInt:(jint)code
               withNSString:(NSString *)message
                withBoolean:(jboolean)success;

@end

J2OBJC_EMPTY_STATIC_INIT(WLWebResult)

J2OBJC_FIELD_SETTER(WLWebResult, message_, NSString *)

FOUNDATION_EXPORT void WLWebResult_init(WLWebResult *self);

FOUNDATION_EXPORT WLWebResult *new_WLWebResult_init() NS_RETURNS_RETAINED;

FOUNDATION_EXPORT void WLWebResult_initWithInt_withNSString_withBoolean_(WLWebResult *self, jint code, NSString *message, jboolean success);

FOUNDATION_EXPORT WLWebResult *new_WLWebResult_initWithInt_withNSString_withBoolean_(jint code, NSString *message, jboolean success) NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(WLWebResult)

typedef WLWebResult ComExampleWeblibWebResult;

#endif // _WLWebResult_H_
