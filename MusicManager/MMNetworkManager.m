//
//  MMNetworkManager.m
//  MusicManager
//
//  Created by Michael Trimm on 10/2/12.
//  Copyright (c) 2012 MT Design Solutions. All rights reserved.
//

#import "MMNetworkManager.h"
#import "MKNetworkKit.h"
#import "VerificationController.h"
#import "MMUser.h"
#import "NSData+AESAdditions.h"

#define MMServerAddress @"https://www.example.com/mmmusicmanager/api.json"

#warning Change the MMAESSecretKey
#define MMAESSecretKey @"<CHANGE-THIS-KEY-BEFORE-BUILDING>"

@interface MMNetworkManager()
- (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
- (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
- (BOOL) isValidEmail:(NSString *)email;
@end

@implementation MMNetworkManager

/** Singleton Instance */
// MMNetworkManager can only have one instance
// Creates or references new instance of MMNetworkManager
+ (id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)createAccount:(NSString*)emailAddress withPassword:(NSString*)password {
    if([self isValidEmail:emailAddress]){
        NSData *encryptedPassword = [self encryptString:password withKey:MMAESSecretKey];
        NSArray * postKeys = [NSArray arrayWithObjects: @"email", @"password", @"method", nil];
        NSArray * postValues = [NSArray arrayWithObjects:emailAddress, encryptedPassword, "register", nil];
        NSMutableDictionary *postData = [NSDictionary dictionaryWithObjects:postValues forKeys:postKeys];
        MKNetworkOperation *operation = [self operationWithPath:MMServerAddress params:postData httpMethod:@"POST"];
        [operation onCompletion:^(MKNetworkOperation *operation) {
            // Operation Completed Successfully
            NSString *response = [operation responseString];
            if(![response isEqualToString:@"0"]) {
                // Succeeded
                [[MMUser sharedInstance] syncUserFile:emailAddress andBSONId:response];
            } else {
                // Network transmission succeeded but authentication failed
#warning Implement the error handling for authentication failure
            }
            DLog(@"%@", operation);
        } onError:^(NSError *error) {
            // Operation Failed With An Error
            DLog(@"%@", error);
#warning Implement the error handling for if the network connection is either dropped or unavailable
        }];
        [self enqueueOperation:operation];
        
    } else {
#warning Implement the error handing
        // Not a valid email address provided. Present an error now...
    }
}

-(void)authenticateWithEmailAddress:(NSString*)emailAddress andPassword:(NSString *)password {
    if([self isValidEmail:emailAddress]){
        NSData *encryptedPassword = [self encryptString:password withKey:MMAESSecretKey];
        NSArray * postKeys = [NSArray arrayWithObjects: @"email", @"password", @"method", nil];
        NSArray * postValues = [NSArray arrayWithObjects:emailAddress, encryptedPassword, "authenticate", nil];
        NSMutableDictionary *postData = [NSDictionary dictionaryWithObjects:postValues forKeys:postKeys];
        MKNetworkOperation *operation = [self operationWithPath:MMServerAddress params:postData httpMethod:@"POST"];
        [operation onCompletion:^(MKNetworkOperation *operation) {
            // Operation Completed Successfully
            NSString *response = [operation responseString];
            if(![response isEqualToString:@"0"]) {
                // Succeeded
                [[MMUser sharedInstance] syncUserFile:emailAddress andBSONId:response];
            } else {
                // Network transmission succeeded but authentication failed
#warning Implement the error handling for authentication failure
            }
            DLog(@"%@", operation);
        } onError:^(NSError *error) {
            // Operation Failed With An Error
            DLog(@"%@", error);
#warning Implement the error handling for if the network connection is either dropped or unavailable
        }];
        [self enqueueOperation:operation];
        
    } else {
#warning Implement the error handing 
        // Not a valid email address provided. Present an error now...
    }
}

-(void)recordPurchaseWithTransaction:(SKPaymentTransaction*)originalTransaction andSongId:(NSString*)song_id {
    if([[MMUser sharedInstance] authenticated]) {
        NSError *jsonParsingError = nil;
        NSJSONSerialization *transactionJSON = [NSJSONSerialization JSONObjectWithData:originalTransaction.transactionReceipt options:0 error:&jsonParsingError];
        if([[VerificationController sharedInstance] verifyPurchase:originalTransaction]) {
            NSArray *postKeys = [NSArray arrayWithObjects:@"method", @"user_id", @"transactionReceipt", nil];
            NSArray *postValues = [NSArray arrayWithObjects:@"purchase", [[MMUser sharedInstance] getBsonId],transactionJSON , nil];
            NSMutableDictionary *postData = [NSDictionary dictionaryWithObjects:postValues forKeys:postKeys];
            MKNetworkOperation *operation = [self operationWithPath:MMServerAddress params:postData httpMethod:@"POST"];
            [operation onCompletion:^(MKNetworkOperation *operation) {
                // Operation Completed Successfully
                NSString *response = [operation responseString];
                if(![response isEqualToString:@"0"]) {
                    // Succeeded
#warning Implement adding the song_id (records on the remote database) to the Songs.plist file
                } else {
                    // Network transmission succeeded but authentication failed
#warning Implement the error handling for authentication failure
                }
                DLog(@"%@", operation);
            } onError:^(NSError *error) {
                // Operation Failed With An Error
                DLog(@"%@", error);
#warning Implement the error handling for if the network connection is either dropped or unavailable
            }];
            [self enqueueOperation:operation];
        } else {
#warning Handle invalid receipt - thus the purchase was probably made on a jailbroken device
        }
    } else {
#warning Handle error message for not being authenticated
        // Not authenticated
        // FYI - This should NEVER happen
    }
}




/** PRIVATE METHODS */
- (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key {
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
}
- (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
    return [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
}
- (BOOL) isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}
@end