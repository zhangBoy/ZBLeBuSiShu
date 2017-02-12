
//
//  ZBAddTagViewController.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/30.
//  Copyright © 2017年 乐基. All rights reserved.
//

#import "ZBAddTagViewController.h"
#import "ZBTagButton.h"
#import "ZBTagTextField.h"
#import "SVProgressHUD.h"

@interface ZBAddTagViewController () <UITextFieldDelegate>

/**内容*/
@property (nonatomic, weak) UIView *contentView;
/**内容*/
@property (nonatomic, weak) UITextField *textField;
/**添加按钮*/
@property (nonatomic, weak) UIButton *addButton;
/**所有的标签按钮*/
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation ZBAddTagViewController

-(NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

-(UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        [addButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(tagButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = ZBTagFont;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZBTagMargin, 0, ZBTagMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = ZBTagBg;
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
    
    [self setupTags];
    
}

/**
 布局控制器view的子控件
 */
-(void)viewDidLayoutSubviews
{
    
}

#pragma mark - <UITextFieldDelegate>

/**
 监听键盘最右下角按钮的点击（return key， 比如“换行”、“完成”等等）
 */
-(BOOL)textFieldShouldReturn:(ZBTagTextField *)textField
{
    if (textField.hasText) {
        [self tagButtonClick];
    }
    return YES;
}

#pragma mark - <私有方法>

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = ZBTopicCellMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + ZBTopicCellMargin;
    contentView.height = ZBScreenH;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
}

- (void)setupTextField
{
    __weak typeof(self) weakSelf = self;
    ZBTagTextField *textField = [[ZBTagTextField alloc] init];
    textField.width = self.contentView.width;
    textField.delateBlock = ^{
        if (weakSelf.textField.hasText) return;
        
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
    textField.delegate = self;
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupTags
{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self tagButtonClick];
    }
}

- (void)done
{
    // 传递tags给这个block
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 监听文字改变
 */
- (void)textDidChange
{
    //更新标签和文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) {//如果有文字
        //显示"添加标签"按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + ZBTopicCellMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签：%@",self.textField.text] forState:UIControlStateNormal];
        
        // 获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","]
            || [lastLetter isEqualToString:@"，"]) {
            // 去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self tagButtonClick];
        }
    } else {//没有文字
        //隐藏"添加标签"按钮
        self.addButton.hidden = YES;
    }
    
}

/**
 监听"添加标签"按钮点击
 */
- (void)tagButtonClick
{
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    // 添加一个"标签按钮"
    ZBTagButton *tagButton = [ZBTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.height = self.textField.height;
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
}

/**
 专门用来更新按钮的frame
 */
- (void)updateTagButtonFrame
{
    
    // 更新标签按钮的frame
    for (int i = 0; i<self.tagButtons.count; i++) {
        ZBTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else { // 其他标签按钮
            ZBTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + ZBTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + ZBTagMargin;
            }
        }
    }
//    
//    // 最后一个标签按钮
//    ZBTagButton *lastTagButton = [self.tagButtons lastObject];
//    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + ZBTagMargin;
//    
//    // 更新textField的frame
//    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
//        self.textField.y = lastTagButton.y;
//        self.textField.x = leftWidth;
//    } else {
//        self.textField.x = 0;
//        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + ZBTagMargin;
//    }
    
}

/**
 更新textField的frame
 */
- (void)updateTextFieldFrame
{
    ZBTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + ZBTagMargin;
    
    //更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + ZBTagMargin;
    }
}

/**
 标签按钮点击
 */
- (void)tagButtonClick:(ZBTagButton *)tagButton
{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}


@end
