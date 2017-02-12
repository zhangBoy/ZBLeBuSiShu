//
//  ZBPostWordViewController.m
//  乐不思蜀
//
//  Created by zboy on 2017/1/18.
//  Copyright © 2017年 乐基. All rights reserved.
//

/*
 UITextField *textField默认的情况
 1.只能显示一行文字
 2.有占位文字
 
 UITextView *textView默认的情况
 2.能显示任意行文字
 2.没有占位文字
 
 文本输入控件,最终希望拥有的功能
 1.能显示任意行文字
 2.有占位文字
 
 最终的方案:
 1.继承自UITextView
 2.在UITextView能显示任意行文字的基础上,增加"有占位文字"的功能
 */

#import "ZBPostWordViewController.h"
#import "ZBPlaceholderTextView.h"
#import "ZBAddToolBar.h"

@interface ZBPostWordViewController () <UITextViewDelegate>

/**
 文本输入控件
 */
@property (nonatomic, weak) ZBPlaceholderTextView *textView;

/**
 工具条
 */
@property (nonatomic, weak) ZBAddToolBar *toolBar;


@end

@implementation ZBPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    
    //设置Textview
    [self setupTextView];
    
    //设置ToolBar
    [self setupToolBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认不能点
    //强制布局
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)setupTextView
{
    ZBPlaceholderTextView *textView = [[ZBPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
}

- (void)setupToolBar
{
    ZBAddToolBar *toolBar = [ZBAddToolBar viewFromXib];
    toolBar.width = self.view.width;
    toolBar.y = self.view.height - toolBar.height;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    [ZBNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark - <UITextViewDelegate>
-(void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 私有方法

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    //键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - ZBScreenH);
    }];
    
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    ZBLog(@"发表");
}

@end
