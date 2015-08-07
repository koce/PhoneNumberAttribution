//
//  StringHelper.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

+(CGSize)getTextStringSize:(NSString *)aString with:(UIFont *)font
{
    CGSize size = [aString sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    return size;
}

+ (NSString *)getDataBasePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
    return path;
}

+ (NSString *)getPhoneNumberWithString:(NSString *)string
{
    NSString *result = @"";
    //1**********格式的手机
    NSString*   regex = @"^[1][34578]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([regextestmobile evaluateWithObject:string]){
        result = [string substringWithRange:NSMakeRange(0, 7)];
        return result;
    }
    
    //1**-****-****格式的手机
    regex = @"^1[34578]\\d[-]\\d{4}[-]\\d{4}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        result = [[string substringWithRange:NSMakeRange(0, 3)] stringByAppendingString:[string substringWithRange:NSMakeRange(4, 4)]];
        return result;
    }
    
    //1-***-***-****格式的手机
    regex = @"^1[-][34578]\\d{2}[-]\\d{3}[-]\\d{4}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        result = [[[string substringWithRange:NSMakeRange(0, 1)] stringByAppendingString:[string substringWithRange:NSMakeRange(2, 3)]]
                  stringByAppendingString:[string substringWithRange:NSMakeRange(6, 3)]];
        return result;
    }
    
    //+861**********格式的手机
    regex = @"^\\+861[34578]\\d{9}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        result = [string substringWithRange:NSMakeRange(3, 7)];
        return result;
    }
    
    //+86 1**-****-****格式的手机
    regex = @"^\\+86 1[34578]\\d[-]\\d{4}[-]\\d{4}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        result = [[string substringWithRange:NSMakeRange(4, 3)] stringByAppendingString:[string substringWithRange:NSMakeRange(8, 4)]];
        return result;
    }
    
    //0***-********格式的电话
    regex = @"^([0]\\d{2,3}-)\\d{7,8}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        NSRange range = [string rangeOfString:@"-"];
        result = [string substringWithRange:NSMakeRange(0, range.location)];
        return result;
    }
    
    //0***********格式的电话
    regex = @"^0\\d{2,3}\\d{8}$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string]){
        if (string.length == 11) {
            result = [string substringWithRange:NSMakeRange(0, 3)];
        }else{
            result = [string substringWithRange:NSMakeRange(0, 4)];
        }
        return result;
    }
    
    return result;
}

+ (NSString *)getProviceWithString:(NSString *)string
{
    NSRange range = [string rangeOfString:@" "];
    if (range.length == 0) {
        return @"";
    }
    return [string substringWithRange:NSMakeRange(0, range.location)];
}

+ (NSString *)getCityWithString:(NSString *)string
{
    NSRange range = [string rangeOfString:@" "];
    NSString *result;
    if (range.length == 0) {
        result = string;
    }else{
        result = [string substringWithRange:NSMakeRange(range.location + 1, string.length - range.location - 1)];
    }
    if ([result hasSuffix:@"市"]) {
        result = [result substringWithRange:NSMakeRange(0, result.length - 1)];
    }
    return result;
}

+ (NSString *)getSimpleMobileTypeWithString:(NSString *)string
{
    if ([string containsString:@"移动"]) {
        return @"移动";
    }else if ([string containsString:@"联通"]) {
        return @"联通";
    }else if ([string containsString:@"电信"]) {
        return @"电信";
    }
    return string;
}

@end
