//
//  ZBShowPictureViewController.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/25.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBShowPictureViewController.h"
#import "ZBTopic.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "ZBProgressView.h"

@interface ZBShowPictureViewController ()
@property (weak, nonatomic) IBOutlet ZBProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ZBShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //屏幕尺寸
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

    //添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片尺寸
    CGFloat pictureW = ZBScreenW;
    CGFloat pictureH = pictureW * self.topic.height / self. topic.width;
    if (pictureH > ZBScreenH) {//图片显示高度超过一个屏幕，需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    } else {
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = ZBScreenH * 0.5;
    }
    
    // 马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];

    //下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(UIButton *)sender {
    if (!self.imageView.image) {
        [SVProgressHUD showErrorWithStatus:@"图片并没有下载完毕!"];
        return;
    }
    //将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)cpmtextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}

@end
