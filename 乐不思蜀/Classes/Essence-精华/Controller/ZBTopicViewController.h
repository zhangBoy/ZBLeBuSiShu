//
//  ZBTopicViewController.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/21.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBTopicViewController : UITableViewController

/** 帖子类型(交给子类去实现) */
@property (nonatomic, assign) ZBTopicType type;

@end
