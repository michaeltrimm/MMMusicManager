//
//  MMMusicManager.m
//  MusicManager
//
//  Created by Michael Trimm on 10/2/12.
//  Copyright (c) 2012 MT Design Solutions. All rights reserved.
//

#import "MMMusicManager.h"
// MKStoreKit
#import "MKStoreManager.h"
#import "VerificationController.h"
@implementation MMMusicManager
@synthesize availableSongs;

/** Setup Music Manager */
// Populates IV availableSongs
// Creates or loads Documents/Songs.plist
-(id)init {
    if(self = [super init]) {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [directories objectAtIndex: 0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: @"Songs.plist"];
        // If the file exists, load contents of Songs.plist into availableSongs
        // If the file does not exist, create it and set the created_on key inside Songs.plist
        // Eitherway, availableSongs is being populated with created_on
        if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
            NSString* songsDictionaryPath = [[NSBundle mainBundle] pathForResource: @"Songs" ofType: @"plist"];
            NSDictionary* songsDictionary = [NSDictionary dictionaryWithContentsOfFile: songsDictionaryPath];
            [songsDictionary writeToFile:songsDictionaryPath atomically:YES];
            availableSongs = songsDictionary;
        } else {
            NSString* songsDictionaryPath = [[NSBundle mainBundle] pathForResource: @"Songs" ofType: @"plist"];
            NSDictionary* songsDictionary = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"created_on"];
            [songsDictionary writeToFile:songsDictionaryPath atomically:YES];
            availableSongs = songsDictionary;
        }
        // Songs.plist
        /**
         *      created_on => NSDate
         *      song => NSDictionary
         *          name            => NSString
         *          author          => NSString
         *          coverArtPath    => NSString
         *          path            => NSString
         *          purchased_on    => NSDate
         *          price           => Float
         *          receiptId       => NSString         # Database ID Referencing Receipt
         *          duration        => Integer          # Minutes
         *          playCount       => Integer 
         *          fileExists      => Boolean          # Flag that is set everytime the song is attempted
         *          active          => Boolean          # Set to NO if file doesn't exist or receipt is invalid
         *
         */
    }
    return self;
}

/** Singleton Instance */
// MMMusicManager can only have one instance
// Creates or references new instance of MMMusicManager
+ (id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/** Add Song To Profile */
-(void)addSongToProfile:(SKPaymentTransaction*)transaction withSongName:(NSString *)songName {
    if([[VerificationController sharedInstance] verifyPurchase:transaction]) {
        
    } else {
        
    }
}






@end
