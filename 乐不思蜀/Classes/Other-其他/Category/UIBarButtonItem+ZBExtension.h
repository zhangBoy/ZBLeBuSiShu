//
//  UIBarButtonItem+ZBExtension.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/27.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZBExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
