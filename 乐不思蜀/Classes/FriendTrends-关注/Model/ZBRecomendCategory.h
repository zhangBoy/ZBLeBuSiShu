//
//  ZBRecomendCategory.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/9.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRecomendCategory : NSObject
//id
@property (nonatomic, assign) NSInteger ID;
//总数
@property (nonatomic, assign) NSInteger count;
//名字
@property (nonatomic, copy) NSString *name;

//这个类别对应的与用户数据
@property (nonatomic, strong) NSMutableArray *users;
//总数
@property (nonatomic, assign) NSInteger total;
//当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end
