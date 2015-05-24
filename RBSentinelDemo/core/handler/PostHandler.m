//
//  PostHandler.m
//  RBOxygenDemo
//
//  Created by Roshan Balaji Nindrai SenthilNathan on 5/16/15.
//  Copyright (c) 2015 Roshan Balaji Nindrai SenthilNathan. All rights reserved.
//

#import "PostHandler.h"

@implementation PostHandler

-(id)get:(id)parameters {
    
    NSLog(@"PARAMETERS %@", parameters);
    return [NSString stringWithFormat:@"GET Response from parent for parameters %@",parameters];
    
}

-(id)post:(id)parameters {
    
    NSLog(@"PARAMETERS %@", parameters);
    return [NSString stringWithFormat:@"POST Response from parent for parameters %@",parameters];

    
}

-(id)remove:(id)parameters {
    
    NSLog(@"PARAMETERS %@", parameters);
    return [NSString stringWithFormat:@"REMOVE Response from parent for parameters %@",parameters];
    
    
}

-(id)update:(id)parameters {
    
    NSLog(@"PARAMETERS %@", parameters);
    return [NSString stringWithFormat:@"UPDATE Response from parent for parameters %@",parameters];
    
    
}

@end
