//
//  PageItemController.m
//  Paging
//
//  Created by MAC on 20/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import "PageItemController.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "AppCommon.h"
@interface PageItemController ()

@end

@implementation PageItemController

#pragma mark View Lifecycle

// ***
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=4.0;
    self.scrollView.contentSize = CGSizeMake(self.playerImageView.frame.size.width, self.playerImageView.frame.size.height);

    //Load View based on Item.
    if(self.currentImage) {
        self.playerImageView.hidden = NO;
        self.webView.hidden = YES;
        [self loadImageView];
    } else if (self.currentVideo) {
        self.playerImageView.hidden = YES;
        self.webView.hidden = YES;
        [self videoPlayer];
    } else if (self.currentPDF) {
        self.playerImageView.hidden = YES;
        self.webView.hidden = NO;
        [self loadWebView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Content
- (void)loadImageView {
    self.playerImageView.backgroundColor = [UIColor clearColor];
    NSURL *url=[NSURL URLWithString:self.currentURL];
    [self.playerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_image"]];
}
-(void) videoPlayer {
    
    NSURL *videoURL = [NSURL URLWithString:self.currentURL];
    
    self.avPlayer = [AVPlayer playerWithURL:videoURL];
    self.avPlayerViewController = [AVPlayerViewController new];
    self.avPlayerViewController.player = self.avPlayer;
    self.avPlayerViewController.view.frame = _videoView.bounds;
    [self.videoView addSubview:self.avPlayerViewController.view];
    [self.avPlayer play];
}

- (IBAction)closeVideo:(id)sender {
    
    self.playerImageView.hidden = YES;
    self.webView.hidden = YES;
    
    if(self.currentVideo) {
        [self.avPlayer seekToTime:CMTimeMake(0, 1)];
        [self.avPlayer pause];
        [self.avPlayerViewController.view removeFromSuperview];
        self.avPlayer = NULL;
    }
    self.videoView.hidden = YES;
    
    //   [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadWebView {
//    [COMMON loadingIcon:self.view];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    NSURL*url=[[NSURL alloc]initWithString:self.currentURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    [COMMON RemoveLoadingIcon];
    NSLog(@"webViewDidFinishLoad");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.playerImageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
