//
//  ZBVideoPlayerController.h
//  乐不思蜀
//
//  Created by zboy on 2017/2/6.
//  Copyright © 2017年 乐基. All rights reserved.
//

//#import <UIKit/UIKit.h>
//@import MediaPlayer;
#import <MediaPlayer/MediaPlayer.h>

@interface ZBVideoPlayerController : MPMoviePlayerController

@property (nonatomic, copy) void (^dismissCompleteBlock)(void);
@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showWindow;
- (void)dismiss;

@end
