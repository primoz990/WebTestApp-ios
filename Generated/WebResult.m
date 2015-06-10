//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/primoz/Intera/WebTestApp-Android/weblib/src/main/java/com/example/weblib/WebResult.java
//


#line 1 "/Users/primoz/Intera/WebTestApp-Android/weblib/src/main/java/com/example/weblib/WebResult.java"

#include "J2ObjC_source.h"
#include "WebResult.h"


#line 3
@implementation WLWebResult


#line 8
- (instancetype)init {
  WLWebResult_init(self);
  return self;
}


#line 14
- (instancetype)initWithInt:(jint)code
               withNSString:(NSString *)message
                withBoolean:(jboolean)success {
  WLWebResult_initWithInt_withNSString_withBoolean_(self, code, message, success);
  return self;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "init", "WebResult", NULL, 0x1, NULL, NULL },
    { "initWithInt:withNSString:withBoolean:", "WebResult", NULL, 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "code_", NULL, 0x0, "I", NULL, NULL,  },
    { "message_", NULL, 0x0, "Ljava.lang.String;", NULL, NULL,  },
    { "success_", NULL, 0x0, "Z", NULL, NULL,  },
  };
  static const J2ObjcClassInfo _WLWebResult = { 2, "WebResult", "com.example.weblib", NULL, 0x1, 2, methods, 3, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_WLWebResult;
}

@end


#line 8
void WLWebResult_init(WLWebResult *self) {
  (void) NSObject_init(self);
  
#line 9
  self->code_ = -1;
  self->message_ = nil;
  self->success_ = NO;
}


#line 8
WLWebResult *new_WLWebResult_init() {
  WLWebResult *self = [WLWebResult alloc];
  WLWebResult_init(self);
  return self;
}

void WLWebResult_initWithInt_withNSString_withBoolean_(WLWebResult *self, jint code, NSString *message, jboolean success) {
  (void) NSObject_init(self);
  
#line 15
  self->code_ = code;
  self->message_ = message;
  self->success_ = success;
}


#line 14
WLWebResult *new_WLWebResult_initWithInt_withNSString_withBoolean_(jint code, NSString *message, jboolean success) {
  WLWebResult *self = [WLWebResult alloc];
  WLWebResult_initWithInt_withNSString_withBoolean_(self, code, message, success);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(WLWebResult)
