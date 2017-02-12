//
//  ZBRecomendUser.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/10.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRecomendUser : NSObject
//头像
@property (nonatomic, copy) NSString *header;
//粉丝数
@property (nonatomic, assign) NSInteger *fans_count;
//昵称
@property (nonatomic, copy) NSString *screen_name;


@end
