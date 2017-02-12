//
//  ZBMeViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/26.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBMeViewController.h"
#import "ZBMeCell.h"
#import "ZBMeFooterView.h"

@interface ZBMeViewController () <UITableViewDelegate,UITableViewDataSource>

@end

static NSString *ZBMeCellID = @"me";

@implementation ZBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    
}

- (void)setupNav
{
    //1.设置导航栏的标题
    self.navigationItem.title = @"我的";
    //2.设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems = @[
                                                settingItem,
                                                moonItem,
                                                ];
}

- (void)setupTableView
{
    //设置背景颜色
    self.tableView.backgroundColor = ZBGlobalBg;
    //注册tableViewCell
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZBMeCell class] forCellReuseIdentifier:ZBMeCellID];
    
    //设置header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = ZBTopicCellMargin;
    //设置间距
    self.tableView.contentInset = UIEdgeInsetsMake(ZBTopicCellMargin - 35, 0, 0, 0);
    //设置footerView
    self.tableView.tableFooterView = [[ZBMeFooterView alloc] init];
    
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBMeCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBMeCellID];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}

- (void)settingClick
{
    ZBLogFunc;
}

- (void)moonClick
{
    ZBLogFunc;
}


@end
