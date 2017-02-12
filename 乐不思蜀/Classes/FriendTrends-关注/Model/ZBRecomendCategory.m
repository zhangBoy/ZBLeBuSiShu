//
//  ZBRecomendCategory.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/9.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendCategory.h"
#import "MJExtension.h"

@implementation ZBRecomendCategory

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

//+ (NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName
//{
//    // propertyName == myName == myHeight
//    if ([propertyName isEqualToString:@"ID"]) return @"id";
//
//    return propertyName;
//}

-(NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
