//
//  User.m
//  ClientServerApp
//
//  Created by supermacho on 09.10.17.
//  Copyright © 2017 student. All rights reserved.
//

#import "User.h"

@implementation User


- (id) initWithServerResponse:(NSDictionary*) responseObject;{
    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageUrl = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

@end
