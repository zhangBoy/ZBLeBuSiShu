//
//  NSString+ZBExtension.m
//  乐不思蜀
//
//  Created by zboy on 2017/2/7.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "NSString+ZBExtension.h"

@implementation NSString (ZBExtension)

+(NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}

@end
