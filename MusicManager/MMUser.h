//
//  MMUser.h
//  MusicManager
//
//  Created by Michael Trimm on 10/2/12.
//  Copyright (c) 2012 MT Design Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMUser : NSObject
@property NSString *emailAddress;
@property NSString *bson_id;
-(void)syncUserFile:(NSString *)email andBSONId:(NSString*)bson;
+ (id)sharedInstance;
@end
