//
//  ZBVoicePlayerController.m
//  乐不思蜀
//
//  Created by zboy on 2017/2/7.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBVoicePlayerController.h"
#import "NSString+ZBExtension.h"

@interface ZBVoicePlayerController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UISlider *proggress;
//播放器
@property (nonatomic, strong) MPMoviePlayerController *player;
//进度的timer
@property (nonatomic, strong) NSTimer *progressTimer;
//slider时间处理
- (IBAction)startSlide;
- (IBAction)sliderValueChange;
- (IBAction)endSlide;
- (IBAction)sliderClick:(UIGestureRecognizer *)sender;
//暂停
- (IBAction)pause;

@end

@implementation ZBVoicePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.proggress setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
    [self startPlayingMusic];
    
    self.playTime.text = [NSString stringWithTime:self.totalTime];
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.url]];
    [self.player play];
    
}

- (void)startPlayingMusic
{
    [self removeProgressTimer];
    [self addProgressTimer];
}

//添加定时器
- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

//移除定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

//更新进度条的界面
- (void)updateProgressInfo
{
    //1.设置当前的播放时间
    self.restTime.text = [NSString stringWithTime:self.player.currentPlaybackTime];
    //2.更新滑块的位置
    self.proggress.value = self.player.currentPlaybackTime / self.player.duration;
}

#pragma maek - slider时间处理
- (IBAction)startSlide
{
    [self removeProgressTimer];
}
- (IBAction)sliderValueChange
{
    //设置当前播放的司时间
    self.restTime.text = [NSString stringWithTime:self.player.duration * self.proggress.value];
}
- (IBAction)endSlide
{
    //设置歌曲播放时间
    self.player.currentPlaybackTime = self.proggress.value * self.player.duration;
    //添加定时器
    [self addProgressTimer];
}
- (IBAction)sliderClick:(UIGestureRecognizer *)sender
{
    //1.获取点击位置
    CGPoint point = [sender locationInView:sender.view];
    //2.获取点击位置在slider的比例
    CGFloat ratio = point.x / self.proggress.bounds.size.width;
    //3.改变歌曲播放时间
    self.player.currentPlaybackTime = ratio * self.player.duration;
    //4.更新progress的界面
    [self updateProgressInfo];
}
//暂停
- (IBAction)pause
{
    self.playButton.selected = !self.playButton.selected;
    if (self.playButton.selected) {
        [self.player pause];
        [self removeProgressTimer];
    } else {
        [self.player play];
        [self addProgressTimer];
    }
}


-(void)dismiss
{
    [self removeProgressTimer];
    [self.player stop];
}

@end
