//
//  UIView+ZBExtension.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/9/27.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZBExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


//判断是否在主window上面
- (BOOL)isShowingOnKeyWindow;

//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/

+ (instancetype)viewFromXib;

@end
