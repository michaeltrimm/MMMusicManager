//
//  MMUser.m
//  MusicManager
//
//  Created by Michael Trimm on 10/2/12.
//  Copyright (c) 2012 MT Design Solutions. All rights reserved.
//

#import "MMUser.h"

@implementation MMUser
@synthesize emailAddress;
@synthesize bson_id;

-(void)syncUserFile:(NSString *)email andBSONId:(NSString*)bson {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [directories objectAtIndex: 0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: @"User.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
        NSString* userDictionaryPath = [[NSBundle mainBundle] pathForResource: @"User" ofType: @"plist"];
        NSDictionary* userDictionary = [NSDictionary dictionaryWithContentsOfFile: userDictionaryPath];
        emailAddress = [userDictionary objectForKey:@"emailAddress"];
        bson_id = [userDictionary objectForKey:@"bson_id"];
    } else {
        NSString* userDictionaryPath = [[NSBundle mainBundle] pathForResource: @"User" ofType: @"plist"];
        NSArray *userKeys = [NSArray arrayWithObjects:@"emailAddress",@"bson_id", nil];
        NSArray *userValues = [NSArray arrayWithObjects:email, bson, nil];
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObjects:userValues forKeys:userKeys];
        [userDictionary writeToFile:userDictionaryPath atomically:YES];
        emailAddress = [userDictionary objectForKey:@"emailAddress"];
        bson_id = [userDictionary objectForKey:@"bson_id"];
    }
}

/** Singleton Instance */
+ (id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(BOOL)authenticated {
    if( emailAddress == nil || [emailAddress isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)getEmailAddress {
    return emailAddress;
}
-(NSString*)getBsonId {
    return bson_id;
}
@end
