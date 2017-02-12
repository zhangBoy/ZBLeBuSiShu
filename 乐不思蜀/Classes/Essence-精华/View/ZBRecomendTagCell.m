//
//  ZBRecomendTagCell.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/11.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendTagCell.h"
#import "ZBRecomendTag.h"
#import "UIImageView+WebCache.h"

@interface ZBRecomendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;


@end

@implementation ZBRecomendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setRecomendTag:(ZBRecomendTag *)recomendTag
{
    _recomendTag = recomendTag;
    
    [self.imageListImageView setHeader:recomendTag.image_list];
    self.themeNameLabel.text = recomendTag.theme_name;
    NSString *subNumber = nil;
    if (recomendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recomendTag.sub_number];
    } else {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recomendTag.sub_number/10000.0];
    }
    self.subNumberLabel.text = subNumber;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

@end
