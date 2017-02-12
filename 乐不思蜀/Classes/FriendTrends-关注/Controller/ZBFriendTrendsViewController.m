//
//  ZBFriendTrendsViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/26.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBFriendTrendsViewController.h"
#import "ZBRecomendViewController.h"
#import "ZBLoginRegisterViewController.h"

@interface ZBFriendTrendsViewController ()

@end

@implementation ZBFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置导航栏标题
    self.navigationItem.title = @"我的关注";

    //2.设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon"highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];
    
    //3.设置背景颜色
    self.view.backgroundColor = ZBGlobalBg;
    
}

- (void)friendClick
{
    ZBRecomendViewController *vc = [[ZBRecomendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//登陆注册
- (IBAction)loginRegisterAction:(id)sender {
    ZBLoginRegisterViewController *loginRegisterVC = [[ZBLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
}

@end
