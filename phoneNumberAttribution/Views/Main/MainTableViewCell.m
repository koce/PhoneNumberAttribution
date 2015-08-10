//
//  MainTableViewCell.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "MainTableViewCell.h"

#define TextFont        [UIFont systemFontOfSize:16]

@interface MainTableViewCell (){
    
}

@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, TextFieldCellHeight)];
    self.textField.placeholder = @"请输入手机号前7位或区号";
    self.textField.font = TextFont;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)showTextFieldView
{
    [self addSubview:self.textField];
}

- (void)dismissTextFieldView
{
    [self.textField removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
