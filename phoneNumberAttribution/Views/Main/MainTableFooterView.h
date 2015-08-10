//
//  MainTableFooterView.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/10.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FooterViewHeight        20

@interface MainTableFooterView : UIView

@property(nonatomic, assign) BOOL hasTitle;

- (void)updateTitle:(NSString *)title;

@end
