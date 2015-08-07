//
//  MainTableHeaderView.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "MainTableHeaderView.h"

#define TextFont        [UIFont systemFontOfSize:13]
#define LeftInset       10

@interface MainTableHeaderView (){
    
    NSString*           _title;
    UILabel*            _titleLabel;
}

@end

@implementation MainTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _title = title;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    CGSize textSize = [StringHelper getTextStringSize:@"文字" with:TextFont];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftInset, HeaderViewHeight - textSize.height - 5, DeviceWidth, textSize.height)];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = TextFont;
    
    [self addSubview:_titleLabel];
}

@end
