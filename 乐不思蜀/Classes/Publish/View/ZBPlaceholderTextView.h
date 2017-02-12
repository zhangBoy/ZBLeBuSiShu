//
//  ZBPlaceholderTextView.h
//  乐不思蜀
//
//  Created by zboy on 2017/1/18.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBPlaceholderTextView : UITextView

/**
 占位文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 占位文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
