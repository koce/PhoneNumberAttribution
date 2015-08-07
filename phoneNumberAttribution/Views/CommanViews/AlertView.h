//
//  AlertView.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertViewType) {
    AlertViewTypeNoAuthority    = 0,
    AlertViewTypeUpdata         = 1,
    AlertViewTypeRestore        = 2,
};

@protocol AlertViewDelegate;

@interface AlertView : UIView

@property (nonatomic, weak) id<AlertViewDelegate> alertDelegate;

- (void)showWithTitle:(NSString *)title Message:(NSString *)message Type:(AlertViewType)type;

- (void)showSelectAlertWithTitle:(NSString *)title Message:(NSString *)message Type:(AlertViewType)type;

- (void)dismiss;

@end


@protocol AlertViewDelegate <NSObject>

- (void)didClikedButtonAtIndex:(NSInteger)buttonIndex Type:(AlertViewType)type;

@end