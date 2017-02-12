//
//  ZBUser.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBUser : NSObject
//用户名
@property (nonatomic, copy) NSString *username;
//性别
@property (nonatomic, copy) NSString *sex;
//头像
@property (nonatomic, copy) NSString *profile_image;

@end
