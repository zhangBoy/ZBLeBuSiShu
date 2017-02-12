//
//  ZBWordViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/14.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopicViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ZBTopic.h"
#import "ZBTopicCell.h"
#import "ZBCommentViewController.h"
#import "ZBNewViewController.h"

@interface  ZBTopicViewController()

//帖子数据
@property (nonatomic, strong) NSMutableArray *topics;
//页码
@property (nonatomic, assign) NSInteger page;
//加载下一页数据需要的maxtime
@property (nonatomic, copy) NSString *maxtime;
//上一次请求的参数
@property (nonatomic, strong) NSDictionary *params;
//上次选中的索引或者控制器
@property (nonatomic, assign) NSInteger lastSelectIndex;

@end

@implementation ZBTopicViewController

static NSString * const ZBTopicCellId = @"Topic";

-(NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
}

- (void)setupTableView
{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = ZBTitlesViewX + ZBTitlesViewY;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBTopicCell class]) bundle:nil] forCellReuseIdentifier:ZBTopicCellId];
    
    //监听TabBar点击的通知
    [ZBNoteCenter addObserver:self selector:@selector(tabBarSelect) name:ZBTabBarDidSelectNOtification object:nil];
}

- (void)tabBarSelect
{
    //连续两次点击，直接刷新
    if (self.lastSelectIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    //记录这一次选中的索引
    self.lastSelectIndex = self.tabBarController.selectedIndex;
    
}

- (void)setupRefresh
{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}

#pragma mark - a参数
- (NSString *)a
{
    return  [self.parentViewController isKindOfClass:[ZBNewViewController class]] ? @"newlist" : @"list";
}

#pragma mark - 数据处理
/**
 *  加载新帖子的数据
 */
- (void)loadNewTopics
{
    //结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
//    ZBLog(@"params--%@",params);
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZBLog(@"responseObject-----%@",responseObject);

        if (self.params != params) return;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //字典数组->模型数组
        self.topics = [ZBTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

// 先下拉刷新, 再上拉刷新第5页数据

// 下拉刷新成功回来: 只有一页数据, page == 0
// 上啦刷新成功回来: 最前面那页 + 第5页数据

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics
{
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (self.params != params) return;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //字典数组->模型数组
        NSArray *topics = [ZBTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:topics];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        //设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZBTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - Table view Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
    ZBTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCommentViewController *commentVC = [[ZBCommentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    
    //跳转页面后视频或声音要关闭
    ZBTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell turnOffPlayer:commentVC.topic cell:cell];
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
}



@end
