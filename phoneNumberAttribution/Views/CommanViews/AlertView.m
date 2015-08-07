//
//  AlertView.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()<UIAlertViewDelegate>{
    UIAlertView*        _myAlertView;
    
    AlertViewType       _type;
}

@end

@implementation AlertView

#pragma mark -- life cycle
- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)]) {
        
    }
    return self;
}

#pragma mark -- AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismiss];
    if (_type != AlertViewTypeNoAuthority) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.alertDelegate didClikedButtonAtIndex:buttonIndex Type:_type];
        });
    }
}

#pragma mark -- public method
- (void)showWithTitle:(NSString *)title Message:(NSString *)message Type:(AlertViewType)type
{
    _type = type;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self addSubview:_myAlertView];
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    [_myAlertView show];
}

- (void)showSelectAlertWithTitle:(NSString *)title Message:(NSString *)message Type:(AlertViewType)type
{
    _type = type;
    self.backgroundColor = [UIColor clearColor];
    _myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [self addSubview:_myAlertView];
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    [_myAlertView show];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
