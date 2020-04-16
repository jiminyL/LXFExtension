//
//  NSData+AES.h
//  KdsSoftHD
//
//  Created by PChome on 14-4-23.
//  Copyright (c) 2014年 PCHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LXFAES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end
