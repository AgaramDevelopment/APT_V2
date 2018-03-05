//
//  SchResStandVC.m
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "SchResStandVC.h"
#import "Config.h"
#import "HomeScreenStandingsVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "WebService.h"
#import "AppCommon.h"
#import "VideoGalleryVC.h"
#import "ScoreCardVC.h"
#import "VideoPlayerViewController.h"


@interface SchResStandVC ()
{
    HomeScreenStandingsVC *StandsVC;
    VideoGalleryVC *objVideo;
    NSString *displayMatchCode;
    VideoPlayerViewController * videoPlayerVC;
}

@property (strong, nonatomic)  NSMutableArray *commonArray;
@property (strong, nonatomic)  NSMutableArray *commonArray2;

@end

@implementation SchResStandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self customnavigationmethod];

    [self.scheduleCollectionView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    
    
//    StandsVC = [[HomeScreenStandingsVC alloc] initWithNibName:@"HomeScreenStandingsVC" bundle:nil];
//    StandsVC.view.frame = CGRectMake(0, self.resultView.frame.origin.y+210, self.view.bounds.size.width, self.view.bounds.size.height);
//    [self.commonView addSubview:StandsVC.view];
    
    objVideo = [[VideoGalleryVC alloc] initWithNibName:@"VideoGalleryVC" bundle:nil];
    objVideo.view.frame = CGRectMake(0, self.resultView.frame.origin.y+210, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.commonView addSubview:objVideo.view];
    
   
     //self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, self.commonView.frame.size.height);
    
    self.scroll.contentSize =  self.commonView.frame.size;
    
    [self ScheduleWebservice];

    
}



-(void)ScheduleWebservice
{
 
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",ScheduleKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
        if(playerCode)   [dic    setObject:playerCode     forKey:@"PlayerCode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSMutableArray *scheduleArray = [responseObject valueForKey:@"EventDetails"];
                NSMutableArray *resultArray = [responseObject valueForKey:@"ResultsValues"];
                
                self.commonArray = scheduleArray;
                self.commonArray2 = resultArray;
                
                
                [self.scheduleCollectionView reloadData];
                [self.resultCollectionView reloadData];
            }
            
            [AppCommon hideLoading];
            [self.view setUserInteractionEnabled:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
             [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            [self.view setUserInteractionEnabled:YES];
            
        }];
    }
    
}





- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
     if(collectionView == self.scheduleCollectionView)
     {
         return self.commonArray.count;
     }
    else
    {
    return self.commonArray2.count;
    }
}
#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_DEVICE)
    {
        if(!IS_IPHONE5)
        {
            return CGSizeMake(50, 50);
        }
        else
        {
            if(collectionView == self.scheduleCollectionView)
            {
            return CGSizeMake(224, 135);
            }
            else
            {
                return CGSizeMake(310, 182);
            }
        }
    }
    else
    {
        //return CGSizeMake(160, 140);
        
        if(collectionView == self.scheduleCollectionView)
        {
            return CGSizeMake(250, 135);
        }
        else
        {
            return CGSizeMake(310, 182);
        }
    }
}
#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return UIEdgeInsetsMake(20, 20, 30, 20); // top, left, bottom, right
    }
    else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return 20.0;
    }
    else{
        return 10.0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return 23.0;
    }
    else{
        return 10.0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    if(collectionView==self.scheduleCollectionView)
    {
    
        ScheduleCell* cell = [self.scheduleCollectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        
        
        cell.eventNamelbl.text = [[self.commonArray valueForKey:@"EventName"] objectAtIndex:indexPath.row];
        NSString *starttime = [[self.commonArray valueForKey:@"EventStartTime"] objectAtIndex:indexPath.row];
        NSString *endtime = [[self.commonArray valueForKey:@"EventEndTime"] objectAtIndex:indexPath.row];
       // cell.timelbl.text = [NSString stringWithFormat:@"%@ to %@",starttime,endtime];
        cell.venuelbl.text = [[self.commonArray valueForKey:@"EventVenue"] objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *date  = [dateFormatter dateFromString:starttime];
        // Convert to new Date Format
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *newtime1 = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH:mm:ss"];
        NSDate *date2  = [dateFormatter2 dateFromString:endtime];
        // Convert to new Date Format
        [dateFormatter2 setDateFormat:@"hh:mm a"];
        NSString *newtime2 = [dateFormatter2 stringFromDate:date2];
        
        cell.timelbl.text = [NSString stringWithFormat:@"%@ to %@",newtime1,newtime2];

        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    return cell;
    }
    if(collectionView==self.resultCollectionView)
    {
        
       ResultCell* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        
        
        cell.competitionNamelbl.text = [[self.commonArray2 valueForKey:@"COMPETITIONNAME"]objectAtIndex:indexPath.row];
        cell.datelbl.text = [[self.commonArray2 valueForKey:@"DateTime"]objectAtIndex:indexPath.row];
        //cell.teamAlbl.text = [[self.commonArray2 valueForKey:@"TeamA"]objectAtIndex:indexPath.row];
        //cell.teamBlbl.text = [[self.commonArray2 valueForKey:@"TeamB"]objectAtIndex:indexPath.row];
        cell.resultlbl.text = [[self.commonArray2 valueForKey:@"MATCHRESULTORRUNSREQURED"]objectAtIndex:indexPath.row];
        
        
        
        NSString *first = [self checkNull:[[self.commonArray2 valueForKey:@"FIRSTINNINGSSCORE"]objectAtIndex:indexPath.row]];
            NSLog(@"%ld",(long)indexPath.row);
          cell.FirstInnScorelbl.text = first;
       
        
        NSString *second = [self checkNull:[[self.commonArray2 valueForKey:@"SECONDINNINGSSCORE"]objectAtIndex:indexPath.row]];
            NSLog(@"%ld",(long)indexPath.row);
        cell.SecondInnScorelbl.text = second;
       
        
        NSString *third = [self checkNull:[[self.commonArray2 valueForKey:@"THIRDINNINGSSCORE"]objectAtIndex:indexPath.row]];
            NSLog(@"%ld",(long)indexPath.row);
        cell.ThirdInnScorelbl.text = third;
        
        
        NSString *fourth = [self checkNull:[[self.commonArray2 valueForKey:@"FOURTHINNINGSSCORE"]objectAtIndex:indexPath.row]];
            NSLog(@"%ld",(long)indexPath.row);
        cell.FouthInnScorelbl.text = fourth;
        
        
        NSString * imgStr1 = ([[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"]==[NSNull null])?@"":[[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"];
        NSString *teamAString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr1];
        
        NSString * imgStr2 = ([[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"]==[NSNull null])?@"":[[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"];
        NSString *teamBString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr2];
        
        [self downloadImageWithURL:[NSURL URLWithString:teamAString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.teamAlogo.image = image;
                
                // cache the image for use later (when scrolling up)
                cell.teamAlogo.image = image;
            }
            else
            {
                cell.teamAlogo.image = [UIImage imageNamed:@"no-image"];
            }
        }];
        
        
        [self downloadImageWithURL:[NSURL URLWithString:teamBString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.teamBlogo.image = image;
                
                // cache the image for use later (when scrolling up)
                cell.teamBlogo.image = image;
            }
            else
            {
                cell.teamBlogo.image = [UIImage imageNamed:@"no-image"];
            }
        }];
        
        
        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        return cell;
      }

    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(collectionView==self.resultCollectionView)
    {
        displayMatchCode = [[self.commonArray2 valueForKey:@"MATCHCODE"] objectAtIndex:indexPath.row];
        NSMutableArray *scoreArray = [[NSMutableArray alloc]init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSString *ground = [[self.commonArray2 valueForKey:@"Ground"]objectAtIndex:indexPath.row];
        NSString *place = [[self.commonArray2 valueForKey:@"GroundCode"]objectAtIndex:indexPath.row];
        
        [dic setValue:[NSString stringWithFormat:@"%@,%@",ground,place] forKey:@"ground"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamA"] objectAtIndex:indexPath.row] forKey:@"team1"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamB"]objectAtIndex:indexPath.row] forKey:@"team2"];
        [dic setValue:[[self.commonArray2 valueForKey:@"FIRSTINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn1Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"SECONDINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn2Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"THIRDINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn3Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"FOURTHINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn4Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"MATCHRESULTORRUNSREQURED"]objectAtIndex:indexPath.row] forKey:@"result"];
        [dic setValue:[[self.commonArray2 valueForKey:@"COMPETITIONNAME"]objectAtIndex:indexPath.row] forKey:@"Competition"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamALogo"]objectAtIndex:indexPath.row] forKey:@"TeamALogo"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamBLogo"]objectAtIndex:indexPath.row] forKey:@"TeamBLogo"];
        
        [scoreArray addObject:dic];
        
        
        
                ScoreCardVC * objFix = [[ScoreCardVC alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        objFix = (ScoreCardVC *)[storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVC"];
                objFix.matchCode = displayMatchCode;
                objFix.matchDetails = scoreArray;
                objFix.backkey = @"yes";
                //[self.navigationController pushViewController:objFix animated:YES];
                [appDel.frontNavigationController pushViewController:objFix animated:YES];
        
                //[self.view addSubview:objFix];
          //[self displayContentController:objFix];
        
    }
    
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];                 // 1
    content.view.bounds = self.view.bounds;                 //2
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
