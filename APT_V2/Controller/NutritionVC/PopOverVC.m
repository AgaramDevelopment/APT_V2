//
//  PopOverVC.m
//  APT_V2
//
//  Created by MAC on 22/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "PopOverVC.h"
#import "Config.h"
#import "PopOverVCCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"
#import "PlannerAddEvent.h"
#import "DocumentViewController.h"
#import "TabHomeVC.h"
#import "ScoreCardVideoPlayer.h"
#import "NewVideoDocumentVC.h"

@interface PopOverVC ()

@end

@implementation PopOverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"listArray:Count:%lu", (unsigned long)self.listArray.count);
    NSLog(@"listArray:%@", self.listArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return (IS_IPAD ? 50 : 40);
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    PopOverVCCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
//    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PopOverVCCell" owner:self options:nil];
//
//    // 1. Dequeue the custom header cell
//    headerCell = arr[0];
//    NSString *count = [NSString stringWithFormat:@"%ld", self.listArray.count];
////    headerCell.notificationCountLbl.text = notificationsCount;
//    headerCell.notificationCountLbl.text = count;
//    // 3. And return
//    return headerCell;
//}

#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listArray.count) {
        return self.listArray.count;
    } else {
        self.noNotificationLabel.hidden = NO;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    PopOverVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PopOverVCCell" owner:self options:nil];
    
        // 1. Dequeue the custom header cell
    cell = arr[1];
        //Images
        //    [self.team1ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [key valueForKey:@"ATLogo"]]] placeholderImage:[UIImage imageNamed:@"no-image"]]; //team_logo_csk
    [cell.notificationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]] placeholderImage:[UIImage imageNamed:@"player_andr"]];
    cell.notificationTitleLbl.text = [self.listArray objectAtIndex:indexPath.row];
    cell.notificationDescrLbl.text = @"29w 6d 19h ago";
        // 3. And return
    return cell;
    */
  
    PopOverVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PopOverVCCell" owner:self options:nil];
    
    // 1. Dequeue the custom header cell
    cell = arr[1];
        //Images
    [cell.notificationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.listArray valueForKey:@"UserPhoto"]]] placeholderImage:[UIImage imageNamed:@"Default_userimage"]];
    cell.notificationTitleLbl.text = [[self.listArray valueForKey:@"Description"]objectAtIndex:indexPath.row];
    cell.notificationDescrLbl.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
    // 3. And return
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"TypeDesc"] isEqualToString:@"video"]) {
    
        NSString* fileName = [[self.listArray objectAtIndex:indexPath.item] valueForKey:@"FilePath"];
        ScoreCardVideoPlayer *videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
        videoPlayerVC = (ScoreCardVideoPlayer *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
        videoPlayerVC.isFromHome = YES;
        videoPlayerVC.HomeVideoStr = fileName;
        NSLog(@"appDel.frontNavigationController.topViewController %@",appDel.frontNavigationController.topViewController);
        
        [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:^{
            [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
        }];

    
    } else if ([[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"TypeDesc"] isEqualToString:@"file"]) {
        
//        DocumentViewController *documentObj = [DocumentViewController new];
//        documentObj.isNotificationPDF = YES;
//        documentObj.filePath = [[self.listArray objectAtIndex:indexPath.item] valueForKey:@"FilePath"];
//        [appDel.frontNavigationController presentViewController:documentObj animated:YES completion:nil];
        
        NewVideoDocumentVC * documentObject = [[NewVideoDocumentVC alloc] initWithNibName:@"NewVideoDocumentVC" bundle:nil];
        documentObject.documentLink = [[self.listArray objectAtIndex:indexPath.item] valueForKey:@"FilePath"];
        documentObject.titleString = @"Documents";
        [appDel.frontNavigationController presentViewController:documentObject animated:YES completion:nil];

        
    } else if ([[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"TypeDesc"] isEqualToString:@"Event"]) {
        
        PlannerAddEvent  * objaddEvent = (PlannerAddEvent *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"AddEvent"];
        objaddEvent.isEdit =YES;
        objaddEvent.isNotification = @"yes";
        objaddEvent.eventType = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"Type"];
        [appDel.frontNavigationController pushViewController:objaddEvent animated:YES];
    
    }
    
    NSString *notificationCode = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"NotificationCode"];
    if (![notificationCode isEqualToString:@""]) {
            //Read Notification for UPDATENOTIFICATIONS
        [self updateNotificationsPostService:notificationCode];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 70;
    } else {
        return 60;
    }
}


-(void)updateNotificationsPostService:(NSString *)notificationCode
{
    /*
     API URL    :   http://192.168.0.154:8029/AGAPTService.svc/APT_UPDATENOTIFICATIONS
     METHOD     :   POST
     PARAMETER  :   {Clientcode}/{NotificationCode}/{ParticipantCode}
     */
    
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString *userRefcode = [AppCommon GetuserReference];
    
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *URLString =  URL_FOR_RESOURCE(UpdateNotifications);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
    if(userRefcode)   [dic    setObject:userRefcode     forKey:@"ParticipantCode"];
    
    
    [dic setObject:notificationCode forKey:@"NotificationCode"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        if ([[responseObject valueForKey:@"Success"] isEqualToString:@"Success"]) {
            
        }
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

- (NSString *)checkNSNumber:(id)unknownTypeParameter {
    
    NSString *str;
    if([unknownTypeParameter isKindOfClass:[NSNumber class]])
        {
        
        NSNumber *vv = unknownTypeParameter;
        str = [vv stringValue];
        }
    else
        {
        str = unknownTypeParameter;
        }
    return str;
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
