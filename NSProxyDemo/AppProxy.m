//
//  AppProxy.m
//  NSProxyDemo
//
//  Created by 陈爱彬 on 15/3/5.
//  Copyright (c) 2015年 陈爱彬. All rights reserved.
//

#import "AppProxy.h"
#import "LoginHandler.h"
#import "MessageHandler.h"
#import <objc/runtime.h>

@interface AppProxy()

@property (nonatomic,strong) NSMutableDictionary *selToHandlerDict;
@end

@implementation AppProxy

+ (instancetype)sharedProxy
{
    static AppProxy *_sharedProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedProxy = [AppProxy alloc];
        _sharedProxy.selToHandlerDict = [NSMutableDictionary dictionary];
        //registerProtocol
        [_sharedProxy registerHandlerProtocol:@protocol(LoginHandlerProtocol) handler:[LoginHandler new]];
        [_sharedProxy registerHandlerProtocol:@protocol(MessageHandlerProtocol) handler:[MessageHandler new]];
    });
    return _sharedProxy;
}

- (void)registerHandlerProtocol:(Protocol *)protocol handler:(id)handler
{
    unsigned int numberOfMethods = 0;
    //Get all methods in protocol
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, YES, YES, &numberOfMethods);
    //Register protocol methods
    for (unsigned int i = 0; i < numberOfMethods; i++) {
        struct objc_method_description method = methods[i];
        [_selToHandlerDict setValue:handler forKey:NSStringFromSelector(method.name)];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *methodName = NSStringFromSelector(invocation.selector);
    id handler = [_selToHandlerDict valueForKey:methodName];
    if (handler && [handler respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:handler];
    }else{
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSString *methodName = NSStringFromSelector(sel);
    id handler = [_selToHandlerDict valueForKey:methodName];
    if (handler && [handler respondsToSelector:sel]) {
        return [handler methodSignatureForSelector:sel];
    }
    else {
        return [super methodSignatureForSelector:sel];
    }
}
@end
