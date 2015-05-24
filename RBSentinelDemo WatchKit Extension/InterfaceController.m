//
//  InterfaceController.m
//  RBSentinelDemo WatchKit Extension
//
//  Created by Roshan Nindrai Senthilnathan on 5/24/15.
//  Copyright (c) 2015 Roshan Nindrai Senthilnathan. All rights reserved.
//

#import "InterfaceController.h"
#import "Sentinel.h"


@interface InterfaceController()

@property(nonatomic, strong)Sentinel *sentinel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *parentAppMessage;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.sentinel = [[Sentinel alloc] initWithGroupIdentifier:@"group.sentinel"];
    
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.sentinel addListenerForResource:@"message" withCompletionHandler:^(id response) {
        
        [weakSelf.parentAppMessage setText:response];
        
    }];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)didtapGet {
    
    [self.sentinel performRequestofType:GET forResource:@"post" withParameters:@{@"1":@"2"} andCompletionHander:^(id response) {
        NSLog(@"RESPONSE %@", response);
    }];
    
}
- (IBAction)didTapPost {
    
    [self.sentinel performRequestofType:POST forResource:@"post" withParameters:@{@"1":@"2"} andCompletionHander:^(id response) {
        NSLog(@"RESPONSE %@", response);
    }];
    
    
}
- (IBAction)didTapRemove {
    
    [self.sentinel performRequestofType:REMOVE forResource:@"post" withParameters:@{@"1":@"2"} andCompletionHander:^(id response) {
        NSLog(@"RESPONSE %@", response);
    }];
    
    
}
- (IBAction)didTapUpdate {
    
    [self.sentinel performRequestofType:UPDATE forResource:@"post" withParameters:@{@"1":@"2"} andCompletionHander:^(id response) {
        NSLog(@"RESPONSE %@", response);
    }];
    
    
}

@end



