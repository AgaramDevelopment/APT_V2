//
//  ResultsVc.h
//  NewSportsProject
//
//  Created by Mac on 18/11/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsCell.h"

@interface ResultsVc : UIViewController


@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (nonatomic,strong) IBOutlet UITableView * ListTbl;
@property (nonatomic,strong) IBOutlet ResultsCell * objCell;

@property (nonatomic,strong) IBOutlet UIView * ShawdowView;

@property (nonatomic,strong)  NSString * backKey;

@property (nonatomic,strong) IBOutlet UITableView * popTbl;

@property (nonatomic,strong) IBOutlet UIButton * CompetBtn;
@property (nonatomic,strong) IBOutlet UIButton * teamBtn;

@property (nonatomic,strong) IBOutlet UIView * v1;
@property (nonatomic,strong) IBOutlet UIView * v2;
@property (nonatomic,strong) IBOutlet UIView * v3;

@property (nonatomic,strong)  NSMutableArray * resultArr;

@property (nonatomic,strong)  NSMutableArray * TotalMatchesArr;

@property (nonatomic,strong)IBOutlet  UILabel * competitionLbl;
@property (strong, nonatomic) IBOutlet UILabel *teamLbl;
@property (strong, nonatomic) IBOutlet UILabel *venueLbl;

@property (nonatomic,strong)  NSMutableArray * listCompArray;

@end
