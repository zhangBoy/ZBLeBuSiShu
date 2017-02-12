//
//  ZBComment.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBUser;

@interface ZBComment : NSObject
//ID
@property (nonatomic, copy) NSString *ID;
//音频文件时长
@property (nonatomic, assign) NSInteger voicetime;
//音频文件的路径
@property (nonatomic, copy) NSString *voiceuri;
//评论的文字内容
@property (nonatomic, copy) NSString *content;
//被点赞的数量
@property (nonatomic, assign) NSInteger like_count;
//用户
@property (nonatomic, strong) ZBUser *user;

@end
