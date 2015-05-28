//
//  Router.h
//  RBOxygenDemo
//
//  Created by Roshan Balaji Nindrai SenthilNathan on 5/16/15.
//  Copyright (c) 2015 Roshan Balaji Nindrai SenthilNathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SentinelHandlerProtocol <NSObject>

@optional
-(id)get:(id)parameters;

@optional
-(id)post:(id)parameters;

@optional
-(id)remove:(id)parameters;

@optional
-(id)update:(id)parameters;


@end

@interface RBSentinel : NSObject


typedef enum{
    
    GET = 0,
    POST,
    REMOVE,
    UPDATE,
    
}SentinelRequestType;


-(instancetype)initWithGroupIdentifier:(NSString *)groupIdentifier;

-(void)performRequestofType:(SentinelRequestType)requestType
                        forResource:(NSString *)resource
             withParameters:(id)parameters
        andCompletionHander:(void (^) (id response))completionHandler;


// watchkit methods

+(void)handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply;

//updates and listeners

-(void)didUpdateResource:(NSString *)resource withContent:(id)content;

-(void)addListenerForResource:(NSString *)resource withCompletionHandler:(void (^)(id response))completionHandler;

-(void)removeListenersForResource:(NSString *)resource;

@end

