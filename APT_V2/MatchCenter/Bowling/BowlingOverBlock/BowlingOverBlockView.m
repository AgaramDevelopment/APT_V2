//
//  BattingOverBlockView.m
//  APT_V2
//
//  Created by apple on 26/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "BowlingOverBlockView.h"
#import "BowlingOverBlockCVC.h"
#import "WebService.h"
#import "Config.h"
#import "AppCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BowlingOverBlockView

@synthesize lblCompetetion,teamlbl;

@synthesize competView,teamView;

-(void) loadPowerPlayDetails {
    
    
    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
    NSString *plyRolecode = @"ROL0000002";
    
    if([rolecode isEqualToString:plyRolecode])
    {
        self.teamView.hidden = YES;
    }
    else
    {
        self.teamView.hidden = NO;
    }
    
    self.PopTableView.hidden = YES;
    self.pp1CollectionView.dataSource = self;
    self.pp1CollectionView.delegate = self;
    
    self.pp2CollectionView.dataSource = self;
    self.pp2CollectionView.delegate = self;
    
    self.pp3CollectionView.dataSource = self;
    self.pp3CollectionView.delegate = self;
    
    [self.pp1CollectionView registerNib:[UINib nibWithNibName:@"BowlingOverBlockCVC" bundle:nil] forCellWithReuseIdentifier:@"bowlingOverBlockCVC"];
    
    [self.pp2CollectionView registerNib:[UINib nibWithNibName:@"BowlingOverBlockCVC" bundle:nil] forCellWithReuseIdentifier:@"bowlingOverBlockCVC"];
    
    [self.pp3CollectionView registerNib:[UINib nibWithNibName:@"BowlingOverBlockCVC" bundle:nil] forCellWithReuseIdentifier:@"bowlingOverBlockCVC"];
    
    [self OverblockWebservice];
    
}

#pragma mark UICollectionView


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 5;
    
    if(collectionView == self.pp1CollectionView){
        return self.CollectionPowerPlayArray1.count;
    }else if(collectionView == self.pp2CollectionView){
        return self.CollectionPowerPlayArray2.count;
    }else if(collectionView == self.pp3CollectionView){
        return self.CollectionPowerPlayArray3.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView == self.pp1CollectionView){
        BowlingOverBlockCVC * cell = [self.pp1CollectionView dequeueReusableCellWithReuseIdentifier:@"bowlingOverBlockCVC" forIndexPath:indexPath];
        
        cell.playerNamelbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        cell.playerStylelbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row];
        cell.runslbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"Runs"]objectAtIndex:indexPath.row];
        cell.srlbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"StrikRate"]objectAtIndex:indexPath.row];
        cell.avglbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"Average"]objectAtIndex:indexPath.row];
        cell.dbPrrlbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"DotBallPercent"]objectAtIndex:indexPath.row];
        cell.bdryPerlbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"BoundaryPercent"]objectAtIndex:indexPath.row];
        cell.Overslbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"Overs"]objectAtIndex:indexPath.row];
        cell.econlbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"Econ"]objectAtIndex:indexPath.row];
        cell.Wktslbl.text = [[self.CollectionPowerPlayArray1 valueForKey:@"Wickets"]objectAtIndex:indexPath.row];
        
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.CollectionPowerPlayArray1 valueForKey:@"PlayerPhotoLink"] objectAtIndex:indexPath.row]];
        
//        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.playerImg.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.playerImg.image = image;
//            }
//            else
//            {
//                cell.playerImg.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        
        [cell.playerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        return cell;
        
    }else if(collectionView == self.pp2CollectionView){
        BowlingOverBlockCVC * cell = [self.pp1CollectionView dequeueReusableCellWithReuseIdentifier:@"bowlingOverBlockCVC" forIndexPath:indexPath];
        
        cell.playerNamelbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        cell.playerStylelbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row];
        cell.runslbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"Runs"]objectAtIndex:indexPath.row];
        cell.srlbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"StrikRate"]objectAtIndex:indexPath.row];
        cell.avglbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"Average"]objectAtIndex:indexPath.row];
        cell.dbPrrlbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"DotBallPercent"]objectAtIndex:indexPath.row];
        cell.bdryPerlbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"BoundaryPercent"]objectAtIndex:indexPath.row];
        cell.Overslbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"Overs"]objectAtIndex:indexPath.row];
        cell.econlbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"Econ"]objectAtIndex:indexPath.row];
        cell.Wktslbl.text = [[self.CollectionPowerPlayArray2 valueForKey:@"Wickets"]objectAtIndex:indexPath.row];
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.CollectionPowerPlayArray2 valueForKey:@"PlayerPhotoLink"] objectAtIndex:indexPath.row]];
//        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.playerImg.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.playerImg.image = image;
//            }
//            else
//            {
//                cell.playerImg.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.playerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        return cell;
        
    }else if(collectionView == self.pp3CollectionView){
        BowlingOverBlockCVC * cell = [self.pp1CollectionView dequeueReusableCellWithReuseIdentifier:@"bowlingOverBlockCVC" forIndexPath:indexPath];
        
        
        
        cell.playerNamelbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        cell.playerStylelbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row];
        cell.runslbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"Runs"]objectAtIndex:indexPath.row];
        cell.srlbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"StrikRate"]objectAtIndex:indexPath.row];
        cell.avglbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"Average"]objectAtIndex:indexPath.row];
        cell.dbPrrlbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"DotBallPercent"]objectAtIndex:indexPath.row];
        cell.bdryPerlbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"BoundaryPercent"]objectAtIndex:indexPath.row];
        cell.Overslbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"Overs"]objectAtIndex:indexPath.row];
        cell.econlbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"Econ"]objectAtIndex:indexPath.row];
        cell.Wktslbl.text = [[self.CollectionPowerPlayArray3 valueForKey:@"Wickets"]objectAtIndex:indexPath.row];
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.CollectionPowerPlayArray3 valueForKey:@"PlayerPhotoLink"] objectAtIndex:indexPath.row]];
//        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.playerImg.image = image;
//                
//                // cache the image for use later (when scrolling up)
//                cell.playerImg.image = image;
//            }
//            else
//            {
//                cell.playerImg.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.playerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        return cell;
        
    }
    
    return nil;
    
    
    
}


-(void)OverblockWebservice
{
    
    if(![COMMON isInternetReachable])
    {
        return;
    }
    else if ([lblCompetetion.text isEqualToString:@"Competetion Name"]) {
        
        return;
    }
    else if([AppCommon isCoach] && [teamlbl.text isEqualToString:@"Team Name"])
    {
        return;
    }

    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    //NSString *clientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    WebService *objWebservice;
    
    //NSString *CompetitionCode = @"UCC0000008";
    //NSString *teamcode = @"TEA0000010";
    
    NSString *CompetitionCode = [AppCommon getCurrentCompetitionCode];
    NSString *teamcode = [AppCommon getCurrentTeamCode];
    self.lblCompetetion.text = [AppCommon getCurrentCompetitionName];
    self.teamlbl.text = [AppCommon getCurrentTeamName];
    objWebservice = [[WebService alloc]init];
    
    
    [objWebservice BattingOverBlock :bowlingOverblockKey :CompetitionCode :teamcode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            self.ProgressPowerPlayArray1 = [[NSMutableArray alloc]init];
            self.ProgressPowerPlayArray2 = [[NSMutableArray alloc]init];
            self.ProgressPowerPlayArray3 = [[NSMutableArray alloc]init];
            
            self.CollectionPowerPlayArray1 = [[NSMutableArray alloc]init];
            self.CollectionPowerPlayArray2 = [[NSMutableArray alloc]init];
            self.CollectionPowerPlayArray3 = [[NSMutableArray alloc]init];
            
            
            self.ProgressPowerPlayArray1 = [responseObject valueForKey:@"PPOneResult"];
            self.ProgressPowerPlayArray2 = [responseObject valueForKey:@"PPTwoResult"];
            self.ProgressPowerPlayArray3 = [responseObject valueForKey:@"PPThreeResult"];
            
            self.CollectionPowerPlayArray1 = [responseObject valueForKey:@"PPOneBlockResult"];
            self.CollectionPowerPlayArray2 = [responseObject valueForKey:@"PPTwoBlockResult"];
            self.CollectionPowerPlayArray3 = [responseObject valueForKey:@"PPThreeBlockResult"];
            
            
            
            self.runslbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"Runs"] objectAtIndex:0];
            self.runratelbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"RPO"] objectAtIndex:0];
            self.dbPerlbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"DotBallPercent"] objectAtIndex:0];
            self.wktslbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"Wickets"] objectAtIndex:0];
            self.srlbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"StrikRate"] objectAtIndex:0];
            self.avglbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"AVG"] objectAtIndex:0];
            self.bdryPerlbl1.text = [[self.ProgressPowerPlayArray1 valueForKey:@"BoundaryPercent"] objectAtIndex:0];
            
            
            
            
            self.runslbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"Runs"] objectAtIndex:0];
            self.runratelbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"RPO"] objectAtIndex:0];
            self.dbPerlbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"DotBallPercent"] objectAtIndex:0];
            self.wktslbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"Wickets"] objectAtIndex:0];
            self.srlbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"StrikRate"] objectAtIndex:0];
            self.avglbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"AVG"] objectAtIndex:0];
            self.bdryPerlbl2.text = [[self.ProgressPowerPlayArray2 valueForKey:@"BoundaryPercent"] objectAtIndex:0];
            
            
            self.runslbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"Runs"] objectAtIndex:0];
            self.runratelbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"RPO"] objectAtIndex:0];
            self.dbPerlbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"DotBallPercent"] objectAtIndex:0];
            self.wktslbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"Wickets"] objectAtIndex:0];
            self.srlbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"StrikRate"] objectAtIndex:0];
            self.avglbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"AVG"] objectAtIndex:0];
            self.bdryPerlbl3.text = [[self.ProgressPowerPlayArray3 valueForKey:@"BoundaryPercent"] objectAtIndex:0];
            
            
            //runsprogress
            float runscount1 = [self.runslbl1.text floatValue];
            float runscount2 = [self.runslbl2.text floatValue];
            float runscount3 = [self.runslbl3.text floatValue];
            float totalrunscount = runscount1+runscount2+runscount3;
            float runsper1 = (runscount1/totalrunscount)*100;
            float runsper2 = (runscount2/totalrunscount)*100;
            float runsper3 = (runscount3/totalrunscount)*100;
            
            self.runsPrgs1.progress = runsper1/100;
            self.runsPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.runsPrgs1.flat = @YES;
            self.runsPrgs1.borderRadius = @2;
            self.runsPrgs1.showBackgroundInnerShadow = @YES;
            //self.runsPrgs1.progress = 0.40;
            self.runsPrgs1.animate = @YES;
            
            
            
            self.runsPrgs2.progress = runsper2/100;
            self.runsPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.runsPrgs2.flat = @YES;
            self.runsPrgs2.borderRadius = @2;
            self.runsPrgs2.showBackgroundInnerShadow = @YES;
            //self.runsPrgs1.progress = 0.40;
            self.runsPrgs2.animate = @YES;
            
            self.runsPrgs3.progress = runsper3/100;
            self.runsPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.runsPrgs3.flat = @YES;
            self.runsPrgs3.borderRadius = @2;
            self.runsPrgs3.showBackgroundInnerShadow = @YES;
            //self.runsPrgs1.progress = 0.40;
            self.runsPrgs3.animate = @YES;
            
            
            
            //runrate
            
            float runRatecount1 = [self.runratelbl1.text floatValue];
            float runRatecount2 = [self.runratelbl2.text floatValue];
            float runRatecount3 = [self.runratelbl3.text floatValue];
            float totalrunRatecount = runRatecount1+runRatecount2+runRatecount3;
            float runrateper1 = (runRatecount1/totalrunRatecount)*100;
            float runrateper2 = (runRatecount2/totalrunRatecount)*100;
            float runrateper3 = (runRatecount3/totalrunRatecount)*100;
            
            self.runratePrgs1.progress = runrateper1/100;
            self.runratePrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.runratePrgs1.flat = @YES;
            self.runratePrgs1.borderRadius = @2;
            self.runratePrgs1.showBackgroundInnerShadow = @YES;
            self.runratePrgs1.animate = @YES;
            
            
            self.runratePrgs2.progress = runrateper2/100;
            self.runratePrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.runratePrgs2.flat = @YES;
            self.runratePrgs2.borderRadius = @2;
            self.runratePrgs2.showBackgroundInnerShadow = @YES;
            self.runratePrgs2.animate = @YES;
            
            self.runratePrgs3.progress = runrateper3/100;
            self.runratePrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.runratePrgs3.flat = @YES;
            self.runratePrgs3.borderRadius = @2;
            self.runratePrgs3.showBackgroundInnerShadow = @YES;
            self.runratePrgs3.animate = @YES;
            
            
            //dbper
            
            float dbcount1 = [self.dbPerlbl1.text floatValue];
            float dbcount2 = [self.dbPerlbl2.text floatValue];
            float dbcount3 = [self.dbPerlbl3.text floatValue];
            float Totaldbcount = dbcount1+dbcount2+dbcount3;
            float dbper1 = (dbcount1/Totaldbcount)*100;
            float dbper2 = (dbcount2/Totaldbcount)*100;
            float dbper3 = (dbcount3/Totaldbcount)*100;
            
            self.dbPerPrgs1.progress = dbper1/100;
            self.dbPerPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.dbPerPrgs1.flat = @YES;
            self.dbPerPrgs1.borderRadius = @2;
            self.dbPerPrgs1.showBackgroundInnerShadow = @YES;
            self.dbPerPrgs1.animate = @YES;
            
            
            self.dbPerPrgs2.progress = dbper2/100;
            self.dbPerPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.dbPerPrgs2.flat = @YES;
            self.dbPerPrgs2.borderRadius = @2;
            self.dbPerPrgs2.showBackgroundInnerShadow = @YES;
            self.dbPerPrgs2.animate = @YES;
            
            
            self.dbPerPrgs3.progress = dbper3/100;
            self.dbPerPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.dbPerPrgs3.flat = @YES;
            self.dbPerPrgs3.borderRadius = @2;
            self.dbPerPrgs3.showBackgroundInnerShadow = @YES;
            self.dbPerPrgs3.animate = @YES;
            
            
            //wktsper
            
            float wktscount1 = [self.wktslbl1.text floatValue];
            float wktscount2 = [self.wktslbl2.text floatValue];
            float wktscount3 = [self.wktslbl3.text floatValue];
            float Totalwktscount = wktscount1+wktscount2+wktscount3;
            float wktsper1 = (wktscount1/Totalwktscount)*100;
            float wktsper2 = (wktscount2/Totalwktscount)*100;
            float wktsper3 = (wktscount3/Totalwktscount)*100;
            
            self.WktsPrgs1.progress = wktsper1/100;
            self.WktsPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.WktsPrgs1.flat = @YES;
            self.WktsPrgs1.borderRadius = @2;
            self.WktsPrgs1.showBackgroundInnerShadow = @YES;
            self.WktsPrgs1.animate = @YES;
            
            
            self.WktsPrgs2.progress = wktsper2/100;
            self.WktsPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.WktsPrgs2.flat = @YES;
            self.WktsPrgs2.borderRadius = @2;
            self.WktsPrgs2.showBackgroundInnerShadow = @YES;
            self.WktsPrgs2.animate = @YES;
            
            
            self.WktsPrgs3.progress = wktsper3/100;
            self.WktsPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.WktsPrgs3.flat = @YES;
            self.WktsPrgs3.borderRadius = @2;
            self.WktsPrgs3.showBackgroundInnerShadow = @YES;
            self.WktsPrgs3.animate = @YES;
            
            
            
            //srsper
            
            float srcount1 = [self.srlbl1.text floatValue];
            float srcount2 = [self.srlbl2.text floatValue];
            float srcount3 = [self.srlbl3.text floatValue];
            float Totalsrcount = srcount1+srcount2+srcount3;
            float srper1 = (srcount1/Totalsrcount)*100;
            float srper2 = (srcount2/Totalsrcount)*100;
            float srper3 = (srcount3/Totalsrcount)*100;
            
            self.srPrgs1.progress = srper1/100;
            self.srPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.srPrgs1.flat = @YES;
            self.srPrgs1.borderRadius = @2;
            self.srPrgs1.showBackgroundInnerShadow = @YES;
            self.srPrgs1.animate = @YES;
            
            self.srPrgs2.progress = srper2/100;
            self.srPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.srPrgs2.flat = @YES;
            self.srPrgs2.borderRadius = @2;
            self.srPrgs2.showBackgroundInnerShadow = @YES;
            self.srPrgs2.animate = @YES;
            
            
            self.srPrgs3.progress = srper3/100;
            self.srPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.srPrgs3.flat = @YES;
            self.srPrgs3.borderRadius = @2;
            self.srPrgs3.showBackgroundInnerShadow = @YES;
            self.srPrgs3.animate = @YES;
            
            
            //avgsper
            
            float avgcount1 = [self.avglbl1.text floatValue];
            float avgcount2 = [self.avglbl2.text floatValue];
            float avgcount3 = [self.avglbl3.text floatValue];
            float Totalavgcount = avgcount1+avgcount2+avgcount3;
            float avgper1 = (avgcount1/Totalavgcount)*100;
            float avgper2 = (avgcount2/Totalavgcount)*100;
            float avgper3 = (avgcount3/Totalavgcount)*100;
            
            self.avgPrgs1.progress = avgper1/100;
            self.avgPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.avgPrgs1.flat = @YES;
            self.avgPrgs1.borderRadius = @2;
            self.avgPrgs1.showBackgroundInnerShadow = @YES;
            self.avgPrgs1.animate = @YES;
            
            self.avgPrgs2.progress = avgper2/100;
            self.avgPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.avgPrgs2.flat = @YES;
            self.avgPrgs2.borderRadius = @2;
            self.avgPrgs2.showBackgroundInnerShadow = @YES;
            self.avgPrgs2.animate = @YES;
            
            self.avgPrgs3.progress = avgper3/100;
            self.avgPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.avgPrgs3.flat = @YES;
            self.avgPrgs3.borderRadius = @2;
            self.avgPrgs3.showBackgroundInnerShadow = @YES;
            self.avgPrgs3.animate = @YES;
            
            
            //bdrysper
            
            float bdrycount1 = [self.bdryPerlbl1.text floatValue];
            float bdrycount2 = [self.bdryPerlbl1.text floatValue];
            float bdrycount3 = [self.bdryPerlbl1.text floatValue];
            float Totalbdrycount = bdrycount1+bdrycount2+bdrycount3;
            float bdryper1 = (bdrycount1/Totalbdrycount)*100;
            float bdryper2 = (bdrycount2/Totalbdrycount)*100;
            float bdryper3 = (bdrycount3/Totalbdrycount)*100;
            
            
            self.bdryPerPrgs1.progress = bdryper1/100;
            self.bdryPerPrgs1.color = [UIColor colorWithRed:(192/255.0f) green:(9/255.0f) blue:(0/255.0f) alpha:1.00f];
            self.bdryPerPrgs1.flat = @YES;
            self.bdryPerPrgs1.borderRadius = @2;
            self.bdryPerPrgs1.showBackgroundInnerShadow = @YES;
            self.bdryPerPrgs1.animate = @YES;
            
            self.bdryPerPrgs2.progress = bdryper2/100;
            self.bdryPerPrgs2.color = [UIColor colorWithRed:(46/255.0f) green:(117/255.0f) blue:(182/255.0f) alpha:1.00f];
            self.bdryPerPrgs2.flat = @YES;
            self.bdryPerPrgs2.borderRadius = @2;
            self.bdryPerPrgs2.showBackgroundInnerShadow = @YES;
            self.bdryPerPrgs2.animate = @YES;
            
            self.bdryPerPrgs3.progress = bdryper3/100;
            self.bdryPerPrgs3.color = [UIColor colorWithRed:(254/255.0f) green:(217/255.0f) blue:(102/255.0f) alpha:1.00f];
            self.bdryPerPrgs3.flat = @YES;
            self.bdryPerPrgs3.borderRadius = @2;
            self.bdryPerPrgs3.showBackgroundInnerShadow = @YES;
            self.bdryPerPrgs3.animate = @YES;
        
            [self.pp1CollectionView reloadData];
            [self.pp2CollectionView reloadData];
            [self.pp3CollectionView reloadData];
        
        }
        [AppCommon hideLoading];
        
    }
                             failure:^(AFHTTPRequestOperation *operation, id error) {
                                 NSLog(@"failed");
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


- (IBAction)onClickCompetition:(id)sender
{
    if(isCompe){
        
        isTeam = NO;
        isCompe = NO;
        self.PopTableView.hidden = YES;
        
        
    }else{
        isTeam = NO;
        isCompe = YES;
        self.PopTableView.hidden = NO;
        //self.tableWidth.constant = 142;
        //self.tableXposition.constant = self.filterView.frame.origin.x+8+142+16;
        
        self.tableWidth.constant = self.competView.frame.size.width;
        self.tableXposition.constant = self.competView.frame.origin.x;
        self.tableYposition.constant = self.competView.frame.origin.y;
        
        [self.PopTableView reloadData];
        
    }
}

- (IBAction)onClickTeam:(id)sender
{
    if(isTeam){
        
        isCompe = NO;
        isTeam = NO;
        self.PopTableView.hidden = YES;
        
        
    }else{
        isCompe = NO;
        isTeam = YES;
        self.PopTableView.hidden = NO;
        //self.tableWidth.constant = 142;
        //self.tableXposition.constant = self.filterView.frame.origin.x+8+142+16;
        
        self.tableWidth.constant = self.teamView.frame.size.width;
        self.tableXposition.constant = self.teamView.frame.origin.x;
        self.tableYposition.constant = self.teamView.frame.origin.y;
        
        [self.PopTableView reloadData];
        
    }
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if(isCompe==YES)
    {
        return appDel.ArrayCompetition.count;
    }
    else if(isTeam==YES)
    {
        return appDel.ArrayTeam.count;
    }
    return nil;
    
}
// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *MyIdentifier = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    if(isCompe ==YES)
    {
        cell.textLabel.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
    }
    else if(isTeam == YES)
    {
        cell.textLabel.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        
    }
    
    
    
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isCompe == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
        
        self.lblCompetetion.text = [self checkNull:[[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"]];
        NSLog(@"Competition:%@", self.lblCompetetion.text);
        NSString* Competetioncode = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(isTeam == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
        
        self.teamlbl.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        NSString* teamcode = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
        [[NSUserDefaults standardUserDefaults] setValue:self.teamlbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    //isCompe = NO;
    //isTeam = NO;
    self.PopTableView.hidden = YES;
    
    [self OverblockWebservice];
    
}

- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

- (IBAction)actionCompetetionTeam:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    
    if ([sender tag] == 1) { // TEAM
        
        
        dropVC.array = [COMMON getCorrespondingTeamName:lblCompetetion.text];
        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(teamView.frame), CGRectGetMaxY(teamView.superview.frame)+70, CGRectGetWidth(teamView.frame), 300)];
        
    }
    else // COMPETETION
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(competView.frame), CGRectGetMaxY(competView.superview.frame)+70, CGRectGetWidth(competView.frame), 300)];
        
    }
    
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        lblCompetetion.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* competitionCode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        [[NSUserDefaults standardUserDefaults] setValue:lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:competitionCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        teamlbl.text = @"Team Name";
        
        
        
    }
    else
    {
        NSString* TeamCode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        teamlbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        [[NSUserDefaults standardUserDefaults] setValue:teamlbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:TeamCode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    [self OverblockWebservice];
    
    
}

@end

