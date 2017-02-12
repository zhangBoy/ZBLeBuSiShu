//
//  ZBSquareButton.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/2.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBSquareButton.h"
#import "ZBSquare.h"
#import "UIButton+WebCache.h"

@implementation ZBSquareButton

//用于代码创建的按钮控件
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

//用于Xib、StoryBoard创建的按钮控件
- (void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = self.height * 0.15;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

-(void)setSquare:(ZBSquare *)square
{
    _square = square;
    [self setTitle:square.name forState:UIControlStateNormal];
    //利用SDWebImage设置button的image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];

}

@end
