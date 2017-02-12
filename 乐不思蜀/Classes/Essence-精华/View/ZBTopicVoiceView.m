//
//  ZBTopicVoiceView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/31.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopicVoiceView.h"
#import "UIImageView+WebCache.h"
#import "ZBTopic.h"
#import "ZBShowPictureViewController.h"
#import "ZBVoicePlayerController.h"

@interface ZBTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicelengthLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
//播放器
@property (nonatomic, strong) ZBVoicePlayerController *voicePlayer;


@end

@implementation ZBTopicVoiceView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicdture)] ];
}

- (void)showPicdture
{
    ZBShowPictureViewController *showPicture = [[ZBShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

-(void)setTopic:(ZBTopic *)topic
{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd",topic.playcount];
    
    //时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voicelengthLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

//播放
- (IBAction)playBtn:(UIButton *)sender {
    self.playBtn.hidden = YES;
    self.voicePlayer = [[ZBVoicePlayerController alloc] initWithNibName:@"ZBVoicePlayerController" bundle:nil];
    self.voicePlayer.url = self.topic.voiceuri;
    self.voicePlayer.totalTime = self.topic.voicetime;
    self.voicePlayer.view.width = self.imageView.width;
    self.voicePlayer.view.y = self.imageView.height - self.voicePlayer.view.height;
    [self addSubview:self.voicePlayer.view];
}

-(void)reset
{
    [self.voicePlayer dismiss];
    [self.voicePlayer.view removeFromSuperview];
    self.voicePlayer = nil;
    self.playBtn.hidden = NO;
}




@end
