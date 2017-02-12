//
//  ZBCommentHeaderView.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/11/2.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBCommentHeaderView.h"

@interface ZBCommentHeaderView ()

//文字标签
@property (nonatomic, weak) UILabel *label;

@end

@implementation ZBCommentHeaderView

+(instancetype)headerVieWithTableVeiw:(UITableView *)tableView
{
    static NSString *ID = @"header";
    ZBCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[ZBCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ZBGlobalBg;
        
        //创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = ZBRGBColor(67, 67, 67);
        label.width = 200;
        label.x = ZBTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.label.text = title;
    
}

@end
