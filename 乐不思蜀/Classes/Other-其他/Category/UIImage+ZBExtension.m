//
//  UIImage+ZBExtension.m
//  乐不思蜀
//
//  Created by zboy on 2016/12/21.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "UIImage+ZBExtension.h"

@implementation UIImage (ZBExtension)

-(UIImage *)circleImage
{
    //NO是设置成透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //打开图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);
    //见图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
