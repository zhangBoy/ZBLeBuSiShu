//
//  UIBarButtonItem+ZBExtension.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/27.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "UIBarButtonItem+ZBExtension.h"

@implementation UIBarButtonItem (ZBExtension)
+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size =  button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
