//
//  ZBTagTextField.m
//  乐不思蜀
//
//  Created by zboy on 2017/2/1.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBTagTextField.h"

@implementation ZBTagTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        self.height = ZBTagH;
        // 设置了占位文字内容以后, 才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}

-(void)deleteBackward
{
    !self.delateBlock ? : self.delateBlock();
    [super deleteBackward];
}

@end
