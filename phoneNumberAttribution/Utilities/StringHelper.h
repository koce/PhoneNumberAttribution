//
//  StringHelper.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

+ (CGSize)getTextStringSize:(NSString *)aString with:(UIFont *)font;

+ (NSString *)getDataBasePath;

+ (NSString *)getPhoneNumberWithString:(NSString *)string;

+ (NSString *)getProviceWithString:(NSString *)string;

+ (NSString *)getCityWithString:(NSString *)string;

+ (NSString *)getSimpleMobileTypeWithString:(NSString *)string;

@end
