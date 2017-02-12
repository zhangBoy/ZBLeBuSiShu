//
//  ZBCommentViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBCommentViewController.h"
#import "MJRefresh.h"
#import "ZBTopic.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "ZBComment.h"
#import "ZBTopicCell.h"
#import "ZBCommentCell.h"
#import "ZBCommentHeaderView.h"

static NSString * const ZBCommentId = @"comment";

@interface ZBCommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//最热评论
@property (nonatomic, strong) NSArray *hotComments;
//最新评论
@property (nonatomic,strong) NSMutableArray *latesComments;
//保存ForHeaderInSection的高度
@property (nonatomic, assign) CGFloat headerHeight;
//保存帖子的top_cmt
@property (nonatomic, strong) ZBComment *saved_top_cmt;
//保存当前的页码
@property (nonatomic, assign) NSInteger page;
//网络管理者
@property (nonatomic, assign) AFHTTPSessionManager *manager;
//保存topicCell
@property (nonatomic, strong) ZBTopicCell *cell;

@end

@implementation ZBCommentViewController

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    
    [self setupHeader];
    
    //设置刷新控件
    [self setupRefresh];

}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

- (void)loadNewComments
{
    //结执之前的刷新状态
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        }//说明没有评论数据
        
        //最热评论
        self.hotComments = [ZBComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        //最新评论
        self.latesComments = [ZBComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //页码
        self.page = 1;
        //刷新数据
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latesComments.count >= total) {//全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreComments
{
    //结束之前停止所有刷新
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //页码
    NSInteger page = self.page + 1;
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    ZBComment *cmt = [self.latesComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }//说明没有评论数据

        
        //最新评论
        NSArray *newComments = [ZBComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latesComments addObjectsFromArray:newComments];
        //页码
        self.page = page;
        //刷新数据
        [self.tableView reloadData];
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latesComments.count >= total) {//全部加载
            self.tableView.mj_footer.hidden = YES;
        } else {//结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)setupHeader
{
    //创建header
    UIView *header = [[UIView alloc] init];
    
    //清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    //添加cell
    ZBTopicCell *cell = [ZBTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.size = CGSizeMake(ZBScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    self.cell = cell;
    
    //header的隐藏
    header.height = self.topic.cellHeight + ZBTopicCellMargin;
    
    //设置header
    self.tableView.tableHeaderView = header;
}

- (void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //cell设置高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //设置背景颜色
    self.tableView.backgroundColor = ZBGlobalBg;
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, ZBTopicCellMargin, 0);
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBCommentCell class]) bundle:nil] forCellReuseIdentifier:ZBCommentId];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSpace.constant = ZBScreenH - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画 及时刷新
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - <UITableViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];

}

#pragma mark - <UITableViewDataSource>
//返回第section组的所有评论数组
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latesComments;
    }
    return self.latesComments;
}

- (ZBComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latesComments.count;
    
    if (hotCount) return 2;//有"最热评论" + "最新评论" 2组
    if (latestCount) return 1;//有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latesComments.count;
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    //非第0组
    return latestCount;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    //创建头部
//    UIView *header = [[UIView alloc] init];
//    header.backgroundColor = ZBGlobalBg;
//    
//    //创建label
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = ZBRGBColor(67, 67, 67);
//    label.width = 200;
//    label.x = ZBTopicCellMargin;
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [header addSubview:label];
//    
//    //设置文字
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论" : @"最新评论";
//    } else {
//        label.text = @"最新评论";
//    }
//    return header;
//
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //先从缓存池中找
    ZBCommentHeaderView *header = [ZBCommentHeaderView headerVieWithTableVeiw:tableView];
    
    //设置文字
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    //被点击的cell
    ZBCommentCell *cell = (ZBCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    //出现第一响应者
    [cell becomeFirstResponder];
    //显示menucontroller
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    menu.menuItems = @[ding,replay,report];
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
    [menu setTargetRect:rect inView:cell];
    [menu setMenuVisible:YES animated:YES];
    
}

#pragma mark - menuIten的处理
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ZBLog(@"%s %@",__func__,[self commentInIndexPath:indexPath].content);
}
- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ZBLog(@"%s %@",__func__,[self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ZBLog(@"%s %@",__func__,[self commentInIndexPath:indexPath].content);
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    //停止所有任务
    [self.manager invalidateSessionCancelingTasks:YES];
    //关闭视频或声音
    [self.cell turnOffPlayer:self.topic cell:self.cell];
    
}
@end
