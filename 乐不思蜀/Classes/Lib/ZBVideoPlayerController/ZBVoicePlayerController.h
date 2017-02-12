//
//  ZBVoicePlayerController.h
//  乐不思蜀
//
//  Created by zboy on 2017/2/7.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface ZBVoicePlayerController : UIViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger totalTime;
- (void)dismiss;

@end
