//
//  CommentCell.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "WeiboUtil.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UserViewController.h"
#import "UserImageView.h"
#import "UIView+searchResponse.h"
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.hidden = YES;
    _nickLabel   = (UILabel *)[self viewWithTag:100];
    _createLabel = (UILabel *)[self viewWithTag:101];
    _userImage = [[UserImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
    _userImage.layer.cornerRadius = 5.0f;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    _commentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _commentLabel.delegate = self;
    _commentLabel.font = [UIFont systemFontOfSize:14.0f];
    _commentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    _commentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    [self.contentView addSubview:_commentLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.comments != nil) {
        NSString *screenName = [self.comments.user objectForKey:@"screen_name"];
        _nickLabel.text   = screenName;
        _createLabel.text = [WeiboUtil resolveSinaWeiboDate:self.comments.created_at];
        NSString *imageUrl = [self.comments.user objectForKey:@"profile_image_url"];
        [_userImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [self pushToUserViewController:screenName];
        //评论label
        _commentLabel.text = [WeiboUtil parseTextLink:self.comments.text];
        CGFloat height = _commentLabel.optimumSize.height;
        _commentLabel.frame = CGRectMake(_userImage.right + 10.0f, _createLabel.bottom + 5.0f, 240, height);
        
        if (self.comments == nil) {
            self.hidden = YES;
        }else{
            self.hidden = NO;
        }
    }else if(self.reposts != nil){
        NSString *screenName = [self.reposts.user objectForKey:@"screen_name"];
        _nickLabel.text   = screenName;
        _createLabel.text = [WeiboUtil resolveSinaWeiboDate:self.reposts.createDate];
        NSString *imageUrl = [self.reposts.user objectForKey:@"profile_image_url"];
        [_userImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [self pushToUserViewController:screenName];
        
        //转发
        _commentLabel.text = [WeiboUtil parseTextLink:self.reposts.text];
        CGFloat height = _commentLabel.optimumSize.height;
        _commentLabel.frame = CGRectMake(_userImage.right + 10.0f, _createLabel.bottom + 5.0f, 240, height);
        
        if (self.reposts == nil) {
            self.hidden = YES;
        }else{
            self.hidden = NO;
        }
    }else{
        return;
    }
    
}

- (void)pushToUserViewController:(NSString *)screenName
{
    __block CommentCell *weakSelf = self;
    _userImage.headImageTouchBlock = ^{
        UserViewController *userViewController = [[UserViewController alloc] init];
        userViewController.screenName = screenName;
        [weakSelf.viewContreller.navigationController pushViewController:userViewController animated:YES];
    };
    
}


+ (CGFloat)getCellRowHeightWithComment:(CommentModel *)comment
{
    CGFloat height = 0;
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    label.text = comment.text;
    height = label.optimumSize.height;
    height += 60;
    
    return height;
}

+ (CGFloat)getCellRowHeightWithRepost:(WeiboModel *)repost
{
    CGFloat height = 0;
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    label.text = repost.text;
    height = label.optimumSize.height;
    height += 60;
    
    return height;
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    //多点击的超链接进行反编码获得中文字符
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *urlString = [url host];
        NSLog(@"%@",urlString);
        NSString *screenName = [urlString substringWithRange:NSMakeRange(1, urlString.length-1)];
        UserViewController *userView = [[UserViewController alloc] init];
        userView.screenName = screenName;
        [self.viewContreller.navigationController pushViewController:userView animated:YES];
        
    }else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *urlString = [url host];
        NSLog(@"%@",urlString);
    }else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"%@",absoluteString);
        
    }
}

@end
