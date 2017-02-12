//
//  ZBPushGuideView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/13.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBPushGuideView.h"

@implementation ZBPushGuideView

+ (void)show
{
    
    NSString *key = @"CFBundleShortVersionString";
    
    //获取当前程序的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        ZBPushGuideView *guideView = [ZBPushGuideView viewFromXib];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

@end
