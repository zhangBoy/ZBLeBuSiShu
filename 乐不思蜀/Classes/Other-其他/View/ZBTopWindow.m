//
//  ZBTopWindow.m
//  乐不思蜀
//
//  Created by zboy on 2016/12/10.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopWindow.h"

static UIWindow *window_;

@implementation ZBTopWindow

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, ZBScreenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    UIViewController *emptyView = [[UIViewController alloc] init];
    window_.rootViewController = emptyView;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];

}

+ (void)show
{
    window_.hidden = NO;
}

+ (void)hide
{
    window_.hidden = YES;
}

+ (void)windowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrolllViewInView:window];
}


+ (void)searchScrolllViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = -subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrolllViewInView:subview];
    }
}

@end
