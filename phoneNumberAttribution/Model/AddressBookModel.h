//
//  AddressBookModel.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

//typedef NS_ENUM(NSInteger, PhoneLabelType) {
//    PhoneLabelTypeArea_Type     = 0,
//    PhoneLabelTypeType_Area     = 1,
//    PhoneLabelTypeAreaOnly      = 2,
//    PhoneLabelTypeTypeOnly      = 3,
//};
//
//typedef NS_ENUM(NSInteger, AreaType) {
//    AreaTypeProviceOnly     = 0,
//    AreaTypeCityOnly        = 1,
//    AreaTypeProvice_City    = 2,
//};
//
//typedef NS_ENUM(NSInteger, MobileType) {
//    MobileTypeSimple        = 0,
//    MobileTypeAll           = 1,
//};

@interface AddressBookModel : NSObject

+ (instancetype)sharedManager;

- (void)updataAddressBook;

- (void)restoreAddressBook;

@end