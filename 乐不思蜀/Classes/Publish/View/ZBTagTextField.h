//
//  ZBTagTextField.h
//  乐不思蜀
//
//  Created by zboy on 2017/2/1.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBTagTextField : UITextField

/**
 按了删除键的回调
 */
@property (nonatomic, copy) void (^delateBlock)();

@end
