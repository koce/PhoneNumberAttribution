//
//  AddressBookModel.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "AddressBookModel.h"

static AddressBookModel*        addresBook;

typedef NS_ENUM(NSInteger, UpdataOption) {
    UpdataOptionUpdata      = 0,
    UpdataOptionRestore     = 1,
};

@interface AddressBookModel (){
    ABAddressBookRef        _adressBookRef;
    CFArrayRef              _records;
    
    __block NSString*       _status;
    __block float           _progress;
}

@end

@implementation AddressBookModel

+ (instancetype)sharedManager
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        addresBook = [[AddressBookModel alloc] init];
    });
    return addresBook;
}

- (instancetype)init
{
    if (self = [super init]) {
        _adressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}

- (void)updataAddressBook
{
    [self requstAccessAddressBook];
    [self updataAddressBookWithOption:UpdataOptionUpdata];
}

- (void)restoreAddressBook
{
    [self requstAccessAddressBook];
    [self updataAddressBookWithOption:UpdataOptionRestore];
}

- (NSString *)attributionWithPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 7) {
        phoneNumber = [phoneNumber stringByAppendingString:@"1111"];
    }else if (phoneNumber.length == 3){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }else if (phoneNumber.length == 4){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }
    return [self getLabelWithPhoneNumber:phoneNumber LabelType:NO];
}

#pragma maek -- private method
- (void)requstAccessAddressBook
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_adressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                _records = ABAddressBookCopyArrayOfAllPeople(_adressBookRef);
            }
        });
    }else{
        _records = ABAddressBookCopyArrayOfAllPeople(_adressBookRef);
    }
}

- (void)updataAddressBookWithOption:(UpdataOption)option
{
    NSString *optionString;
    switch (option) {
        case UpdataOptionUpdata:{
            optionString = @"更新";
        }
            break;
        case UpdataOptionRestore:{
            optionString = @"还原";
        }
            break;
        default:
            break;
    }
    
    CFIndex num = CFArrayGetCount(_records);
    NSLog(@"共有%d名联系人", (int)num);
    _status = [NSString stringWithFormat:@"已%@%d/%d个联系人", optionString, 0, (int)num];
    _progress = .0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showProgress:_progress status:_status maskType:SVProgressHUDMaskTypeBlack];
    });
    
    for (int i = 0; i < num; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(_records, i);
        ABMultiValueRef phoneNumber = ABRecordCopyValue(person, kABPersonPhoneProperty);
        ABMutableMultiValueRef ph = ABMultiValueCreateMutableCopy(phoneNumber);
        CFIndex phoneCount = ABMultiValueGetCount(phoneNumber);
        BOOL isUpdate = NO;
        for (int j = 0; j < phoneCount; j++) {
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNumber, j);
            CFStringRef phone = ABMultiValueCopyValueAtIndex(phoneNumber, j);
            
            CFStringRef abeyanceLabel = kABHomeLabel;
            
            if (option == UpdataOptionUpdata) {
                NSString *labelString = [self getLabelWithPhoneNumber:(__bridge NSString *)phone];
                if ([labelString isEqualToString:@""] || !labelString) {
                    abeyanceLabel = kABHomeLabel;
                }else{
                    abeyanceLabel = (__bridge CFStringRef)labelString;
                }
            }
            NSString *labelStringOld = (__bridge NSString*)label;
            NSString *labelStringNew = (__bridge NSString*)abeyanceLabel;
            if ([labelStringOld isEqualToString:labelStringNew]) {
                isUpdate = NO;
            }else{
                ABMultiValueReplaceLabelAtIndex(ph, abeyanceLabel, j);
                ABRecordSetValue(person, kABPersonPhoneProperty, ph, nil);
            }
        }
        if (isUpdate) {
            ABAddressBookSave(_adressBookRef, nil);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _status = [NSString stringWithFormat:@"已%@%d/%d个联系人", optionString, i + 1, (int)num];
            _progress = (float)(i + 1) / (float)num;
            [SVProgressHUD showProgress:_progress status:_status maskType:SVProgressHUDMaskTypeBlack];
            
            if (i == num - 1) {
                [SVProgressHUD showSuccessWithStatus:@"已完成"];
            }
        });
    }
    _records = nil;
}

- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber
{
    return [self getLabelWithPhoneNumber:phoneNumber LabelType:YES];
}

- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber LabelType:(BOOL)labelType
{
    NSString *phone = [StringHelper getPhoneNumberWithString:phoneNumber];
    if ([phone isEqualToString:@""] || !phone) {
        return @"";
    }
    NSString *area, *type;
    if (phone.length > 4) {
        area = [[SQLHelper sharedManager] selectAreaWithPhoneNumber:phone];
        type = [[SQLHelper sharedManager] selectTypeWithPhoneNumber:phone];
    }else{
        area = [[SQLHelper sharedManager] selectAreaWithAreaCode:phone];
        type = @"电话";
    }
    
    if (labelType) {
        NSString *city = [StringHelper getCityWithString:area];
        NSString *provice = [StringHelper getProviceWithString:area];
        area = [provice stringByAppendingString:city];
        
        type = [StringHelper getSimpleMobileTypeWithString:type];
    }
    
    if (![area isEqualToString:@""] && area) {
        return [NSString stringWithFormat:@"%@ %@", area, type];
    }
    return @"";
}

@end
