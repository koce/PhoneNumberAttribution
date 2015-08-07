//
//  SQLHelper.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "SQLHelper.h"

static SQLHelper*       sqlHelper;

@interface SQLHelper (){
    sqlite3*        _database;
}

@end

@implementation SQLHelper

+ (instancetype)sharedManager
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        sqlHelper = [[SQLHelper alloc] init];
    });
    return sqlHelper;
}

- (instancetype)init
{
    if (self = [super init]) {
        if (sqlite3_open([[StringHelper getDataBasePath] UTF8String], &_database) != SQLITE_OK) {
            sqlite3_close(_database);
            NSAssert(0, @"Failed to open database");
        }
    }
    return self;
}

- (NSString *)selectAreaWithAreaCode:(NSString *)areaCode
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT MobileArea FROM Dm_Mobile where AreaCode='%@'", areaCode];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    return areaString;
}

- (NSString *)selectAreaWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT MobileArea FROM Dm_Mobile where MobileNumber='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
        }
        sqlite3_finalize(stmt);
    }
    return areaString;
}

- (NSString *)selectTypeWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT MobileType FROM Dm_Mobile where MobileNumber='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
        }
        sqlite3_finalize(stmt);
    }
    return areaString;
}


@end
