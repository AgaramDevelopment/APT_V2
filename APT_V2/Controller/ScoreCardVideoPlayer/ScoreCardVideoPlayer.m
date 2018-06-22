//
//  ScoreCardVideoPlayer.m
//  APT_V2
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ScoreCardVideoPlayer.h"
#import "VideoPlayerViewController.h"
#import "WebService.h"
#import "CustomNavigation.h"
#import "Config.h"
#import "AppCommon.h"
#import "BallsInVideosCVC.h"

@interface ScoreCardVideoPlayer () <TappabbleViewDelegate>
{
    NSMutableArray  *videoURLArray;
    int selectedVideo;
    AVPlayerItem* videoItem;
    BOOL playerIconsHidden;
}

@property (strong, nonatomic) IBOutletCollection(TappabbleView) NSArray *tappableViews;
@end


@implementation TappabbleView


@end

@implementation ScoreCardVideoPlayer

@synthesize PlayerCode,VideoValue,Innings,Type;
@synthesize MatchCode,playerIcons,playerIconBottom;

@synthesize HomeVideoStr,isFromHome;

@synthesize SeekBarSlider,avQplayer;

-(void)didTapView:(TappabbleView *)view
{
    if (view.tag == 1)
    {
        // Play And Pause
        [self playAndPause:nil];
    } else if (view.tag == 2)
    {
        // Previous Frame
        [self previousFrame:nil];
    } else if (view.tag == 3)
    {
        // Next Frame
        [self nextFrame:nil];
    } else if (view.tag == 4)
    {
        // Slow Forward
        [self slowForward:nil];
    } else if (view.tag == 5)
    {
        // Fast Forward
        [self fastForward:nil];
    } else if (view.tag == 6)
    {
        // Previous
        [self previous:nil];
    } else if (view.tag == 7)
    {
        // Next
        [self next:nil];
    } else if (view.tag == 8)
    {
        // Full Screen
        [self fullScreen:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootVideoView.hidden = YES;
    self.avPlayerViewController = [AVPlayerViewController new];
    selectedVideo = 0;
    
    
    if (isFromHome) {
        self.avPlayerViewController.showsPlaybackControls = YES;
        [playerIcons setHidden:YES];
        [self playHomeVideos:HomeVideoStr];
    }
    else
    {
        self.avPlayerViewController.showsPlaybackControls = NO;
        [playerIcons setHidden:NO];
        [self loadVideoPathsForPlayer:PlayerCode andValue:VideoValue type:Type inningsCount:Innings];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setUpProgressView:) object:nil];
    [self.myTimer invalidate];
    self.myTimer = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 - (void)moveBannerOffScreen {
 [self.view layoutIfNeeded];
 
 _addBannerDistanceFromBottomConstraint.constant = -32;
 [UIView animateWithDuration:5
 animations:^{
 [self.view layoutIfNeeded]; // Called on parent view
 }];
 bannerIsVisible = FALSE;
 }
 
 - (void)moveBannerOnScreen {
 [self.view layoutIfNeeded];
 
 _addBannerDistanceFromBottomConstraint.constant = 0;
 [UIView animateWithDuration:5
 animations:^{
 [self.view layoutIfNeeded]; // Called on parent view
 }];
 bannerIsVisible = TRUE;
 }
 */

-(IBAction)animationOpen
{
    NSLog(@"video view tapped");
    if (playerIconsHidden) {
        [self iConShow];
    }
    else
    {
        [self iConHide];
    }

}

-(void)iConShow
{
    [self.playerIcons layoutIfNeeded];
    self.playerIconBottom.constant = -110;
    
    [UIView animateWithDuration:5.0 delay:1.0 usingSpringWithDamping:0.1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.playerIconBottom.constant = 0;
        [self.playerIcons layoutIfNeeded];
    } completion:^(BOOL finished) {
        playerIconsHidden = NO;
        [self performSelector:@selector(animationOpen) withObject:nil afterDelay:5.0];

    }];
}

-(void)iConHide
{
    [self.playerIcons layoutIfNeeded];
    self.playerIconBottom.constant = 0;
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.playerIconBottom.constant = -110;
        [self.playerIcons layoutIfNeeded];
    } completion:^(BOOL finished) {
        playerIconsHidden = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationOpen) object:nil];
    }];
}
#pragma mark UICollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return videoURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BallsInVideosCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ballsInVideosCVC" forIndexPath:indexPath];
    
    
    cell.ballLbl.layer.masksToBounds = true;
    cell.ballLbl.clipsToBounds = true;
    cell.ballLbl.layer.cornerRadius = cell.ballLbl.frame.size.width/2;
    NSLog(@"cell.ballLbl.layer.cornerRadius:%f", cell.ballLbl.layer.cornerRadius);
    
    
    cell.ballLbl.text = [NSString stringWithFormat:@"%ld",((long)indexPath.row+1)];
    
    if(selectedVideo == indexPath.row){
        
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor whiteColor];
        
    }else{
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        
        
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (selectedVideo == (int) indexPath.row) {
    //        return;
    //    }
    selectedVideo = (int) indexPath.row;
    [self playNextVideo:selectedVideo];
    
}


-(void)playHomeVideos:(NSString *)sampleURL
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        self.rootVideoView.hidden = NO;
//        [self.ballsColView reloadData];
        
        //Video Player
//        NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
//        NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
    
    NSString *escapedString = [sampleURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"escapedString: %@", escapedString);
//    let updatedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    sampleURL = [sampleURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"URLQueryAllowedCharacterSet %@",sampleURL);

//    sampleURL = [sampleURL stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        NSURL *videoURL = [NSURL URLWithString:[sampleURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        
        [self.avPlayer seekToTime:CMTimeMake(0, 1)];
        [self.avPlayer pause];
        self.avPlayer = [AVPlayer playerWithURL:videoURL];
        
        self.avPlayerViewController.player = self.avPlayer;
        self.avPlayerViewController.view.frame = _videoView.bounds;
        [_videoView addSubview:self.avPlayerViewController.view];
        
        [self playAndPause:@""];
//    });

}

-(void)loadQueuedURL
{
    
    NSMutableArray<AVPlayerItem *> *arrItems = [NSMutableArray new];
   
    if(videoURLArray.count>0)
    {
    for (NSDictionary* temp in videoURLArray) { // VIDEOFILE
        
        NSString *url = [temp valueForKey:@"VIDEOFILE"];
        //NSURL *videoURL = [NSURL URLWithString:url];
         NSURL *videoURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        AVPlayerItem* item = [AVPlayerItem playerItemWithURL:videoURL];
        [arrItems addObject:item];

    }
    
    avQplayer = [AVQueuePlayer queuePlayerWithItems:arrItems];
    [self playAndPause:nil];
    }
    
}


#pragma mark Video player methods


//GETSCORECARDVIDEOSFILEPATH/' + BatsmanCode + '/' + $scope.MatchCode + '/' + $scope.DefaultInn + '/' + value + '/' + batorbowl

-(void)loadVideoPathsForPlayer:(NSString *)batsmanCode andValue:(NSString *) value type:(NSString *) batOrBowl inningsCount:(NSString *)innno
{
    
    [AppCommon showLoading];
    WebService *objWebservice = [[WebService alloc]init];
    
    
    [objWebservice GetVideoPathFile :GetVideoFilePath  :batsmanCode :MatchCode : innno :value : batOrBowl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setDictionary:responseObject];
            
            videoURLArray= [[NSMutableArray alloc] init];
            videoURLArray =  [dic1 valueForKey:@"lstScoreCardVideoFilePathValuesRuns"];
            
            if(videoURLArray.count >0){
                selectedVideo = 0;
                //                self.rootVideoView.hidden = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rootVideoView.hidden = NO;
                    [self.ballsColView reloadData];
                    [self loadQueuedURL];
                    
                    //Video Player
                    NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
                    NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];



                    NSURL *videoURL = [NSURL URLWithString:url];

                    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
                    [self.avPlayer pause];
                    self.avPlayer = [AVPlayer playerWithURL:videoURL];
                    
                    self.avPlayerViewController.player = self.avPlayer;
                    
//                    self.avPlayerViewController.player = avQplayer
                    self.avPlayerViewController.view.frame = _videoView.bounds;
                    [_videoView addSubview:self.avPlayerViewController.view];
                    
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationOpen)];
                    [self.avPlayerViewController.contentOverlayView addGestureRecognizer:tap];
                    [self.avPlayerViewController.contentOverlayView setUserInteractionEnabled:YES];
                    
                    [self playAndPause:@""];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rootVideoView.hidden = YES;
                    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
                    [self.avPlayer pause];
                    //    [self.avPlayerViewController.view removeFromSuperview];
                    //    self.avPlayer = NULL;
                    
                    //    _rootVideoView.hidden = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            //[self setDataDictInTableView: dic1];
            
        }
        
        [AppCommon hideLoading];
        self.view.userInteractionEnabled = true;
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        //NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        self.view.userInteractionEnabled = true;
    }];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];

    [[NSNotificationCenter defaultCenter] removeObserver:notification];
    
//    if((selectedVideo+1)<videoURLArray.count){
//        selectedVideo = selectedVideo +1;
//
//        [self.ballsColView reloadData];
//
//        NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
//        NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
//
//
//
//        NSURL *videoURL = [NSURL URLWithString:url];
//
//        [self.avPlayer seekToTime:CMTimeMake(0, 1)];
//        [self.avPlayer pause];
//        //        [self.avPlayerViewController.view removeFromSuperview];
//        //        self.avPlayer = NULL;
//
//
//        self.avPlayer = [AVPlayer playerWithURL:videoURL];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer];
//
//
//        //        self.avPlayerViewController.player = self.avPlayer;
//        //        self.avPlayerViewController.view.frame = _videoView.bounds;
//        //        [_videoView addSubview:self.avPlayerViewController.view];
//
//        //        [self.avPlayer play];
//    }
    
}


- (IBAction)closeVideo:(id)sender {
    
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    //    [self.avPlayerViewController.view removeFromSuperview];
    //    self.avPlayer = NULL;
    
    //    _rootVideoView.hidden = YES;
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationCount" object:nil];
    }];
    
}

- (void) playNextVideo:(int) nextVideo {
   
    [self.avPlayer pause];
//    [self.avQplayer pause];

    self.progressView.progress = 0;
    SeekBarSlider.value = 0;
    selectedVideo = nextVideo;
    
    NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
    NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
    
    NSURL *videoURL = [NSURL URLWithString:url];
    videoItem = [AVPlayerItem playerItemWithURL:videoURL];
    [self.avPlayer replaceCurrentItemWithPlayerItem:videoItem];
//    [avQplayer advanceToNextItem];
    
    [self playAndPause:@""];
    
    [self.ballsColView reloadData];
    
}


- (IBAction)playAndPause:(id)sender {
    
    if (self.avPlayer.rate == 0) {
        /*
         AVPlayerStatusUnknown, 0
         AVPlayerStatusReadyToPlay, 1
         AVPlayerStatusFailed 2
         */
        
        NSLog(@"AVPlayer %d ",self.avPlayer.status);

        NSLog(@"AVPlayer reasonForWaitingToPlay %@ ",self.avPlayer.reasonForWaitingToPlay);
//        [avQplayer pause];
//        [avQplayer play]
        
        [self.avPlayer pause];
        [self.avPlayer play];
        UIImage *pause = [UIImage imageNamed:@"pause"];
        [self.playAndPauseBtn setImage:pause forState:UIControlStateNormal];
        
        //        CMTime totalDuration = self.avPlayer.currentItem.duration;
        //        CMTime currentTime = self.avPlayer.currentItem.currentTime;
        
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setUpProgressView:) userInfo:nil repeats:YES];
        playerIconsHidden = NO;
        [self performSelector:@selector(animationOpen) withObject:nil afterDelay:5.0];
        
        
        
    } else {
        //        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [self.avPlayer pause];
        UIImage *play = [UIImage imageNamed:@"play"];
        [self.playAndPauseBtn setImage:play forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)previousFrame:(id)sender {
    
    [self.avPlayer.currentItem stepByCount:-5];
    UIImage *play = [UIImage imageNamed:@"play"];
    [self.playAndPauseBtn setImage:play forState:UIControlStateNormal];
    
}
- (IBAction)nextFrame:(id)sender {
    
    [self.avPlayer.currentItem stepByCount:5];
    UIImage *play = [UIImage imageNamed:@"play"];
    [self.playAndPauseBtn setImage:play forState:UIControlStateNormal];
    
}
- (IBAction)slowForward:(id)sender {
    
    //0.0 to 1.0 Slow Forward
    /*
     if (self.avPlayer.rate >= 0.0 && self.avPlayer.rate <= 1.0) {
     [self.avPlayer setRate:self.avPlayer.rate - 0.2];
     
     UIImage *pause = [UIImage imageNamed:@"pause"];
     [self.playAndPauseBtn setImage:pause forState:UIControlStateNormal];
     }
     */
    
    [self.avPlayer setRate: 0.5];
}
- (IBAction)fastForward:(id)sender {
    //1.0 to 2.0 Fast Forward
    //-1.0 means reversly playing
    /*
     if (self.avPlayer.rate >= 1.0 && self.avPlayer.rate <= 2.0) {
     [self.avPlayer setRate:self.avPlayer.rate + 0.2];
     UIImage *pause = [UIImage imageNamed:@"pause"];
     [self.playAndPauseBtn setImage:pause forState:UIControlStateNormal];
     }
     */
    [self.avPlayer setRate: 1.5];
}
- (IBAction)previous:(id)sender {
    if (selectedVideo == 0) {
        return;
    }
    [self playNextVideo:--selectedVideo];
}
- (IBAction)next:(id)sender {
    if (selectedVideo == videoURLArray.count-1) {
        return;
    }
    [self playNextVideo:++selectedVideo];
}
- (IBAction)fullScreen:(id)sender {
    //    CGSize temp  = self.vidoeWithCollection.frame.size ;
    //    //    CGSizeEqualToSize(CGSizeZero, mySize)
    //    if ( CGSizeEqualToSize(temp, normalSize)) {
    //        self.vidoeWithCollection.frame = self.view.frame;
    //        self.avPlayerViewController.view.frame = self.view.frame;
    //        self.customView.frame = CGRectMake(0, self.videoView.frame.size.height-self.customView.frame.size.height, self.customView.frame.size.width, self.customView.frame.size.height);
    //        self.ballsColView.frame = CGRectMake(0, CGRectGetMaxY(self.customView.frame)+self.ballsColView.frame.size.height, self.ballsColView.frame.size.width, self.ballsColView.frame.size.height);
    //    } else {
    //        self.vidoeWithCollection.frame = CGRectMake(30, self.view.frame.size.height-self.view.frame.size.height, self.view.frame.size.width-60, 536);
    //        self.avPlayerViewController.view.frame = CGRectMake(30, 40, self.vidoeWithCollection.frame.size.width-60, 400);
    //    }
}
- (IBAction)volume:(id)sender {
    //0.0 to 1.0 (Silent to Maximum Volume)
    self.avPlayer.volume = self.sliderVolume.value;
    NSLog(@"Volume:%f", self.avPlayer.volume);
}

- (void) setUpProgressView:(NSTimer *)timer
{
    float totalDuration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    float currentTime = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime);
    NSLog(@"totalDuration:%f", totalDuration);
    NSLog(@"currentTime:%f", currentTime);
    float progressValue = currentTime/totalDuration;
    self.progressView.progress = progressValue;
    SeekBarSlider.value = progressValue;
    
//    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
//        [SeekBarSlider setMaximumValue:totalDuration];
//        [SeekBarSlider setMinimumValue:0];
//    }

    
    if (currentTime ==  totalDuration) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setUpProgressView:) object:nil];
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.progressView.progress = 0;
        SeekBarSlider.value = 0;
        UIImage *play = [UIImage imageNamed:@"play"];
        [self.playAndPauseBtn setImage:play forState:UIControlStateNormal];
        
        //Automatically Play Next Video upto end of Video List
        if (selectedVideo < videoURLArray.count-1) {
            [self playNextVideo:++selectedVideo];
            [self.ballsColView reloadData];
        }
    }
}

/*
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
*/



- (IBAction)actionSeekBarSlider:(id)sender {
    
//    if (self.avPlayer.rate != 0 && self.avPlayer.error == nil) {
////        SeekBarSlider.value = 0;
//        NSLog(@"PLayer not playing");
//        return;
//    }
    
    float totalDuration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    
    CMTime newTime = CMTimeMakeWithSeconds(SeekBarSlider.value * totalDuration, self.avPlayer.currentTime.timescale);
    [self.avPlayer seekToTime:newTime];
    [self playAndPause:nil];
    
//    [self.avPlayer pause];
//    [self.avPlayer play];


}
@end

