//
//  ZBEssenceViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/26.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBEssenceViewController.h"
#import "ZBRecomendTagsViewController.h"
#import "ZBTopicViewController.h"

@interface ZBEssenceViewController () <UIScrollViewDelegate>

//顶部标题栏红色指示器
@property (nonatomic, weak) UIView *indicatorView;
//顶部标题栏红色指示器
@property (nonatomic, weak) UIButton *selectedButton;
//顶部标题栏
@property (nonatomic, weak) UIView *titlesView;
//底部的所有内容
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation ZBEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavigation];
    
    //初始化子控制器
    [self setupChildVCes];
    
    //设置顶部的标签栏
    [self setupTitlesView];
    
    //设置底部scrollView
    [self setupContenView];
    
}

//设置导航栏
- (void)setupNavigation
{
    //1.设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //2.设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    //3.设置背景颜色
    self.view.backgroundColor = ZBGlobalBg;
}

//设置顶部的标签栏
- (void)setupTitlesView
{
    //标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 64;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    //底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;

    
    //内部子标签
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat height = titlesView.height;
    CGFloat width = titlesView.width/titles.count;
    for (NSInteger i = 0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.height = height;
        button.width = width;
        button.x = i * width;
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        //默认点击第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}

//底部的scrollView
- (void)setupContenView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    // 设置内边距
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
//    contentView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
}
//初始化子控制器
- (void)setupChildVCes
{
    ZBTopicViewController *allVC = [[ZBTopicViewController alloc] init];
    allVC.title = @"全部";
    allVC.type = ZBTopicTypeAll;
    [self addChildViewController:allVC];
    
    ZBTopicViewController *videoVC = [[ZBTopicViewController alloc] init];
    videoVC.title = @"视频";
    videoVC.type = ZBTopicTypeVideo;
    [self addChildViewController:videoVC];
    
    ZBTopicViewController *voiceVC = [[ZBTopicViewController alloc] init];
    voiceVC.title = @"声音";
    voiceVC.type = ZBTopicTypeVoice;
    [self addChildViewController:voiceVC];
    
    ZBTopicViewController *pictureVC = [[ZBTopicViewController alloc] init];
    pictureVC.title = @"图片";
    pictureVC.type = ZBTopicTypePicture;
    [self addChildViewController:pictureVC];
    
    ZBTopicViewController *wordVC = [[ZBTopicViewController alloc] init];
    wordVC.title = @"段子";
    wordVC.type = ZBTopicTypeWord;
    [self addChildViewController:wordVC];
}

- (void)titleClick:(UIButton *) button
{
    //设置按钮的状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    /// 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}

- (void)tagClick
{
    ZBRecomendTagsViewController *vc = [[ZBRecomendTagsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;//设置控制器view的y为0（默认20）
    vc.view.height = scrollView.height;// 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    [scrollView addSubview:vc.view];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

@end
