//
//  SendViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "SendViewController.h"
#import "NearbyViewController.h"
#import "AtfriendViewController.h"
#import "EmotionsBoard.h"
NSString    *const      kRequestNormalTag    = @"requestNormalTag";
NSString    *const      kRequestWithImageTag = @"requestWithImageTag";

NSUInteger   const      kActionSheetCameraTag = 0;
NSUInteger   const      kActionSheetPhotoLibraryTag = 1;



#define kRequestNormalUrl @"https://api.weibo.com/2/statuses/update.json"
#define kRequestWithImageUrl @"https://upload.api.weibo.com/2/statuses/upload.json"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark - initMethod
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSendView:)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;

    UIBarButtonItem *sendBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(SendTextRequest:)];
    [sendBarItem setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = sendBarItem;
    
    [self initToolBarView];
    
    _sendTextView.delegate = self;

    
}

- (void)initToolBarView
{


    NSArray *itemNormalArr = @[@"compose_locatebutton_background.png",
                               @"compose_camerabutton_background.png",
                               @"compose_mentionbutton_background.png",
                               @"compose_trendbutton_background.png",
                               @"compose_emoticonbutton_background.png",
                               @"compose_keyboardbutton_background.png"];
    
    NSArray *itemHighlightArr = @[@"compose_locatebutton_background_highlighted.png",
                               @"compose_camerabutton_background_highlighted.png",
                               @"compose_mentionbutton_background_highlighted.png",
                               @"compose_trendbutton_background_highlighted.png",
                               @"compose_emoticonbutton_background_highlighted.png",
                               @"compose_keyboardbutton_background_highlighted.png"];
    
    for (NSUInteger index = 0; index < itemNormalArr.count; index ++ ) {
        UIButton *itemBtn = [UIFactory initButtonWithName:itemNormalArr[index]
                                            HighlightName:itemHighlightArr[index]];
        itemBtn.tag = (100+index);
        [itemBtn setImage:[UIImage imageNamed:itemHighlightArr[index]] forState:UIControlStateSelected];
        [itemBtn addTarget:self
                    action:@selector(clickBtn:)
          forControlEvents:UIControlEventTouchUpInside];
        itemBtn.frame = CGRectMake(20 + index*64, (44-19)/2.0+10, 23, 23);
        [self.toolBar addSubview:itemBtn];
        if (index == 5) {
            itemBtn.hidden = YES;
            itemBtn.left -= 64.0f;
        }
    }
    
    UIImage *tempImage = [self.nearImageView.image stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    self.nearImageView.image = tempImage;
    self.nearImageView.width = _addressLabel.width;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示键盘
    [_sendTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChangeHeight:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //显示键盘
    [_sendTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_sendTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - TextViewDelegate
//但点击输入框时键盘重新弹出并隐藏表情面板
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self exchangeEmotionBoardAndKeyBoard:NO];
}

#pragma mark - keyboardAction
//监听键盘的高度改变时间
- (void)keyBoardChangeHeight:(NSNotification *)notification
{
    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    CGFloat keyboardHeight = frame.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        self.toolBar.bottom = kDeviceHeight - keyboardHeight;
        self.sendTextView. height = kDeviceHeight - keyboardHeight-self.toolBar.height-64;
    }];

}





#pragma mark - toolBarItemAction
- (void)clickBtn:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self location];
            break;
        case 101:
            [self selectPicture];

            break;
        case 102:
            [self atMyFriend];
            break;
        case 103:
            
            break;
        case 104:
            [self exchangeEmotionBoardAndKeyBoard:YES];
            break;
        case 105:
            [self exchangeEmotionBoardAndKeyBoard:NO];
            break;
            
        default:
            break;
    }

}



#pragma mark - location
//定位
- (void)location
{
        NearbyViewController *nearCtrl = [[NearbyViewController alloc] init];
//    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:nearCtrl];
//    [self presentViewController:navigationCtrl animated:YES completion:nil];
#pragma mark - 注意block的作用时间和功能
    nearCtrl.selectNearbyCellBlock = ^(NSDictionary *result){
        _longtitude = [result objectForKey:@"lon"];
        _latitude   = [result objectForKey:@"lat"];
        
        self.nearView.hidden = NO;
        self.addressLabel.text = [result objectForKey:@"title"];
        UIButton *itemBtn = (UIButton *)[self.toolBar viewWithTag:100];
        itemBtn.selected = YES;
    };
    [self.navigationController pushViewController:nearCtrl animated:YES];
}



#pragma mark - selectPicture
- (void)selectPicture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"图片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机",@"相册", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}
#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == kActionSheetCameraTag) {
        //UIImagePickerController的相机类型
        sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断设备是否支持相机
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"没有摄像头！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else if(buttonIndex == kActionSheetPhotoLibraryTag)
    {
        //UIImagePickerController的相册类型
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else
    {
        return;
    }
    //UIImagePickerController的使用
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - AtMyFriend
- (void)atMyFriend
{
    AtfriendViewController *friendCtrl = [[AtfriendViewController alloc] init];
    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:friendCtrl];
    friendCtrl.selectFriendCellBlock = ^(NSString *screenName){
        NSString *tempText = self.sendTextView.text;
        self.sendTextView.text = [tempText stringByAppendingString:[NSString stringWithFormat:@"@%@ ",screenName]];
    };
    [self presentViewController:navigationCtrl animated:YES completion:nil];
}

#pragma mark - ShowEmotionBoard&HiddenKeyBoard
- (void)exchangeEmotionBoardAndKeyBoard:(BOOL)show
{
    UIButton *emotionBtn = (UIButton *)[self.toolBar viewWithTag:104];
    UIButton *keyBoardBtn = (UIButton *)[self.toolBar viewWithTag:105];
    __weak SendViewController *weakSelf = self;
    if (show) {
        [_sendTextView resignFirstResponder];
        if (_emotionsBoard == nil) {
            _emotionsBoard = [[EmotionsBoard alloc] initWithBlock:^(NSString *emoticonName) {
                NSString *tempText = weakSelf.sendTextView.text;
                NSString *appendText = [tempText stringByAppendingString:emoticonName];
                weakSelf.sendTextView.text = appendText;
            }];
            _emotionsBoard.top = kDeviceHeight-self.emotionsBoard.height;
            self.emotionsBoard.transform = CGAffineTransformTranslate(self.emotionsBoard.transform, 0, kDeviceHeight);
            [self.view addSubview:_emotionsBoard];
        }
         //变更表情按钮为键盘，并且弹出表情面板调节输入框和工具条的位置
        [UIView animateWithDuration:0.3f
                         animations:^{
                             emotionBtn.hidden = YES;
                             _emotionsBoard.transform = CGAffineTransformIdentity;
                             self.toolBar.bottom = kDeviceHeight - self.emotionsBoard.height;
                             self.sendTextView.height = kDeviceHeight - self.emotionsBoard.height-self.toolBar.height-64;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 keyBoardBtn.hidden = NO;
                             }
                         }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            _emotionsBoard.transform = CGAffineTransformTranslate(_emotionsBoard.transform, 0, kDeviceHeight);
            keyBoardBtn.hidden = YES;
        } completion:^(BOOL finished) {
            if (finished) {
                emotionBtn.hidden = NO;
            }
        }];
        [self.sendTextView becomeFirstResponder];
        
    }
}


#pragma mark - WBHttpRequest
 //发送微博请求
- (void)SendTextRequest:(UIBarButtonItem *)button
{
    //判断文本内容是否合格
    NSString *text = self.sendTextView.text;
    if (text.length >= 280) {
        [SVProgressHUD showErrorWithStatus:@"不能超过140个汉字或280个字母！"];
        [self performSelector:@selector(dismissSVProcessHUD) withObject:self afterDelay:2.0f];
        return;
    }else if (text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入内容！"];
        [self performSelector:@selector(dismissSVProcessHUD) withObject:self afterDelay:2.0f];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:text forKey:@"status"];
    NSString *url = nil;
    NSString *tag = nil;
    
    if (_selectImage == nil) {
        url = kRequestNormalUrl;
        tag = kRequestNormalTag;
    }else{
        url = kRequestWithImageUrl;
        tag = kRequestWithImageTag;
        NSData *imageData =  UIImageJPEGRepresentation(_selectImage, 0.3);
        [dic setObject:imageData forKey:@"pic"];
    }
    //如果有定位信息将定位信息附加上去
    if (_longtitude != nil && _latitude != nil) {
        [dic setObject:self.longtitude forKey:@"long"];
        [dic setObject:self.latitude forKey:@"lat"];
    }
    NSString *accessToken = [NSUD objectForKey:kAccessToken];
    [WBHttpRequest requestWithAccessToken:accessToken
                                      url:url
                               httpMethod:@"POST"
                                   params:dic
                                 delegate:self
                                  withTag:tag];
    
    [self showOrHiddenMessageStatus:YES title:@"发送中..."];
}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"request result:%@",result);
    [super showOrHiddenMessageStatus:NO title:@"发送成功!"];
    [self dismissSendView:nil];
}


#pragma mark - dismissSendView
- (void)dismissSendView:(UIBarButtonItem *)button
{

    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
