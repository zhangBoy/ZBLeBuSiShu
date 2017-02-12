//
//  UIImageView+ZBExtension.m
//  乐不思蜀
//
//  Created by zboy on 2016/12/21.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "UIImageView+ZBExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (ZBExtension)

-(void)setHeader:(NSString *)url
{
    //设置头像
    UIImage *placeHolderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeHolderImage;
    }] ;
}

@end
