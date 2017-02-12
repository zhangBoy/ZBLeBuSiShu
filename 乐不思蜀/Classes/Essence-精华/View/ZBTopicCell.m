//
//  ZBTopicCell.m
//  乐不思蜀
//
//  Created by 曹桉铭 on 16/10/20.
//  Copyright © 2016年 乐基. All rights reserved.
//

#import "ZBTopicCell.h"
#import "ZBTopic.h"
#import "UIImageView+WebCache.h"
#import "ZBTopicPictureView.h"
#import "ZBTopicVoiceView.h"
#import "ZBTopicVideoView.h"
#import "ZBUser.h"
#import "ZBComment.h"

@interface ZBTopicCell ()

//头像
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
//顶
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
//踩
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
//分享
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commnetButotn;
//新浪V
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImageView;
//帖子的文字内容
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
//图片帖子中间的内容
@property (nonatomic, weak) ZBTopicPictureView *pictureView;
//声音帖子中的内容
@property (nonatomic, weak) ZBTopicVoiceView *voiceView;
//视频帖子中的内容
@property (nonatomic, weak) ZBTopicVideoView *videoView;
//最热评论内容
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
//最热评论的整体
@property (weak, nonatomic) IBOutlet UIView *topCmtView;



@end

@implementation ZBTopicCell

-(ZBTopicPictureView *)pictureView
{
    if (!_pictureView) {
        ZBTopicPictureView *pictureView = [ZBTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

-(ZBTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        ZBTopicVoiceView *voiceView = [ZBTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

-(ZBTopicVideoView *)videoView
{
    if (!_videoView) {
        ZBTopicVideoView *videoView = [ZBTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

/**
 今年
 今天
 1分钟内
 刚刚
 1小时内
 xx分钟前
 其他
 xx小时前
 昨天
 昨天 18:56:34
 其他
 06-23 19:56:23
 
 非今年
 2014-05-08 18:45:30
 */

//从队列里复用时调用
- (void)prepareForReuse
{
    [_voiceView reset];
    [_videoView reset];
}

-(void)setTopic:(ZBTopic *)topic
{
    _topic = topic;
    
    //设置头像
    
    [self.profileImageView setHeader:topic.profile_image];
    
    //设置名字
    self.nameLabel.text = topic.name;
    
    //设置创建时间
    self.createTimeLabel.text = topic.create_time;
    
    // 新浪加V
    self.sinaVImageView.hidden = !topic.isSina_v;
    
    //按钮的文字
    [self setButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setButtonTitle:self.commnetButotn count:topic.comment placeholder:@"评论"];
    
    //设置帖子的内容
    self.text_Label.text = topic.text;
    
    // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topic.type == ZBTopicTypePicture) { // 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    } else if (topic.type == ZBTopicTypeVoice) { // 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == ZBTopicTypeVideo) {//视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    } else {
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    // 处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.user.username, topic.top_cmt.content];
    } else {
        self.topCmtView.hidden = YES;  
    }
    
}

- (void)setButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万",count/10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd",count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

-(void)setFrame:(CGRect)frame
{
    
//    frame.origin.x = ZBTopicCellMargin;
//    frame.size.width -= 2 * ZBTopicCellMargin;
//    frame.size.height -= ZBTopicCellMargin;
    frame.size.height = self.topic.cellHeight - ZBTopicCellMargin;
    frame.origin.y += ZBTopicCellMargin;
    
    [super setFrame:frame];
}

- (void)turnOffPlayer:(ZBTopic *)topic cell:(ZBTopicCell *)cell
{
    if (topic.type == ZBTopicTypeVoice) {
        [cell.voiceView reset];
    } else if (topic.type == ZBTopicTypeVideo) {
        [cell.videoView reset];
    }
}

@end
