//
//  ZBTopicPictureView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/25.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopicPictureView.h"
#import "ZBTopic.h"
#import "UIImageView+WebCache.m"
#import "ZBProgressView.h"
#import "ZBShowPictureViewController.h"

@interface ZBTopicPictureView ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//gif标识
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
//查看大图
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
//进度条
@property (weak, nonatomic) IBOutlet ZBProgressView *progressView;

@end

@implementation ZBTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture
{
    ZBShowPictureViewController *showPicture = [[ZBShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

-(void)setTopic:(ZBTopic *)topic
{
    _topic = topic;
    
    /**
     在不知道图片扩展名的情况下, 如何知道图片的真实类型?
     * 取出图片数据的第一个字节, 就可以判断出图片的真实类型
     */
    
    // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        //计算进度值
        self.topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        //显示进度值
        [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //如果是大图，需要进行绘制处理
        if (topic.isBigPicture == NO) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        //将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)],
        //获取图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
    
    //判断是否是gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    //判断是否显示“点击查看全图”
    if (topic.isBigPicture) {//大图
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {//飞大图
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
}

@end
