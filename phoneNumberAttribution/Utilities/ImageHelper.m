//
//  ImageHelper.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
