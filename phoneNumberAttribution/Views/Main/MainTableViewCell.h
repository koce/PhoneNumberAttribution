//
//  MainTableViewCell.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TextFieldCellHeight     49

@interface MainTableViewCell : UITableViewCell

@property(nonatomic, strong) UITextField*       textField;

- (void)showTextFieldView;
- (void)dismissTextFieldView;

@end
