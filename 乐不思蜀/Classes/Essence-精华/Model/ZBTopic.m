//
//  ZBTopic.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/14.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopic.h"
#import "ZBComment.h"
#import "ZBUser.h"
#import "MJExtension.h"


@implementation ZBTopic
{
    CGFloat _cellHeight;
    CGRect _pictureF;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"middle_image" : @"image2",
             @"large_image" : @"image1",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"top_cmt":@"ZBComment"};
}

-(NSString *)create_time
{
    //日期格式化
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) {//今年
        if (create.isToday) {//今天
             NSDateComponents *cmps = [[NSDate date] deltafrom:create];
            
            if (cmps.hour >= 1) {//时间差距>=1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) {// 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {//1分钟 > 时间差距
                return @"刚刚";
            }
            
        } else if(create.isYesterday){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else {//其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
        
    } else {//非今年
        return _create_time;
    }
    
}

-(CGFloat)cellHeight
{
//    ZBLog(@"\nbegin---\n%@\n%@\n%@\nend--",self.small_image,self.middle_image,self.large_image);
    
    if (!_cellHeight) {
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * ZBTopicCellMargin, MAXFLOAT);
        
        //计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //cell的高度
       _cellHeight = ZBTopicCellTextY + textH + ZBTopicCellMargin;
        
        //根据段子的类型来计算cell的高度
        if (self.type == ZBTopicTypePicture) {//图片帖子
            //图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            //显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            if (pictureH >= ZBTopicCellPictureMaxH) {//图片高度过长
                pictureH = ZBTopicCellPictureBreakH;
                self.bigPicture = YES;//大图
            }
            
            //计算图片空间的frame
            CGFloat pictureX = ZBTopicCellMargin;
            CGFloat pictureY = ZBTopicCellTextY + textH +ZBTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + ZBTopicCellMargin;
        } else if (self.type == ZBTopicTypeVoice) {//声音帖子
            CGFloat voiceX = ZBTopicCellMargin;
            CGFloat voiceY = ZBTopicCellTextY + textH +ZBTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + ZBTopicCellMargin;
        } else if (self.type == ZBTopicTypeVideo) {//视频帖子
            CGFloat videoX = ZBTopicCellMargin;
            CGFloat videoY = ZBTopicCellTextY + textH +ZBTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + ZBTopicCellMargin;
        }
        
        // 如果有最热评论
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            
            ZBLog(@"%f", contentH);
            _cellHeight += ZBTopicCellTopCmtTitleH + contentH + ZBTopicCellMargin;
        }
        
        //底部工具条的高度
        _cellHeight += ZBTopicCellBottomBarH + ZBTopicCellMargin;
    }
    return _cellHeight;
}

@end
