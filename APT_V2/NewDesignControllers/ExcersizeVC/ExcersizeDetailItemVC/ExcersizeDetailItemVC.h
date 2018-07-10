//
//  ExcersizeDetailItemVC.h
//  AlphaProTracker
//
//  Created by MAC on 19/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ExcersizeDetailItemVC : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic,assign) BOOL isImage;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,assign) BOOL isPDF;
@property (nonatomic) NSUInteger indexPath;

@property (nonatomic, strong) NSArray *contentImages;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end


