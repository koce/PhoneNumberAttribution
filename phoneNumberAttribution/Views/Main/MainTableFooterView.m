//
//  MainTableFooterView.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/10.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "MainTableFooterView.h"

#define TextFont        [UIFont systemFontOfSize:18]

@interface MainTableFooterView (){
    UILabel*        _label;
}

@end

@implementation MainTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.hasTitle = NO;
    }
    return self;
}

- (void)initUI
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, FooterViewHeight)];
    _label.textColor = [UIColor lightGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = TextFont;
    
    [self addSubview:_label];
}

- (void)updateTitle:(NSString *)title
{
    if ([title isEqualToString:@""]) {
        self.hasTitle = NO;
    }else{
        self.hasTitle = YES;
    }
    _label.text = title;
}

@end
