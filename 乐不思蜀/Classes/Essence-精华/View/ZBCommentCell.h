//
//  ZBCommentCell.h
//  乐不思蜀
//
//  Created by zboy on 2016/12/3.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBComment;

@interface ZBCommentCell : UITableViewCell

/**评论*/
@property (nonatomic, strong) ZBComment *comment;

@end
