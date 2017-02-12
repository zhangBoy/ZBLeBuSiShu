//
//  ZBRecomendViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/9.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendViewController.h"
#import "ZBRecomendCategoryCell.h"
#import "ZBRecomendUserCell.h"
#import "ZBRecomendCategory.h"
#import "ZBRecomendUser.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define ZBSelectedCategory self.categories[self.categoryTableview.indexPathForSelectedRow.row]

@interface ZBRecomendViewController () <UITableViewDataSource,UITableViewDelegate>
//左边类型表格
@property (weak, nonatomic) IBOutlet UITableView *categoryTableview;
//左边类型数据
@property (nonatomic, strong) NSArray *categories;
//右边的类型表格
@property (weak, nonatomic) IBOutlet UITableView *userTableview;
//右边类型的数据
@property (nonatomic, strong) NSArray *users;
//请求参数
@property (nonatomic, strong) NSMutableDictionary *params;
//AFN请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ZBRecomendViewController

static NSString * const ZBCategoryId = @"category";
static NSString * const ZBUserId = @"user";

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //控件初始化
    [self setupTableview];
    
    //添加刷新控件
    [self setupRefresh];
    
    //加载左侧的类别数据
    [self loadCategories];
    
}

//加载左侧的类别数据
- (void)loadCategories
{
    //显示指示器
    [SVProgressHUD show];
    
    //发送请求
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"a"] = @"category";
    parames[@"c"] = @"subscribe";
    [self.manager  GET:@"http://api.budejie.com/api/api_open.php" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //显示器消失
        [SVProgressHUD dismiss];
        
        //字典转模型
        self.categories = [ZBRecomendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.categoryTableview reloadData];
        
        //默认选中首行
        [self.categoryTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        // 让用户表格进入下拉刷新状态
        [self.userTableview.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //显示错误信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败"];
    }];
}

- (void)setupTableview
{
    //注册
    [self.categoryTableview registerNib:[UINib nibWithNibName:NSStringFromClass([ZBRecomendCategoryCell class]) bundle:nil] forCellReuseIdentifier:ZBCategoryId];
    [self.userTableview registerNib:[UINib nibWithNibName:NSStringFromClass([ZBRecomendUserCell class]) bundle:nil] forCellReuseIdentifier:ZBUserId];
    
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableview.contentInset = _categoryTableview.contentInset;
    self.userTableview.rowHeight = 70;
    
    //设置标题
    self.title = @"推荐关注";
    
    // 设置背景色
    self.view.backgroundColor = ZBGlobalBg;
}

//添加刷新控件
- (void)setupRefresh
{
    self.userTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark - 加载用户数据
- (void)loadNewUsers
{
    ZBRecomendCategory *c = ZBSelectedCategory;
    //当前页码
    c.currentPage = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(c.ID);
    params[@"page"] = @(c.currentPage);
    self.params = params;
    [self.manager  GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
       NSArray *users = [ZBRecomendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //清除所有旧数据
        [c.users removeAllObjects];
        
        //添加到当前类别的用户数组中
        [c.users addObjectsFromArray:users];
        
        //保存总数
        c.total = [responseObject[@"total"] integerValue];
        //不是最后一次请求
        if (self.params != params) return;
        
        //刷新右边的表格
        [self.userTableview reloadData];
        
        //结束刷新
        [self.userTableview.mj_header endRefreshing];
        
        //让底部控结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.userTableview.mj_header endRefreshing];
    }];

}

- (void)loadMoreUsers
{
    ZBRecomendCategory *category = ZBSelectedCategory;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users = [ZBRecomendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        //刷新右边的表格
        [self.userTableview reloadData];
        
        //让底部控结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
         if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.userTableview.mj_header endRefreshing];
    }];
}

//时刻检测footer的状态
- (void)checkFooterState
{
    ZBRecomendCategory *c = ZBSelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.userTableview.mj_footer.hidden = (c.users.count == 0);
    
    //让底部控件结束刷新
    if (c.users.count == c.total) {// 全部数据已经加载完毕
        [self.userTableview.mj_footer endRefreshingWithNoMoreData];
    } else {// 还没有加载完毕
        [self.userTableview.mj_footer endRefreshing];
    }
}


#pragma mark - <UITableviewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 左边的类别表格
    if (tableView == self.categoryTableview)
        return self.categories.count;
    
    //监测footer的状态
    [self checkFooterState];
    
    // 右边的用户表格
    return [ZBSelectedCategory users].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableview) {
        ZBRecomendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBCategoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    } else {
        ZBRecomendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBUserId];
        cell.user = [ZBSelectedCategory users][indexPath.row];
        return cell;
    }
    
}

#pragma mark - <UITableviewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //结束刷新
    [self.userTableview.mj_header endRefreshing];
    [self.userTableview.mj_footer endRefreshing];
    
    ZBRecomendCategory *c = self.categories[indexPath.row];
    if (c.users.count) {
        //显示曾经的数据
        [self.userTableview reloadData];
    } else {
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.userTableview reloadData];
        
        // 进入下拉刷新状态
        [self.userTableview.mj_header beginRefreshing];
    }
    
}

#pragma maek -  控制器的销毁
-(void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}

@end
