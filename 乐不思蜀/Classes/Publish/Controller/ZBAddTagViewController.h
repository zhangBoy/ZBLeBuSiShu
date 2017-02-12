//
//  ZBAddTagViewController.h
//  乐不思蜀
//
//  Created by zboy on 2017/1/30.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBAddTagViewController : UIViewController

/**
 所有的标签
 */
@property (nonatomic, strong) NSArray *tags;

/**
 获取tags的block
 */
@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);

@end
