//
//  NSDate+ZBExtension.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/21.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZBExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltafrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end
