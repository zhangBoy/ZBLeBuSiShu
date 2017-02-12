//
//  ZBRecomendTagsViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/11.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendTagsViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "ZBRecomendTag.h"
#import "ZBRecomendTagCell.h"
#import "SVProgressHUD.h"


@interface ZBRecomendTagsViewController ()
//标签数据
@property (nonatomic, strong) NSArray *tags;

@end

@implementation ZBRecomendTagsViewController

static NSString * const ZBTagsId = @"tag";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tableView
    [self setupTableView];
    
    //请求tag的数据
    [self loadTags];
    
}

//初始化tableView
- (void)setupTableView
{
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBRecomendTagCell class]) bundle:nil] forCellReuseIdentifier:ZBTagsId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZBGlobalBg;
    
}

#pragma mark - 用户数据请求-推荐关注
- (void)loadTags
{
    [SVProgressHUD show];
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        self.tags = [ZBRecomendTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        //刷新tableView
        [self.tableView reloadData];
        
        //隐藏加载控件
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
    }];
    
}

#pragma mark - UITableView Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBRecomendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBTagsId];
    cell.recomendTag = self.tags[indexPath.row];
    return cell;
}


@end
