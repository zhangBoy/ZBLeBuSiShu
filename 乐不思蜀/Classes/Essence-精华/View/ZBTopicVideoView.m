//
//  ZBTopicVideoView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopicVideoView.h"
#import "ZBTopic.h"
#import "UIImageView+WebCache.h"
#import "ZBShowPictureViewController.h"
#import "ZBVideoPlayerController.h"

@interface ZBTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) ZBVideoPlayerController *videoController;

@end

@implementation ZBTopicVideoView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
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
    _topic  = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    //时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

//播放按钮
- (IBAction)playBtn:(UIButton *)sender {
    
    [self playVideoWithURL:[NSURL URLWithString:self.topic.videouri]];
    [self addSubview:self.videoController.view];
    
}

- (void)playVideoWithURL:(NSURL *)url {
    if (!self.videoController) {
        self.videoController = [[ZBVideoPlayerController alloc] initWithFrame:self.imageView.bounds];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDismissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
    }
    self.videoController.contentURL = url;
}

//停止视频的播放
- (void)reset {
    [self.videoController dismiss];
    self.videoController = nil;
}


@end
