//
//  ZBPlaceholderTextView.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/18.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBPlaceholderTextView.h"

@interface ZBPlaceholderTextView()

/**
 占位文字label
 */
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation ZBPlaceholderTextView

-(UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        //添加显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //垂直方向永远有弹簧效果
        self.alwaysBounceVertical = YES;
        //默认字体
        self.font = [UIFont systemFontOfSize:15];
        //默认占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        //监听文字改变
        [ZBNoteCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [ZBNoteCenter removeObserver:self];
}

/**
 监听文字改变
 */
- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}

/**
 更新占位文字大小
 */
- (void)layoutSubviews
{
//    CGSize maxSize = CGSizeMake(ZBScreenW - 2 * self.placeholderLabel.x, MAXFLOAT);
//    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    [super layoutSubviews];
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}
#pragma mark - 重写setter方法
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

/**
    setNeedsDisplay方法：会在恰当的时刻调用darwRect：方法
    setNeedsLayout方法：会在恰当的时刻调用layoutSubviews
 */


@end
