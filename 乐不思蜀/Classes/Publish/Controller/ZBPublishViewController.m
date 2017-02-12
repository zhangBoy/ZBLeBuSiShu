//
//  ZBPublishViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/27.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBPublishViewController.h"
#import "ZBPostWordViewController.h"
#import "ZBVerticalButton.h"
#import "ZBNavigationController.h"
#import "POP.h"

@interface ZBPublishViewController ()

@end

static CGFloat const ZBAnimationDelay = 0.1;
static CGFloat const ZBSpringFactor = 10;

@implementation ZBPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    //数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (ZBScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (ZBScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        ZBVerticalButton *button = [[ZBVerticalButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //设置title
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        //计算X/Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - ZBScreenH;
        
        //按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springSpeed = ZBSpringFactor;
        anim.springBounciness = ZBSpringFactor;
        anim.beginTime = CACurrentMediaTime() + ZBAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    //添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    //标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerEndY = ZBScreenH * 0.2;
    CGFloat centerX = ZBScreenW * 0.5;
    CGFloat centerBeginY = centerEndY - ZBScreenH;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() +images.count * ZBAnimationDelay;
    anim.springSpeed = ZBSpringFactor;
    anim.springBounciness = ZBSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //标语动画完毕，恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    
}


- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 2) {
            ZBPostWordViewController *postWord = [[ZBPostWordViewController alloc] init];
            ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:postWord];
            
            //这里不能用self弹出控制器，因为self执行了dismiss操作
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
        }
    }];}

- (IBAction)cancel {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self cancelWithCompletionBlock:nil];
}

/**
 * 先执行退出动画，动画完毕后执行completionBlock
 */

- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    
    for (int i = beginIndex; i<self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + ZBScreenH;
        // 动画的执行节奏(一开始很慢, 后面很快)
        //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * ZBAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // 执行传进来的completionBlock参数
                //                if (completionBlock) {
                //                    completionBlock();
                //                }
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

@end
