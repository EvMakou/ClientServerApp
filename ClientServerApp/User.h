//
//  User.h
//  ClientServerApp
//
//  Created by supermacho on 09.10.17.
//  Copyright © 2017 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;

@property (nonatomic, strong) NSURL* imageUrl;



- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
