//
//  ZBRecomendUserCell.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/10.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendUserCell.h"
#import "ZBRecomendUser.h"
#import "UIImageView+WebCache.h"

@interface ZBRecomendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation ZBRecomendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(ZBRecomendUser *)user
{
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    [self.headerImageView setHeader:user.header];
    
}

@end
