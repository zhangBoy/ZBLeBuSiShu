//
//  ZBTopicVideoView.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBTopic;

@interface ZBTopicVideoView : UIView

/**数据帖子*/
@property (nonatomic, strong) ZBTopic *topic;

- (void)reset;

@end
