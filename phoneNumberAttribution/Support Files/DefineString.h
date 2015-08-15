//
//  DefineString.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#ifndef phoneNumberAttribution_DefineString_h
#define phoneNumberAttribution_DefineString_h


#define IsPad               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define DeviceWidth         (IsPad ? 320 : [UIScreen mainScreen].bounds.size.width)
#define DeviceHeight        (IsPad ? 480 : [UIScreen mainScreen].bounds.size.height)

#define StatusBarHeight     20
#define NaviBarHeight       44


#define COLOR(r, g, b)      [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

#define LoadImage(path)     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]

#endif
