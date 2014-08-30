//
//  CommentViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-3.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "CommentViewController.h"
#import "AtfriendViewController.h"
#import "UIImageView+WebCache.h"
#import "EmotionsBoard.h"
#import "WeiboModel.h"


NSString *const kHttpRequestWithCommentTag = @"HttpRequestWithCommentTag";
NSString *const kHttpRequestWithRepostTag = @"HttpRequestWithRepostTag";
@interface CommentViewController ()

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissCommentView)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    UIBarButtonItem *sendBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(SendTextRequest:)];
    [sendBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = sendBarItem;
    //初始化工具栏
    [self initToolBarView];
    //初始化微博转发视图
    if (!self.isComment) {
        [self initRepostView];
    }
}
#pragma mark - initMethod
- (void)initToolBarView
{
 //初始化输入法上的工具条
    NSArray *itemNormalArr = @[@"compose_mentionbutton_background.png",
                               @"compose_trendbutton_background.png",
                               @"compose_emoticonbutton_background.png",
                               @"compose_keyboardbutton_background.png"];
    
    NSArray *itemHighlightArr = @[@"compose_mentionbutton_background_highlighted.png",
                                  @"compose_trendbutton_background_highlighted.png",
                                  @"compose_emoticonbutton_background_highlighted.png",
                                  @"compose_keyboardbutton_background_highlighted.png"];
    
    for (NSUInteger index = 0; index < 4; index ++ ) {
        UIButton *itemBtn = [UIFactory initButtonWithName:itemNormalArr[index]
                                            HighlightName:itemHighlightArr[index]];
        itemBtn.tag = (100+index);
        [itemBtn setImage:[UIImage imageNamed:itemHighlightArr[index]] forState:UIControlStateSelected];
        [itemBtn addTarget:self
                    action:@selector(clickBtn:)
          forControlEvents:UIControlEventTouchUpInside];
        itemBtn.frame = CGRectMake(41.8 + index*107, (40-19)/2.0, 23, 19);
        [self.toolBarView addSubview:itemBtn];
        if (index == 3) {
            itemBtn.hidden = YES;
            itemBtn.left -= 107.0f;
        }
    }
    self.sendTextView.delegate = self;
}

- (void)initRepostView
{
    //初始化转发微博的视图
    _repostView = [[UIView alloc] initWithFrame:CGRectMake(10, self.toolBarView.top - 70 , kDeviceWidth - 20, 70)];
    self.repostView.layer.borderWidth = 1.0f;
    self.repostView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repostView.backgroundColor = [UIColor whiteColor];
    //转发微博中的图片视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.weibo.user objectForKey:@"profile_image_url"]]];
    [self.repostView addSubview:imageView];
    //转发的微博内容
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 5, 5, self.repostView.width - imageView.width - 10 -5, self.repostView.height - 10)];
    textLabel.text = [NSString stringWithFormat:@"    %@",self.weibo.text];
    textLabel.font = [UIFont systemFontOfSize:13.0f];
    textLabel.numberOfLines = 0;
    [self.repostView addSubview:textLabel];
    [self.view addSubview:self.repostView];
}

#pragma mark - NavigationBarItemAction
- (void)clickBtn:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self presentToAtFriend];
            break;
        case 101:
            
            break;
        case 102:
            [self exchangeEmotionBoardAndKeyBoard:YES];
            break;
        case 103:
            [self exchangeEmotionBoardAndKeyBoard:NO];
            break;
        default:
            break;
    }
}

- (void)presentToAtFriend
{
    AtfriendViewController *atFriendCtrl = [[AtfriendViewController alloc] init];
    atFriendCtrl.selectFriendCellBlock = ^(NSString *screenName){
        NSString *tempText = self.sendTextView.text;
        self.sendTextView.text = [tempText stringByAppendingString:[NSString stringWithFormat:@"@%@ ",screenName]];
    };
    BaseNavigationController *navCtrl = [[BaseNavigationController alloc] initWithRootViewController:atFriendCtrl];
    [self presentViewController:navCtrl animated:YES completion:nil];
    
    
}

#pragma mark - exchangeEmocticonBoardAndKeyBoard
- (void)exchangeEmotionBoardAndKeyBoard:(BOOL)show
{
       UIButton *emoBtn = (UIButton *)[self.toolBarView viewWithTag:102];
       UIButton *keyBtn = (UIButton *)[self.toolBarView viewWithTag:103];
    if (show) {
        [self.sendTextView resignFirstResponder];
        //创建表情面板
        if (self.emotionsBoard == nil) {
            _emotionsBoard = [[EmotionsBoard alloc] initWithBlock:^(NSString *emoticonName) {
            //将选中的表情给输入框
                NSString *tempString = self.sendTextView.text;
                NSString *appendString = [tempString stringByAppendingString:emoticonName];
                self.sendTextView.text = appendString;
            }];
            self.emotionsBoard.top = kDeviceHeight-self.emotionsBoard.height;
            self.emotionsBoard.transform = CGAffineTransformTranslate(self.emotionsBoard.transform, 0, kDeviceHeight);
        }
        
        [self.view addSubview:self.emotionsBoard];
        [UIView animateWithDuration:0.3f animations:^{
            emoBtn.hidden = YES;
            self.emotionsBoard.transform = CGAffineTransformIdentity;
            if (self.isComment) {
                self.toolBarView.bottom = kDeviceHeight-self.emotionsBoard.height;
                self.sendTextView.height = kDeviceHeight - self.emotionsBoard.height - self.toolBarView.height - 64;
            }else{
                self.toolBarView.bottom = kDeviceHeight-self.emotionsBoard.height;
                self.repostView.bottom = self.toolBarView.top;
                self.sendTextView.height = kDeviceHeight - self.emotionsBoard.height - self.toolBarView.height - 70 - self.repostView.height;
            }
            } completion:^(BOOL finished) {
                    if (finished) {
                        keyBtn.hidden = NO;
                                    }
                                     }];

    }else{
        [UIView animateWithDuration:0.3f animations:^{
            _emotionsBoard.transform = CGAffineTransformTranslate(_emotionsBoard.transform, 0, kDeviceHeight);
            keyBtn.hidden = YES;
        } completion:^(BOOL finished) {
            if (finished) {
                emoBtn.hidden = NO;
            }
        }];
        [self.sendTextView becomeFirstResponder];

    }
}

#pragma mark - addNotification
- (void)viewWillAppear:(BOOL)animated
{
    [self.sendTextView becomeFirstResponder];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChangeHeight:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
#pragma mark - removedNotification
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sendTextView becomeFirstResponder];
}



#pragma mark -  HttpRequest
- (void)SendTextRequest:(UIBarButtonItem *)barButtonItem
{
    if (self.isComment) {
        NSDictionary *params = @{@"id": self.weiboId,
                                 @"comment":self.sendTextView.text
                                 };
        [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                          url:@"https://api.weibo.com/2/comments/create.json"
                                   httpMethod:@"POST"
                                       params:params
                                     delegate:self
                                      withTag:kHttpRequestWithCommentTag];
    }else{
        NSDictionary *params = @{@"id": [self.weibo.weiboId stringValue],
                                 @"status":self.sendTextView.text
                                 };
        [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:@"https://api.weibo.com/2/statuses/repost.json"
                               httpMethod:@"POST"
                                   params:params
                                 delegate:self
                                  withTag:kHttpRequestWithRepostTag];
    
    }
        [super showOrHiddenMessageStatus:YES title:@"发送中。。"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    [super showOrHiddenMessageStatus:NO title:@"发送成功！"];
    [self dismissCommentView];
}

#pragma mark - keyBoardChangeHeight
- (void)keyBoardChangeHeight:(NSNotification *)notification
{
    NSLog(@"%@",notification);
    CGRect frame = [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyBoardHeight = frame.size.height;
    if (self.isComment) {
        [UIView animateWithDuration:0.3f animations:^{
            self.toolBarView.bottom = kDeviceHeight - keyBoardHeight;
            self.sendTextView.height = kDeviceHeight - keyBoardHeight - 64 - self.toolBarView.height;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.toolBarView.bottom = kDeviceHeight - keyBoardHeight;
            self.repostView.bottom = self.toolBarView.top;
            self.sendTextView.height = kDeviceHeight - keyBoardHeight - 64 - self.toolBarView.height - self.repostView.height;
        }];
    }
    
    
}
#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self exchangeEmotionBoardAndKeyBoard:NO];
}

#pragma mark - dismissCommentView
- (void)dismissCommentView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
