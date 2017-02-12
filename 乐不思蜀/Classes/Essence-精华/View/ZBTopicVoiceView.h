//
//  ZBTopicVoiceView.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBTopic;

@interface ZBTopicVoiceView : UIView

/**帖子的数据*/
@property (nonatomic, strong) ZBTopic *topic;

- (void)reset;

@end
