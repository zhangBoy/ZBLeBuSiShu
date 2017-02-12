//
//  ZBCommentHeaderView.h
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/11/2.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBCommentHeaderView : UITableViewHeaderFooterView

//文字数据
@property (nonatomic, copy) NSString *title;

+(instancetype)headerVieWithTableVeiw:(UITableView *)tableView;

@end
