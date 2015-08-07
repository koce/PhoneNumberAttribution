//
//  SQLHelper.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLHelper : NSObject

+ (instancetype)sharedManager;

- (NSString *)selectAreaWithPhoneNumber:(NSString *)phoneNumber;

- (NSString *)selectTypeWithPhoneNumber:(NSString *)phoneNumber;

- (NSString *)selectAreaWithAreaCode:(NSString *)areaCode;

@end
