//
//  ZBMeFooterView.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/2.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBMeFooterView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "ZBSquare.h"
#import "UIButton+WebCache.h"
#import "ZBSquareButton.h"
#import "ZBWebViewController.h"


@implementation ZBMeFooterView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        //请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        //发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //字典转模型
            NSArray *squares = [ZBSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            [self creatSquare:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

//-(void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

- (void)creatSquare:(NSArray *)squares
{
     //一行最多4列
    int maxCols = 4;
    
    //宽度和高度
    CGFloat buttonW = ZBScreenW / maxCols;
    CGFloat buttonH = buttonW;
    ZBLog(@"squareCount - %ld",squares.count);
    
    for (int i = 0; i < squares.count; i++) {
        
        ZBSquareButton *button = [ZBSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置模型
        button.square = squares[i];
        [self addSubview:button];
        
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
    }
    
    // 8个方块, 每行显示4个, 计算行数 8/4 == 2 2
    // 9个方块, 每行显示4个, 计算行数 9/4 == 2 3
    // 7个方块, 每行显示4个, 计算行数 7/4 == 1 2
    
    // 总行数
    //    NSUInteger rows = sqaures.count / maxCols;
    //    if (sqaures.count % maxCols) { // 不能整除, + 1
    //        rows++;
    //    }
    
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;
    
    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重绘
    [self setNeedsDisplay];
    
}

- (void)buttonClick:(ZBSquareButton *)button
{
    ZBLog(@"%@",button.square.url);
    
    if (![button.square.url hasPrefix:@"http"]) return;
    
    ZBWebViewController *webViewController = [[ZBWebViewController alloc] init];
    webViewController.title = button.square.name;
    webViewController.url = button.square.url;
    
    //取出当前控制器
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *navigationVC = (UINavigationController *)tabBarVC.selectedViewController;
    [navigationVC pushViewController:webViewController animated:YES];
}

@end
