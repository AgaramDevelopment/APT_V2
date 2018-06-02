//
//  TeamsVC.m
//  APT_V2
//
//  Created by Apple on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TeamsVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"
#import "TeamMembersVC.h"

@interface TeamsVC ()
{
    TeamMembersVC *objPlayersVC;
}

@property (strong, nonatomic)  NSMutableArray *teamslist;

@end

@implementation TeamsVC

@synthesize lblNoData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self customnavigationmethod];
    [self TeamsWebservice];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    //UIView* view= self.navigation_view.subviews.firstObject;
    [self.navi_View addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden =NO;
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //        [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)TeamsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
        
        
        [AppCommon showLoading];
        
        NSString *URLString =  URL_FOR_RESOURCE(TeamsKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                self.teamslist = [[NSMutableArray alloc]init];
                self.teamslist = responseObject;
                
                [self.teamsTable reloadData];
            }
            
            [AppCommon hideLoading];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
            
        }];
    
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    [lblNoData setHidden:self.teamslist.count];
    return self.teamslist.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    ProfileVCCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ProfileVCCell" owner:self options:nil];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefaultreuseIdentifier:MyIdentifier];
    }
    
    cell=self.objProfilecell;
    NSString *ss = [[self.teamslist valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
    NSLog(@"%@",ss);
    //cell.backgroundColor = [UIColor clearColor];
    cell.Teamsname.text = [[self.teamslist valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * imgStr1 = [[self.teamslist valueForKey:@"TeamPhotoLink"] objectAtIndex:indexPath.row];

    [self downloadImageWithURL:[NSURL URLWithString:imgStr1] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            cell.teamLogo.image = image;

            // cache the image for use later (when scrolling up)
            cell.teamLogo.image = image;
        }
    }];
    
    cell.cellview.layer.shadowOffset = CGSizeMake(1, 0);
    cell.cellview.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.cellview.layer.shadowRadius = 5;
    cell.cellview.layer.shadowOpacity = 1.0;
    cell.cellview.layer.masksToBounds = YES;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.navi_View.hidden = YES;
    objPlayersVC = [[TeamMembersVC alloc] initWithNibName:@"TeamMembersVC" bundle:nil];
    objPlayersVC.teamCode = [[self.teamslist valueForKey:@"Teamcode"] objectAtIndex:indexPath.row];
    objPlayersVC.teamname = [[self.teamslist valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
//    objPlayersVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    [self.view addSubview:objPlayersVC.view];
    
//    TeamMembersVC* VC = [TeamMembersVC new];
//    VC.teamCode = [[self.teamslist valueForKey:@"Teamcode"] objectAtIndex:indexPath.row];
//    VC.teamname = [[self.teamslist valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:VC animated:YES];
    [appDel.frontNavigationController pushViewController:objPlayersVC animated:YES];
}



@end
