//
//  ZBVerticalButton.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/12.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBVerticalButton.h"

@implementation ZBVerticalButton

//用于代码创建的按钮控件
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

//用于Xib、StoryBoard创建的按钮控件
- (void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
