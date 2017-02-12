//
//  ZBRecomendCategoryCell.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/10.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBRecomendCategoryCell.h"
#import "ZBRecomendCategory.h"

@interface ZBRecomendCategoryCell ()
//选中是显示的控件
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation ZBRecomendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = ZBRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = ZBRGBColor(219, 21, 26);
}

-(void)setCategory:(ZBRecomendCategory *)category
{
    _category = category;
    self.textLabel.text =  category.name;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : ZBRGBColor(78, 78, 78);
}

@end
