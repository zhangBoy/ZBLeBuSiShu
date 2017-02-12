//
//  ZBTextField.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/13.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTextField.h"
#import <objc/runtime.h>

static NSString * const ZBPlaceholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation ZBTextField

//通过drawPlaceholderInRect:方法绘制占位符文字属性=
//-(void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, self.size.width, 25) withAttributes:@{
//                                                      NSForegroundColorAttributeName:[UIColor grayColor],
//                                                      NSFontAttributeName: self.font
//                                                      }];
//}


/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */
//+(void)initialize{
//    
//    unsigned int count = 0;
//    //拷贝出所有的成员变量
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        //取出成员变量
//        Ivar ivar = *(ivars + i);
//        
//        //打印成员变量名字
//        ZBLog(@"%s",ivar_getName(ivar));
//    }
//    //释放
//    free(ivars);
//}


-(void)awakeFromNib
{
   //设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    //不成为第一响应者
    [self resignFirstResponder];
    
    [super awakeFromNib];
}

//当前文本框聚焦时就会调用
-(BOOL)becomeFirstResponder
{
    //修改占位文字颜色
    [self setValue:self.textColor forKeyPath:ZBPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}

//当前文本框失去焦点时就会调用
-(BOOL)resignFirstResponder
{
    //修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:ZBPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}

@end
