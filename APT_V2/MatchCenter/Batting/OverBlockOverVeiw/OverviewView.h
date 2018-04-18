//
//  OverviewView.h
//  APT_V2
//
//  Created by apple on 23/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@import Charts;

@interface OverviewView : UIView<ChartViewDelegate,IChartAxisValueFormatter,UITableViewDelegate,UITableViewDataSource,selectedDropDown>
{
    NSString *Barvalue;
    NSString *linevalue;
}

@property (nonatomic, strong) IBOutlet CombinedChartView *barChartPP1;
-(void) loadChart;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (strong, nonatomic) IBOutlet UIView *competView;
@property (strong, nonatomic) IBOutlet UIView *teamView;
@property (strong, nonatomic) IBOutlet UIView *barView;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableYposition;
@property (nonatomic, strong) IBOutlet UITableView *PoplistTable;
@property (nonatomic, strong) IBOutlet UILabel *overViewlbl;
@property (nonatomic, strong) IBOutlet UILabel *runslbl;
@property (nonatomic, strong) IBOutlet UILabel *lblCompetetion;
@property (nonatomic, strong) IBOutlet UILabel *teamlbl;
@property (strong, nonatomic) IBOutlet CombinedChartView *barChartPP2;

@property (strong, nonatomic) IBOutlet CombinedChartView *barChartPP3;


@property (nonatomic, strong)  NSMutableArray *lineValuesArray1;
@property (nonatomic, strong)  NSMutableArray *BarValuesArray1;

@property (nonatomic, strong)  NSMutableArray *lineValuesArray2;
@property (nonatomic, strong)  NSMutableArray *BarValuesArray2;

@property (nonatomic, strong)  NSMutableArray *lineValuesArray3;
@property (nonatomic, strong)  NSMutableArray *BarValuesArray3;


@end
