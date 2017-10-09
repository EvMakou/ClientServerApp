//
//  ServerManager.h
//  ClientServerApp
//
//  Created by supermacho on 09.10.17.
//  Copyright © 2017 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject


+ (ServerManager*) sharedManager; 

- (void) getPersonsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* persons)) success
                    inFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
