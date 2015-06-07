//
//  RBSentinel.m
//  RBSentinelDemo
//
//  Created by Roshan Balaji Nindrai SenthilNathan on 5/16/15.
//  Copyright (c) 2015 Roshan Balaji Nindrai SenthilNathan. All rights reserved.
//
#import  "RBSentinel.h"
#include <CoreFoundation/CoreFoundation.h>
#import  <WatchKit/WatchKit.h>

@interface NSString (Sentinel)

-(NSString *)capitalizedFirstLetter;

@end

@implementation NSString (Sentinel)

-(NSString *) capitalizedFirstLetter {
    NSString *capString = self;
    if (self.length <= 1) {
        capString = self.capitalizedString;
    } else {
        capString = [NSString stringWithFormat:@"%@%@",
                  [[self substringToIndex:1] uppercaseString],
                  [self substringFromIndex:1]];
    }
    return capString;
}

-(NSString *)selectorMethod {
    
    return [self stringByAppendingString:@":"];
    
}

@end


NSString *const KHANDLERCLASSSUFFIX       = @"Handler";
NSString *const KSENTINELREQUESTTYPE      = @"type";
NSString *const KSENTINELREQUESTRESOURCE  = @"resource";
NSString *const KSENTINELREQUESTPARAMETER = @"parameters";
NSString *const KSENTINELRESPONSE         = @"parameters";
NSString *const KSENTINELIDENTIFIER       = @"sentinel";
NSString *const KSENTINELERRORDOMAIN      = @"SENTINEL_ERROR";

@interface RBSentinel ()

@property(nonatomic, strong) NSMutableDictionary *routeHandlers;
@property(nonatomic, strong) NSString  *resourcePath;
@property(nonatomic, strong) NSURL  *fileURL;
@property(nonatomic, strong) NSFileManager  *fileManager;
@property(nonatomic, strong) NSString *groupIdentifier;
@property(nonatomic, strong) id response;
@property(nonatomic, strong) NSMutableDictionary *listenersCallbacks;
@property(nonatomic, strong) BOOL(^handler)(NSDictionary *parameters);

@end

@implementation RBSentinel

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
    
        self.routeHandlers      = [NSMutableDictionary new];
        self.listenersCallbacks = [NSMutableDictionary new];
        self.fileManager = [NSFileManager new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(DidReceiveSentinelNotification:)
                                                     name:KSENTINELIDENTIFIER object:nil];

    }
    
    return self;
    
}

-(instancetype)initWithGroupIdentifier:(NSString *)groupIdentifier {
    
    self = [[self class] new];
    
    if(self) {
        self.groupIdentifier = groupIdentifier;
    }
    return self;
}


+ (instancetype)dock {
    static RBSentinel *sharedDock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDock = [[self alloc] init];
    });
    return sharedDock;
}

+(void)handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    
    [[self dock] fullfillRequestofType:[userInfo objectForKey:KSENTINELREQUESTTYPE]
                           forResource:[userInfo objectForKey:KSENTINELREQUESTRESOURCE]
                        withParameters:[userInfo objectForKey:KSENTINELREQUESTPARAMETER]
                   andCompletionHander:reply];
    
    
}


#pragma mark accesors / mutators

-(void)setGroupIdentifier:(NSString *)groupIdentifier {
    
    
    if(_groupIdentifier != groupIdentifier) {
        
        _groupIdentifier = groupIdentifier;
        self.fileURL = [self.fileManager
                    containerURLForSecurityApplicationGroupIdentifier:
                    _groupIdentifier];
        
    }
    
    
}

-(void)setFileURL:(NSURL *)fileURL {
    
    if(_fileURL != fileURL) {
        
        _fileURL = fileURL;
        self.resourcePath = [_fileURL absoluteString];
        [self.fileManager createDirectoryAtPath:_resourcePath
                    withIntermediateDirectories:YES attributes:nil error:NULL];
        
    }
}

-(void)fileForResource:(NSURL *)fileURL {
    
    if(_fileURL != fileURL) {
        
        _fileURL = [fileURL URLByAppendingPathComponent:KSENTINELIDENTIFIER];
        
    }
}

#pragma mark listeners

-(void)addListenerForResource:(NSString *)resource
        withCompletionHandler:(void (^)(id response))completionHandler {
    
    NSMutableArray *listeners = [self.listenersCallbacks objectForKey:resource];
    
    if(listeners == nil)
        listeners = [NSMutableArray new];
    
    [listeners addObject:completionHandler];
    [self.listenersCallbacks setObject:listeners forKey:resource];
    
    [self subscribeToNotificationForIdentifier:resource];
    
}


-(void)removeListenersForResource:(NSString *)resource {
    
    NSMutableArray *listeners = [self.listenersCallbacks objectForKey:resource];
    
    if(listeners != nil)
        [self.listenersCallbacks setObject:[NSMutableArray new] forKey:resource];
    

}

-(void)subscribeToNotificationForIdentifier:(NSString *)resource {
    
    CFNotificationCenterRef const notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef resourceString = (__bridge CFStringRef)(resource);
    CFNotificationCenterAddObserver(notificationCenter,
                                    (__bridge const void *)(self),
                                    darwinNotificationCallback,
                                    resourceString,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
}

#pragma mark Private methods

-(void)didUpdateResource:(NSString *)resource withContent:(id)content {
    
    if(resource == nil || content == nil)
        return;
    
    NSString *resourcePath = [self.resourcePath stringByAppendingString:resource];
    
    if(resourcePath == nil)
        return;
    
    NSData *_contentData = [NSKeyedArchiver archivedDataWithRootObject:content];
    
    if([_contentData isEqual:nil])
        return;
    
    NSError *error;
    
    BOOL _didWrite = [_contentData writeToURL:[NSURL URLWithString:resourcePath]
                                      options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Fail: %@", [error localizedDescription]);
    }
    
    if (_didWrite) {
        // send out notification
        [self sendUpdateNotificationForResouce:resource];
    }
    
}

-(void)performRequestofType:(NSString*)requestType
                        forResource:(NSString *)resource
             withParameters:(id)parameters andCompletionHander:(void (^) (id response))completionHandler {
    
    resource = [resource capitalizedFirstLetter];
    NSString *callType = [requestType selectorMethod];
    [WKInterfaceController openParentApplication:@{KSENTINELREQUESTTYPE:callType,
                                                   KSENTINELREQUESTRESOURCE:resource,
                                                   KSENTINELREQUESTPARAMETER:parameters}
     
     
                                           reply:^(NSDictionary *replyInfo, NSError *error) {
                                               if(completionHandler)
                                                   completionHandler([replyInfo objectForKey:KSENTINELRESPONSE]);
                                           }];
    
}

-(void)fullfillRequestofType:(NSString *)requestType
                forResource:(NSString *)resource
              withParameters:(id)parameters andCompletionHander:(void (^) (id response))completionHandler {
    
    
    id<SentinelHandlerProtocol> handler = [self getHandlerForResource:resource];
    
    id response = nil;

    if(handler != nil) {
        
        if([handler respondsToSelector:NSSelectorFromString(requestType)]){
            
            response = [self invokeMethod:requestType onHandler:handler withParameters:parameters];
            
        }
    
    }

    if(completionHandler)
        completionHandler(@{KSENTINELRESPONSE: response});
        
    
}

#pragma mark notification

-(void)DidReceiveSentinelNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    if(userInfo == nil || [userInfo objectForKey:KSENTINELREQUESTRESOURCE] == nil)
        return;
    
    NSString *resourceString = [userInfo objectForKey:KSENTINELREQUESTRESOURCE];
    
    [self fireListenersForResource:resourceString];
        
}

-(void)fireListenersForResource:(NSString *)resourceString {
    
    NSMutableArray *_listenerBlocks = [_listenersCallbacks objectForKey:resourceString];
    
    for(void(^listener)(id response) in _listenerBlocks) {
        
        id response = [self responseForResource:resourceString];
        
        if(listener)
            listener(response);
        
    }
    
}

-(id)responseForResource:(NSString *)resource {
    
    NSData *savedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.resourcePath stringByAppendingString:resource]]];
    
    if(savedData != nil)
        return [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    
    return nil;
}

void darwinNotificationCallback(CFNotificationCenterRef center,
                                  void * observer,
                                  CFStringRef name,
                                  void const * object,
                                  CFDictionaryRef userInfo)  {
    
    NSString *resourceString = (__bridge NSString *)(name);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KSENTINELIDENTIFIER
                                                        object:nil userInfo:@{KSENTINELREQUESTRESOURCE:resourceString}];
    
}

-(void)sendUpdateNotificationForResouce:(NSString *)resource {
    
    if([resource isEqual:nil])
        return;
    
    CFNotificationCenterRef const notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef resourceString = (__bridge CFStringRef)(resource);
    CFNotificationCenterPostNotification(notificationCenter, resourceString, NULL, NULL, YES);
    
    
}

# pragma mark helper methods

-(id<SentinelHandlerProtocol>)getHandlerForResource:(NSString *)resource {
    
    
    if([self.routeHandlers objectForKey:resource] == nil) {

        NSString *HandlerClassName = [resource stringByAppendingString:KHANDLERCLASSSUFFIX];
        Class handlerClass = NSClassFromString(HandlerClassName);
        if(handlerClass != nil)
            [self.routeHandlers setObject:[handlerClass new] forKey:resource];
        
    }
    
     return [self.routeHandlers objectForKey:resource];
    
}

-(id)invokeMethod:(NSString *)methodName onHandler:(id<SentinelHandlerProtocol>)handler withParameters:(id)parameters {
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[handler class] instanceMethodSignatureForSelector:NSSelectorFromString(methodName)]];
    [invocation setSelector:NSSelectorFromString(methodName)];
    [invocation setTarget:handler];
    [invocation setArgument:&parameters atIndex:2];
    [invocation invoke];
    [invocation getReturnValue:&_response];
    
    return _response;
    
}

#pragma marok error messages 

-(NSDictionary *)noHandlerMethodErroruserInfo {
    
    return @{
                                         NSLocalizedDescriptionKey: NSLocalizedString(@"call handler method was unsuccessful.", nil),
                                         NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Handler method was not found ", nil),
                                         NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check your handler method name", nil)
                                         };
    
}

-(NSDictionary *)noHandlerErroruserInfo {
    
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"call handler method was unsuccessful.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Handler method was not found ", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check your handler method name", nil)
             };
    
}

@end
