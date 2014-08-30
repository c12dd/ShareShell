//
//  DetailViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UserViewController.h"
#import "WeiboModel.h"
#import "WeiboUtil.h"
#import "WeiboView.h"
#import "CommentModel.h"
#import "MJRefresh.h"
#import "UserImageView.h"
//comment
NSString    *const     kLoadComment          = @"loadComment";
NSString    *const     kLoadCommentNewTag    = @"loadCommentNew";
NSString    *const     kLoadCommentOleTag    = @"loadCommentOld";
//repost
NSString    *const     kLoadRepost           = @"loadComment";
NSString    *const     kLoadRepostNewTag     = @"loadCommentNew";
NSString    *const     kLoadRepostOleTag     = @"loadCommentOld";


NSString    *const     commentUrl            = @"https://api.weibo.com/2/comments/show.json";
NSString    *const     repostUrl             = @"https://api.weibo.com/2/statuses/repost_timeline.json";


typedef enum {
    loadComment    = 0,
    loadCommentOld = 1,
    loadCommentnew = 2
}loadCommentType;

typedef enum {
    loadRepost    = 3,
    loadRepostOld = 4,
    loadRepostNew = 5
}loadRepostType;

@interface DetailViewController ()

@end

@implementation DetailViewController


#pragma mark - initMethod
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
    

    
    _tableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)style:UITableViewStylePlain];
    _tableView.tableDelegate = self;
    _tableView.weibo = self.weibo;
    if (self.isNearby) {
    _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self.view addSubview:_tableView];

        
        //详细页面头视图
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        //用户头像
        _userImageView = [[UserImageView alloc] initWithFrame:CGRectMake(2, 2, 60, 60)];
        NSString *urlString = [self.weibo.user objectForKey:@"profile_image_url"];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        self.userImageView.layer.cornerRadius = 5.0f;
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.layer.cornerRadius = 5.0f;
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.userInteractionEnabled = YES;
        [_userView addSubview:_userImageView];
        __weak DetailViewController *weakSelf = self;
        NSString *screenName = [_weibo.user objectForKey:@"screen_name"];
        self.userImageView.headImageTouchBlock = ^{
            UserViewController *userViewCtrl = [[UserViewController alloc] init];
            userViewCtrl.screenName = screenName;
            [weakSelf.navigationController pushViewController:userViewCtrl animated:YES];
        };
        //用户昵称
        self.nickLabel.text = [self.weibo.user objectForKey:@"screen_name"];
        //微博发布时间时间
        self.createAtLabel.text = [WeiboUtil resolveSinaWeiboDate:self.weibo.createDate];
        //微博来源
        NSString *source = [WeiboUtil parseSource:self.weibo.source];
        if (source != nil) {
            self.sourceLabel.text =[NSString stringWithFormat:@"来自%@",source];
            self.sourceLabel.hidden = NO;
        }else{
            self.sourceLabel.hidden = YES;
        }
        detailView.height += 65;
        [detailView addSubview:self.userView];
        //--------------创建微博视图-------------
        CGFloat height = [WeiboView getWeiboViewHeight:self.weibo isRepost:NO isDetail:YES];
        _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userView.bottom+10, 300, height)];
        _weiboView.isDetail = YES;
        _weiboView.weibo = self.weibo;
        [detailView addSubview:_weiboView];
        detailView.height += (height+30);
        //添加评论列表头视图
    _tableView.tableHeaderView = detailView;
    
    
    
    if (!self.isNearby) {
        [self loadCommentsDataWithType:loadComment Tag:kLoadComment];             //加载新的评论
        //首次进入的时comment列表
        self.isComment = YES;
        if (self.isComment) {
            [_tableView addHeaderWithCallback:^{
                if (weakSelf.isComment) {
                    [weakSelf loadCommentsDataWithType:loadCommentnew Tag:kLoadCommentNewTag];
                }else{
                    [weakSelf loadCommentsDataWithType:loadRepost Tag:kLoadRepostNewTag];
                }
            }];
            
            [_tableView addFooterWithCallback:^{
                if (weakSelf.isComment) {
                    [weakSelf loadCommentsDataWithType:loadCommentOld Tag:kLoadCommentOleTag];    //加载旧的评论
                }else{
                    [weakSelf loadCommentsDataWithType:loadRepostOld Tag:kLoadRepostOleTag];
                }
                
            }];
        }
    }
}




#pragma  mark - loadCommentData
- (void)loadCommentsDataWithType:(NSUInteger)type Tag:(NSString *)tag
{
    NSString *weiboId = [self.weibo.weiboId stringValue];
    NSString *comment_max_id = @"";
    NSString *comment_since_id = @"";
    NSString *repost_max_id = @"";
    NSString *repost_since_id = @"";
    
    if (self.isComment) {
        if (self.comment_max_id != nil) {
            comment_max_id = self.comment_max_id;
        }
        if (self.comment_since_id != nil) {
            comment_since_id = self.comment_since_id;
        }
    }else{
        if (self.repost_max_id != nil) {
            repost_max_id = self.repost_max_id;
        }
        if (self.repost_since_id != nil) {
            repost_since_id = self.repost_since_id;
        }
    }
    
    NSDictionary *dic = nil;
    NSString *strUrl  = nil;
    
    
    switch (type) {
        case loadComment:
            strUrl = commentUrl;
            dic = @{  @"id" : weiboId,
                      @"count" : @"15"
                      };
            break;
        case loadCommentOld:
            strUrl = commentUrl;
            if ([comment_max_id isEqualToString:@""]) {
                [_tableView footerEndRefreshing];
                return;
            }
            dic = @{ @"id" : weiboId,
                     @"max_id" : comment_max_id,
                     @"count" : @"15"
                     };
            break;
            
        case loadCommentnew:
            strUrl = commentUrl;
            dic = @{  @"id" : weiboId,
                      @"since_id" : comment_since_id,
                      @"count" : @"15"
                      };
            break;
        case loadRepost:
            strUrl = repostUrl;
            dic = @{  @"id" : weiboId,
                      @"count" : @"15"
                      };
            break;
        case loadRepostOld:
            strUrl = repostUrl;
            if ([repost_max_id isEqualToString:@""]) {
                [_tableView footerEndRefreshing];
                return;
            }
            dic = @{ @"id" : weiboId,
                     @"max_id" : repost_max_id,
                     @"count" : @"15"
                     };
            break;
        case loadRepostNew:
            strUrl = repostUrl;
            dic = @{  @"id" : weiboId,
                      @"since_id" : repost_since_id,
                      @"count" : @"15"
                      };
            break;
        default:
            break;
    }

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    [WBHttpRequest requestWithAccessToken:accessToken
                                      url:strUrl
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:tag];
}




- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        NSLog(@"%@",nil);
    }
    NSArray *commentArray = [dic objectForKey:@"comments"];
    NSArray *repostArray  = [dic objectForKey:@"reposts"];
    
    
    
    if (commentArray != nil) {
        [self processCommentData:commentArray Request:request];
    } else if(repostArray != nil){
        [self processRepostData:repostArray Request:request];
    }else{
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
        return;
    }
    
    
    
    
    

}



#pragma mark - DataMethod

- (void)processCommentData:(NSArray *)commentArray Request:(WBHttpRequest *)request
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:commentArray.count];
    NSUInteger currentIndex = 0;
    NSUInteger oldCommLength = 0;
    
    for (NSDictionary *dic in commentArray) {
        CommentModel *comment = [[CommentModel alloc] initWithDataDic:dic];
        [tempArray addObject:comment];
    }
    NSMutableArray *indexPaths= nil;
    if ([request.tag isEqualToString:kLoadCommentNewTag]|[request.tag isEqualToString:kLoadComment]) {
        if (self.commData != nil) {
            [tempArray  addObjectsFromArray:self.commData];
        }else{
            self.commData = tempArray;
        }
    }else if ([request.tag isEqualToString:kLoadCommentOleTag]){
        [tempArray removeObjectAtIndex:0]; //删除第一条记录，因为与现有数组中最后一条是重复的
        currentIndex = self.commData.count; //记录最后一条评论的编号
        oldCommLength = tempArray.count; //记录旧的获得评论数的个数
        [self.commData addObjectsFromArray:tempArray];
        indexPaths = [[NSMutableArray alloc] initWithCapacity:oldCommLength];
        for (NSUInteger index = currentIndex; index < self.commData.count; index ++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
    }
    
    
    CommentModel *last = [self.commData lastObject];
    CommentModel *first = [self.commData firstObject];
    self.comment_max_id = [last.id stringValue];
    self.comment_since_id = [first.id stringValue];
    
    if ([request.tag isEqualToString:kLoadCommentNewTag]|[request.tag isEqualToString:kLoadComment]) {
        self.tableView.commmentData = self.commData;
        self.tableView.repostData = nil;
        [self.tableView reloadData];
        [_tableView headerEndRefreshing];
    }else if([request.tag isEqualToString:kLoadCommentOleTag]){
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        [self.tableView reloadData];
        [_tableView footerEndRefreshing];
    }

}


- (void)processRepostData:(NSArray *)repostArray Request:(WBHttpRequest *)request
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:repostArray.count];
    NSUInteger currentIndex = 0;
    NSUInteger oldRepostLength = 0;
    
    for (NSDictionary *dic in repostArray) {
        WeiboModel *repost = [[WeiboModel alloc] initWithDataDic:dic];
        [tempArray addObject:repost];
    }
    NSMutableArray *indexPaths= nil;
    if ([request.tag isEqualToString:kLoadRepostNewTag]|[request.tag isEqualToString:kLoadRepost]) {
        if (self.repostData != nil) {
            [tempArray  addObjectsFromArray:self.repostData];
        }else{
            self.repostData = tempArray;
        }
    }else if ([request.tag isEqualToString:kLoadRepostOleTag]){
        [tempArray removeObjectAtIndex:0]; //删除第一条记录，因为与现有数组中最后一条是重复的
        currentIndex = self.repostData.count; //记录最后一条评论的编号
        oldRepostLength = tempArray.count; //记录旧的获得评论数的个数
        [self.repostData addObjectsFromArray:tempArray];
        indexPaths = [[NSMutableArray alloc] initWithCapacity:oldRepostLength];
        for (NSUInteger index = currentIndex; index < self.repostData.count; index ++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
    }
    
    
    WeiboModel *last = [self.repostData lastObject];
    WeiboModel *first = [self.repostData firstObject];
    self.repost_max_id = [last.weiboId stringValue];
    self.repost_since_id = [first.weiboId stringValue];
    
    if ([request.tag isEqualToString:kLoadRepostNewTag]|[request.tag isEqualToString:kLoadRepost]) {
        self.tableView.repostData = self.repostData;
        self.tableView.commmentData = nil;
        [self.tableView reloadData];
        [_tableView headerEndRefreshing];
    }else if([request.tag isEqualToString:kLoadRepostOleTag]){
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        [self.tableView reloadData];
        [_tableView footerEndRefreshing];
    }

    
}


#pragma mark - CommentTableView Delegate
- (void)changeRepostOrComment:(NSUInteger)ButtonTag
{
    switch (ButtonTag) {
        case 100:
            self.isComment = NO;
            [self loadCommentsDataWithType:loadRepost Tag:kLoadRepost];
            break;
        case 101:
            self.isComment = YES;
            [self loadCommentsDataWithType:loadComment Tag:kLoadComment];
            break;
            
        default:
            break;
    }
}

 #pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
