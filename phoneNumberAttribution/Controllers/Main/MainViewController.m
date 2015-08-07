//
//  MainViewController.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/5.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainTableHeaderView.h"
#import "AddressBookModel.h"
#import "AlertView.h"
#import "MenuView.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AlertViewDelegate>{
    UITableView*            _tableView;
    
    AlertView*              _alertView;
    MenuView*               _menuView;
    
}

@end

@implementation MainViewController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"号码归属地助手";
    
//    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 16)];
//    [menuBtn setImage:LoadImage(MenuBtnImage) forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(pressMenuBtn) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:LoadImage(MenuBtnImage) style:UIBarButtonItemStylePlain target:self action:@selector(pressMenuBtn)];
//    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(pressMenuBtn)];
//    
//    self.navigationItem.leftBarButtonItem = barBtn;
    
    [self initUI];
}

#pragma mark -- UI
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - NaviBarHeight - StatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR(244, 244, 244);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _alertView = [[AlertView alloc] init];
    _alertView.alertDelegate = self;
    
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake(DeviceWidth * -1, StatusBarHeight, DeviceWidth, DeviceHeight - StatusBarHeight)];
    [[UIApplication sharedApplication].windows[0] addSubview:_menuView];
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0){
        return 0.1;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainTableViewCellIdentify = @"mainTableViewCell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:mainTableViewCellIdentify];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainTableViewCellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"更新通讯录";
                cell.detailTextLabel.text = @"更新后，联系人的电话号码标签显示归属地";
            }
                break;
            case 1:{
                cell.textLabel.text = @"还原通讯录";
                cell.detailTextLabel.text = @"还原后，联系人的电话号码标签不显示归属地";
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"电话号码归属地设置";
    if (section == 1) {
        title = @"电话号码归属地查询";
    }
    MainTableHeaderView *view = [[MainTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, HeaderViewHeight) Title:title];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] init];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title, *message;
    AlertViewType type;
    if (![self getAddressBookStatus]) {
        title = @"通讯录访问权限未开启";
        message = @"请在系统设置中开启通讯录访问权限\n设置->隐私->通讯录";
        type = AlertViewTypeNoAuthority;
        [_alertView showWithTitle:title Message:message Type:type];
        return;
    }
    title = @"更新通讯录？";
    message = @"";
    type = AlertViewTypeUpdata;
    if (indexPath.row == 1) {
        title = @"还原通讯录？";
        type = AlertViewTypeRestore;
    }
    [_alertView showSelectAlertWithTitle:title Message:message Type:type];
}

#pragma mark -- UITextFieldDelegate

#pragma maek -- AlertViewDelegate
- (void)didClikedButtonAtIndex:(NSInteger)buttonIndex Type:(AlertViewType)type
{
    if (buttonIndex == 0) {
        return;
    }
    switch (type) {
        case AlertViewTypeUpdata:{
            [[AddressBookModel sharedManager] updataAddressBook];
        }
            break;
        case AlertViewTypeRestore:{
            [[AddressBookModel sharedManager] restoreAddressBook];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- response
- (void)pressMenuBtn
{
    [_menuView showMenu];
}

#pragma mark -- private method
- (BOOL)getAddressBookStatus
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined &&
        ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}

@end
