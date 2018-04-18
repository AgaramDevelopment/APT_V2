//
//  ScoreCardVideoPlayer.h
//  APT_V2
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 user. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@class TappabbleView;
@protocol TappabbleViewDelegate<NSObject>
-(void)didTapView:(TappabbleView *)view;
@end
@interface TappabbleView: UIView
@property (nonatomic) id<TappabbleViewDelegate> delegate;
@end

@interface ScoreCardVideoPlayer : UIViewController

@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *rootVideoView;
@property (strong, nonatomic) IBOutlet UICollectionView *ballsColView;
@property (strong,nonatomic) AVPlayerViewController *avPlayerViewController;
@property (strong,nonatomic) AVPlayer *avPlayer;
@property (strong,nonatomic) AVQueuePlayer* avQplayer; 

@property (strong,readwrite) NSString* MatchCode;
@property (strong,readwrite) NSString* TeamCode;
@property (strong,readwrite) NSString* PlayerCode;
@property (strong,readwrite) NSString* VideoValue;
@property (strong,readwrite) NSString* Innings;
@property (strong,readwrite) NSString* Type;
@property (strong,nonatomic) NSString* HomeVideoStr;

@property (strong, nonatomic) IBOutlet UISlider *sliderVolume;
@property (strong, nonatomic) IBOutlet UIView *vidoeWithCollection;
@property (strong, nonatomic) IBOutlet UIView *customView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;
@property (strong, nonatomic) IBOutlet UIButton *playAndPauseBtn;
@property BOOL isFromHome;
- (IBAction)closeVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerIcons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerIconBottom;
@property (weak, nonatomic) IBOutlet UISlider *SeekBarSlider;
- (IBAction)actionSeekBarSlider:(id)sender;

@end
