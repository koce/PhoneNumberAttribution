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
    
    NSString*               _optionString;
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
        
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_records);
}

- (void)updataAddressBook
{
    [self requstAccessAddressBook];
    [self changeAddressBookWithOption:UpdataOptionUpdata];
}

- (void)restoreAddressBook
{
    [self requstAccessAddressBook];
    [self changeAddressBookWithOption:UpdataOptionRestore];
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
    _adressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    __block CFArrayRef array;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_adressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                array = ABAddressBookCopyArrayOfAllPeople(_adressBookRef);
            }
        });
    }else{
        array = ABAddressBookCopyArrayOfAllPeople(_adressBookRef);
    }
    _records = array;
}

- (void)changeAddressBookWithOption:(UpdataOption)option
{
    switch (option) {
        case UpdataOptionUpdata:{
            _optionString = @"更新";
        }
            break;
        case UpdataOptionRestore:{
            _optionString = @"还原";
        }
            break;
        default:
            break;
    }
    
    CFIndex num = CFArrayGetCount(_records);
    NSLog(@"共有%d名联系人", (int)num);
    _status = [NSString stringWithFormat:@"已%@%d/%d个联系人", _optionString, 0, (int)num];
    _progress = .0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showProgress:_progress status:_status maskType:SVProgressHUDMaskTypeBlack];
    });
    
    for (int i = 0; i < num; i++) {
        [self changePersonInIndex:i Option:option TotalCount:(int)num];
    }
    CFRelease(_records);
}

//修改联系人信息
- (void)changePersonInIndex:(int)index Option:(UpdataOption)option TotalCount:(int)num
{
    ABRecordRef person = CFArrayGetValueAtIndex(_records, index);  //获取联系人
    ABMultiValueRef phoneNumber = ABRecordCopyValue(person, kABPersonPhoneProperty);  //获取联系人的所有电话（常量）
    ABMutableMultiValueRef ph = ABMultiValueCreateMutableCopy(phoneNumber);   //将联系人的所有电话复制为可变对象
    CFRelease(phoneNumber);     //release 常量的联系人所有电话
    CFIndex phoneCount = ABMultiValueGetCount(ph); //联系人的电话数量
    BOOL isUpdate = NO;
    for (int j = 0; j < phoneCount; j++) {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(ph, j);   //某个电话的label
        CFStringRef phone = ABMultiValueCopyValueAtIndex(ph, j);   //某个电话的号码
        
        //转换CFStringRef为NSString*，并对CFStringRef对象执行release操作（2种方法）
        NSString *phoneString = (__bridge_transfer NSString *)phone;
        NSString *labelStringOld = CFBridgingRelease(label);
        
        CFStringRef abeyanceLabel = kABHomeLabel;   //归属地label（没有create或copy，不需要管理内存）
        
        if (option == UpdataOptionUpdata) {  //更新通讯录
            NSString *labelString = [self getLabelWithPhoneNumber:phoneString];
            
            if ([labelString isEqualToString:@""] || !labelString) {
                abeyanceLabel = kABHomeLabel;
            }else{
                abeyanceLabel = (__bridge CFStringRef)labelString;
            }
            
        }else if (option == UpdataOptionRestore){  //还原通讯录
            abeyanceLabel = kABHomeLabel;
        }
        
        NSString *labelStringNew = (__bridge NSString*)abeyanceLabel;
        
        if ([labelStringOld isEqualToString:labelStringNew]) {
            isUpdate = NO;
        }else{
            isUpdate = YES;
            ABMultiValueReplaceLabelAtIndex(ph, abeyanceLabel, j);   //修改电话的label
            ABRecordSetValue(person, kABPersonPhoneProperty, ph, nil); //修改联系人的电话属性
        }
    }
    if (isUpdate) {
        ABAddressBookSave(_adressBookRef, nil); //保存通讯录
    }
    
    //release
    CFRelease(ph);
    CFRelease(person);
    
    //更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        _status = [NSString stringWithFormat:@"已%@%d/%d个联系人", _optionString, index + 1, num];
        _progress = (float)(index + 1) / (float)num;
        [SVProgressHUD showProgress:_progress status:_status maskType:SVProgressHUDMaskTypeBlack];
        
        if (index == num - 1) {
            [SVProgressHUD showSuccessWithStatus:@"已完成"];
        }
    });
}

//根据电话号码获取归属地
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
