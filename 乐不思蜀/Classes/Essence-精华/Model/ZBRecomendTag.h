//
//  ZBRecomendTag.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/11.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRecomendTag : NSObject
//图片
@property (nonatomic, copy) NSString *image_list;
//名字
@property (nonatomic, copy) NSString *theme_name;
//订阅数
@property (nonatomic, assign) NSInteger sub_number;

@end
