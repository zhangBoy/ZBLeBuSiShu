//
//  ZBTagButton.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/30.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBTagButton.h"

@implementation ZBTagButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = ZBTagBg;
        self.titleLabel.font = ZBTagFont;
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 3 *ZBTagMargin;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = ZBTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + ZBTagMargin;

}

@end
