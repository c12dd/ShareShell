//
//  SendViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
@class EmotionsBoard;
@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView  *nearImageView;
@property (strong, nonatomic) IBOutlet UITextView   *sendTextView;
@property (strong, nonatomic) IBOutlet UIView       *toolBar;
@property (strong, nonatomic) IBOutlet UIView       *nearView;
@property (strong, nonatomic) IBOutlet UILabel      *addressLabel;
//@property (strong, nonatomic) NSMutableDictionary   *params;
//@property (strong, nonatomic) NSDictionary          *nearbyDic;
@property (strong, nonatomic) NSString              *longtitude;
@property (strong, nonatomic) NSString              *latitude;
@property (strong, nonatomic) UIImage               *selectImage;
@property (strong, nonatomic) EmotionsBoard         *emotionsBoard;
@end
