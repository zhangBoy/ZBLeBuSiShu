//
//  ZBNewViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/26.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBNewViewController.h"

@interface ZBNewViewController ()

@end

@implementation ZBNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //2.设置导航栏左边的按钮
 self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    //3.设置背景颜色
    self.view.backgroundColor = ZBGlobalBg;
    

}

- (void)tagClick
{
    ZBLogFunc;
}

@end
