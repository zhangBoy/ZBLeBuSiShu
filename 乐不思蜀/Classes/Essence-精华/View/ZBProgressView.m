//
//  ZBProgressView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/25.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBProgressView.h"

@implementation ZBProgressView

-(void)awakeFromNib
{
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
