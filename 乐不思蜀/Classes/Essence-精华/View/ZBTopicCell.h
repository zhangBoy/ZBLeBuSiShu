//
//  ZBTopicCell.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/20.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBTopic;

@interface ZBTopicCell : UITableViewCell
/**
 * 帖子数据
 */
@property (nonatomic, strong) ZBTopic *topic;

- (void)turnOffPlayer:(ZBTopic *)topic cell:(ZBTopicCell *)cell;

@end
