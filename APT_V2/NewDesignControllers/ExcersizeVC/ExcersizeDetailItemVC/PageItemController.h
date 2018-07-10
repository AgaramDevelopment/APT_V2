//
//  PageItemController.h
//  Paging
//
//  Created by MAC on 20/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PageItemController : UIViewController
// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic,assign) BOOL currentImage;
@property (nonatomic,assign) BOOL currentVideo;
@property (nonatomic,assign) BOOL currentPDF;
@property (nonatomic,strong)  NSString * currentURL;
// Video Player Objects
@property (strong,nonatomic) AVPlayerViewController *avPlayerViewController;
@property (strong,nonatomic) AVPlayer *avPlayer;
// IBOutlet
@property (strong, nonatomic) IBOutlet UIImageView *playerImageView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
