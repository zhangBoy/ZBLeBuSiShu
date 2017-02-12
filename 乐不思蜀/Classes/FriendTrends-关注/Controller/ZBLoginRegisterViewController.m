//
//  ZBLoginRegisterViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/12.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBLoginRegisterViewController.h"

@interface ZBLoginRegisterViewController ()
//登录框距离控制器view左边的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation ZBLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置状态栏的颜色为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//
- (IBAction)showLoginOrRegisterAction:(UIButton *)button {
    
    //退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) {//显示注册页面
        self.loginViewLeftMargin.constant = - self.view.width;
        button.selected = YES;
//        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    } else {
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
//        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
