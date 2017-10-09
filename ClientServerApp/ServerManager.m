//
//  ServerManager.m
//  ClientServerApp
//
//  Created by supermacho on 09.10.17.
//  Copyright © 2017 student. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"
@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* requestSessionManager;

@end

@implementation ServerManager


+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        manager = [[ServerManager alloc]init];
    });
    
    return manager;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}



- (void) getPersonsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* persons)) success
                    inFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"5592362",   @"user_id",
                            @"name",        @"order",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_50",    @"fields",
                            @"nom",        @"name_case",
                            nil];
    
    [self.requestSessionManager GET:@"friends.get" parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary* responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray* dictArray = [responseObject objectForKey:@"response"];
        
        NSMutableArray* objectsArray = [NSMutableArray array];
        
        for (NSDictionary* dict in dictArray) {
            User* user = [[User alloc]initWithServerResponse:dict];
            [objectsArray addObject:user];
        }
        
        if (success) {
            success(objectsArray);
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        if (failure) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) operation.response;
            failure(error, (long)[httpResponse statusCode]);
        }
        
    }];
}



@end
