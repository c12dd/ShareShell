//
//  ViewControllerManager.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-24.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ViewControllerManager.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ICETutorialController.h"
#import "WeiboDelegate.h"
@implementation ViewControllerManager
+ (void)getViewControllerWithType:(ViewControllerType)type
{
    UIViewController *controller = [[[self alloc] init] controllerByType:type];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = controller;
    
}



- (UIViewController *)controllerByType:(ViewControllerType)type
{
    UIViewController *viewController = nil;
    switch (type) {
        case ViewControllerTypeMain:
            viewController = [[MainViewController alloc] init];
            break;
        case ViewControllerTypeLogin:
            viewController = (UIViewController *)[self getGuideViewController];

            break;
        case ViewControllerTypeGuide:
            viewController = (UIViewController *)[self getGuideViewController];

            break;
            
        default:
            break;
    }
    return viewController;
}

- (ICETutorialController *)getGuideViewController
{
    


    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                            description:@"每天都要微笑,因为每天都是新的开始！ "pictureName:@"tutorial_background_00@2x.jpg"];
    
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                            description:@"路很长，总会有雨天！"pictureName:@"tutorial_background_01@2x.jpg"];
    
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                            description:@"但是无论去哪天气怎样，都要带上自己的阳光！"
                                                            pictureName:@"tutorial_background_02@2x.jpg"];
//    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:@""
//                                                            description:@""
//                                                            pictureName:@"tutorial_background_03@2x.jpg"];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                            description:@"生日快乐！"
                                                            pictureName:@"tutorial_background_04@2x.jpg"];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer5];
    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    ICETutorialController *viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone" bundle:nil andPages:tutorialLayers];

    [viewController setCommonPageSubTitleStyle:subStyle];
    [viewController setCommonPageDescriptionStyle:descStyle];
    
    // Set button 1 action.
    [viewController setButton1Block:^(UIButton *button){
    //点击登录按钮响应登录方法
    [WeiboDelegate loginRequest];
    }];
    

    return viewController;
    
}


@end
