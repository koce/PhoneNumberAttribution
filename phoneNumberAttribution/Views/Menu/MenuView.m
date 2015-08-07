//
//  MenuView.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "MenuView.h"

#define DURATION        0.3

@interface MenuView (){
    
}

@end

@implementation MenuView

#pragma mark -- life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        [self initUI];
    }
    return self;
}

#pragma mark -- UI
- (void)initUI
{
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(100 + 10, 15, 21, 13)];
    [backBtn setImage:LoadImage(MenuBackImage) forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource


#pragma mark -- public method
- (void)showMenu
{
    self.hidden = NO;
    
    [UIView animateWithDuration:DURATION animations:^{
        CGRect rect = self.frame;
        rect.origin.x = 0;
        self.frame = rect;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:DURATION animations:^{
        CGRect rect = self.frame;
        rect.origin.x = DeviceWidth * -1;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark -- private method

@end
