//
//  ZBMeCell.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/2.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBMeCell.h"

@implementation ZBMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgImg;
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + ZBTopicCellMargin;
}

@end
