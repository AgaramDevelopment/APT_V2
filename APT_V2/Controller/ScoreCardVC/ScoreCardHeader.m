//
//  ScoreCardHeader.m
//  APT_V2
//
//  Created by Apple on 17/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ScoreCardHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ScoreCardHeader ()

@end

@implementation ScoreCardHeader

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   if( self.matchDetailsArray.count>0)
   {
    self.resultlbl.layer.masksToBounds = YES;
    self.resultlbl.layer.cornerRadius = 8;
    
    self.competitionTypelbl.text = [[self.matchDetailsArray valueForKey:@"Tournament"] objectAtIndex:0];
    //self.resultlbl.text = [NSString stringWithFormat:@"   %@ " ,  [[self.matchDetailsArray valueForKey:@"MatchResult"] objectAtIndex:0]];
    
    self.teamAlbl.text = [[self.matchDetailsArray valueForKey:@"BattingTeamName"] objectAtIndex:0];
    self.teamBlbl.text = [[self.matchDetailsArray valueForKey:@"BowlingTeamName"] objectAtIndex:0];
    
    //self.teamAScorelbl.text = [[matchDetailsImageArray valueForKey:@"Inn1Score"] objectAtIndex:0];
    // self.teamBScorelbl.text = [[matchDetailsImageArray valueForKey:@"Inn2Score"] objectAtIndex:0];
    self.groundlbl.text = [[self.matchDetailsArray valueForKey:@"Venue"] objectAtIndex:0];
    
    
    self.teamAScorelbl.text = [[self.matchDetailsArray valueForKey:@"TeamAScore"] objectAtIndex:0];
    self.teamBScorelbl.text = [[self.matchDetailsArray valueForKey:@"TeamBScore"] objectAtIndex:0];
    self.groundlbl.text = [[self.matchDetailsArray valueForKey:@"Venue"] objectAtIndex:0];
    self.resultlbl.text = [NSString stringWithFormat:@"   %@ " ,  [[self.matchDetailsArray valueForKey:@"MatchResult"] objectAtIndex:0]];
    
    
    //[self.Team1 setTitle:[[matchDetailsImageArray valueForKey:@"BattingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
    //[self.Team2 setTitle:[[matchDetailsImageArray valueForKey:@"BowlingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
    
    //                [self.Inn1 setTitle:[NSString stringWithFormat:@"Inn1-%@" , [[self.matchDetails valueForKey:@"team1"] objectAtIndex:0]] forState:UIControlStateNormal];
    //                [self.Inn2 setTitle:[NSString stringWithFormat:@"Inn2-%@" ,[[self.matchDetails valueForKey:@"team2"] objectAtIndex:0]] forState:UIControlStateNormal];
    //                [self.Inn3 setTitle:[NSString stringWithFormat:@"Inn3-%@" , [[self.matchDetails valueForKey:@"team1"] objectAtIndex:0]] forState:UIControlStateNormal];
    //                [self.Inn4 setTitle:[NSString stringWithFormat:@"Inn4-%@" ,[[self.matchDetails valueForKey:@"team2"] objectAtIndex:0]] forState:UIControlStateNormal];
    
    NSString * imgStr1 = ([[self.matchDetailsArray objectAtIndex:0] valueForKey:@"BattingTeamlogo"]==[NSNull null])?@"":[[self.matchDetailsArray objectAtIndex:0] valueForKey:@"BattingTeamlogo"];
    NSString *teamAString = [NSString stringWithFormat:@"%@",imgStr1];
    
    NSString * imgStr2 = ([[self.matchDetailsArray objectAtIndex:0] valueForKey:@"BowlingTeamlogo"]==[NSNull null])?@"":[[self.matchDetailsArray objectAtIndex:0] valueForKey:@"BowlingTeamlogo"];
    NSString *teamBString = [NSString stringWithFormat:@"%@",imgStr2];
    
//    [self downloadImageWithURL:[NSURL URLWithString:imgStr1] completionBlock:^(BOOL succeeded, UIImage *image) {
//        if (succeeded) {
//            // change the image in the cell
//            self.teamAlogo.image = image;
//
//            // cache the image for use later (when scrolling up)
//            self.teamAlogo.image = image;
//        }
//        else
//        {
//            self.teamAlogo.image = [UIImage imageNamed:@"no-image"];
//        }
//    }];
    [self.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
    
//    [self downloadImageWithURL:[NSURL URLWithString:imgStr2] completionBlock:^(BOOL succeeded, UIImage *image) {
//        if (succeeded) {
//            // change the image in the cell
//            self.teamBlogo.image = image;
//
//            // cache the image for use later (when scrolling up)
//            self.teamBlogo.image = image;
//        }
//        else
//        {
//            self.teamBlogo.image = [UIImage imageNamed:@"no-image"];
//        }
//    }];
   [self.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
   }
    
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
