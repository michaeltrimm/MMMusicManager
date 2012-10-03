//
//  NSData+AESAdditions.h
//  MusicManager
//
//  Created by Michael Trimm on 10/2/12.
//  Copyright (c) 2012 MT Design Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end
