//
//  BattingView.m
//  APT_V2
//
//  Created by apple on 19/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "BattingView.h"
#import "PlayerListCollectionViewCell.h"
#import "Config.h"
#import "AppCommon.h"
#import "WebService.h"
#import "HorizontalXLblFormatter.h"
//#import "DayAxisValueFormatter.h"


@implementation BattingView
@synthesize insideCompetitionView;

@synthesize overallView,runsView,CompetitionView,teamView;

@synthesize overViewlbl,runslbl,lblteam,lblCompetetion;

NSArray* headingKeyArray;
NSArray* headingButtonNames;
BOOL isOverview;
BOOL isRun;
BOOL isComp;
BOOL isTeams;
BOOL runSortingKey;


/* Filter */


#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isOverview==YES)
    {
        return 7;
    }
    if(isRun==YES)
    {
        return 3;

    }else if(isComp==YES){
        return appDel.ArrayCompetition.count;
    }else if(isTeams==YES){
        return appDel.ArrayTeam.count;
    }
    return nil;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    if(isOverview==YES)
    {
        cell.textLabel.text = indexPath.row == 0 ? @"Overall" : indexPath.row == 1 ? @"Batting 1st" : indexPath.row == 2 ? @"Batting 2nd" :  indexPath.row == 3 ? @"Batting 1st Won" :  indexPath.row == 4 ? @"Batting 2nd Won" :  indexPath.row == 5 ? @"Batting 1st Lost" :  @"Batting 2nd Lost";

    }else if(isRun==YES)
    {
        cell.textLabel.text = indexPath.row == 0 ? @"Runs" : (indexPath.row == 1 ? @"Strike Rate" : @"Average");

    }else if(isComp==YES)
    {
        cell.textLabel.text = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"];
    }
    else if(isTeams==YES)
    {
        cell.textLabel.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
    }

    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isOverview==YES)
    {
        self.overViewlbl.text = indexPath.row == 0 ? @"Overall" : indexPath.row == 1 ? @"Batting 1st" : indexPath.row == 2 ? @"Batting 2nd" :  indexPath.row == 3 ? @"Batting 1st Won" :  indexPath.row == 4 ? @"Batting 2nd Won" :  indexPath.row == 5 ? @"Batting 1st Lost" :  @"Batting 2nd Lost";
        
        if(indexPath.row==0)
        {
            innNum =@"";
            Result = @"";
        }
        else if(indexPath.row==1)
        {
            innNum =@"1";
            Result = @"";
        }
        else if(indexPath.row==2)
        {
            innNum =@"2";
            Result = @"";
        }
        else if(indexPath.row==3)
        {
            innNum =@"1";
            Result = @"won";
        }
        else if(indexPath.row==4)
        {
            innNum =@"2";
            Result = @"won";
        }
        else if(indexPath.row==5)
        {
            innNum =@"1";
            Result = @"loss";
        }
        else if(indexPath.row==6)
        {
            innNum =@"2";
            Result = @"loss";
        }
        
    }else if(isRun==YES)
    {
        self.runslbl.text = indexPath.row == 0 ? @"Runs" : (indexPath.row == 1 ? @"Strike Rate" : @"Average");
        
        if(indexPath.row==0)
        {
            types =@"runs";
        }
        else if(indexPath.row==1)
        {
            types =@"sr";
        }
        else if(indexPath.row==2)
        {
            types =@"avg";
        }
        
    }
    else if(isComp==YES)
    {
    
        self.lblCompetetion.text = [self checkNull:[[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"]];
    NSLog(@"Competition:%@", self.lblCompetetion.text);
        NSString* Competetioncode = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];
    NSLog(@"Competetioncode:%@", Competetioncode);
        [[NSUserDefaults standardUserDefaults] setValue:self.lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(isTeams==YES)
    {
        self.lblteam.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        NSString* teamcode = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
        [[NSUserDefaults standardUserDefaults] setValue:self.lblteam.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
//
    isOverview = NO;
    isRun = NO;
    isComp = NO;
    isTeams = NO;
    self.PoplistTable.hidden = YES;

    if( ![self.overViewlbl.text isEqualToString:@""] && ![self.runslbl.text isEqualToString:@""] )
    {
        [self BattingWebservice];
    }
}

- (IBAction)onClickOverViewDD:(id)sender
{
    if(isOverview){
        
        isOverview = NO;
        isRun = NO;
        isComp = NO;
        isTeams = NO;
        self.PoplistTable.hidden = YES;

        
    }else{

    isOverview = YES;
    isRun = NO;
    isComp = NO;
    isTeams = NO;
    
    self.PoplistTable.hidden = NO;
    
    self.tableWidth.constant = self.overallView.frame.size.width;
    self.tableXposition.constant = self.overallView.frame.origin.x;
    self.tableYposition.constant = self.overallView.frame.origin.y;
       
    [self.PoplistTable reloadData];
    
    }
}

- (IBAction)onClickRunsDD:(id)sender
{
    if(isRun){
        
        isOverview = NO;
        isRun = NO;
        isComp = NO;
        isTeams = NO;
        self.PoplistTable.hidden = YES;

        
    }else{
    isOverview = NO;
    isRun = YES;
    isComp = NO;
    isTeams = NO;
    self.PoplistTable.hidden = NO;
        self.tableWidth.constant = self.runsView.frame.size.width;
        self.tableXposition.constant = self.runsView.frame.origin.x;
        self.tableYposition.constant = self.runsView.frame.origin.y;
        
        [self.PoplistTable reloadData];
        
    }
}

- (IBAction)onClickCompetition:(id)sender
{
    if(isRun){

        isOverview = NO;
        isRun = NO;
        isComp = NO;
        isTeams = NO;
        self.PoplistTable.hidden = YES;


    }else{
        isOverview = NO;
        isRun = NO;
        isComp = YES;
        isTeams = NO;
        self.PoplistTable.hidden = NO;
        self.tableWidth.constant = self.CompetitionView.frame.size.width;
        self.tableXposition.constant = self.CompetitionView.frame.origin.x;
        self.tableYposition.constant = self.CompetitionView.frame.origin.y;
        
        [self.PoplistTable reloadData];
       
    }

}

- (IBAction)onClickTeam:(id)sender
{
    if(isRun){
        
        isOverview = NO;
        isRun = NO;
        isComp = NO;
        isTeams = NO;
        self.PoplistTable.hidden = YES;
        
        
    }else{
        isOverview = NO;
        isRun = NO;
        isComp = NO;
        isTeams = YES;
        self.PoplistTable.hidden = NO;
        self.tableWidth.constant = self.teamView.frame.size.width;
        self.tableXposition.constant = self.teamView.frame.origin.x;
        self.tableYposition.constant = self.teamView.frame.origin.y;
        
        [self.PoplistTable reloadData];
        
    }
    
}



/* Table Freez */
-(void) loadTableFreez{
    
//    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
//    NSString *plyRolecode = @"ROL0000002";
//    
//    if([rolecode isEqualToString:plyRolecode])
//    {
//        self.teamView.hidden = YES;
//    }
//    else
//    {
//        self.teamView.hidden = NO;
//    }

    self.PoplistTable.delegate = self;
    self.PoplistTable.dataSource = self;

    
   // headingKeyArray =  @[@"Player",@"Style",@"Order",@"Mat",@"Inns",@"NO",@"Runs",@"BF",@"HS",@"Ave",@"SR",@"DB %",@"Bdry %",@"100",@"50",@"0",@"4s",@"6s"];
    
    headingKeyArray =  @[@"PlayerName",@"BattingStyle",@"BattingOrder",@"TotalMatches",@"Innings",@"NotOuts",@"Runs",@"BallsFace",@"Highscore",@"Average",@"StrikRate",@"DotBallPercent",@"BoundaryPercent",@"Cents",@"Fiftys",@"DotBall",@"Fours",@"Sixs"];
    
    
    headingButtonNames = @[@"Player",@"Style",@"Order",@"Mat",@"Inns",@"NO",@"Runs",@"BF",@"HS",@"Ave",@"SR",@"DB %",@"Bdry %",@"100",@"50",@"0",@"4s",@"6s"];
    
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"PlayerListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ContentCellIdentifier"];
    
    
    self.resultCollectionView.delegate = self;
    self.resultCollectionView.dataSource = self;
    
}


#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    //return headingButtonNames.count;
    
    if(self.TableValuesArray.count>0)
    {
        return self.TableValuesArray.count+1;
        //return headingButtonNames.count;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return headingButtonNames.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_DEVICE)
    {
        if(!IS_IPHONE5)
        {
            return CGSizeMake(130, 35);
        }
        else
        {
            
            return CGSizeMake(150, 40);
        }
    }
    else
    {
        
        return CGSizeMake(200, 50);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlayerListCollectionViewCell* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"ContentCellIdentifier" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:167.0/255.0 blue:219.0/255.0 alpha:1.0];
        
        
        
        [cell.lblRightShadow setHidden:YES];
        cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        
        for (id value in headingButtonNames) {
            
            if ([headingButtonNames indexOfObject:value] == indexPath.row) {
                [cell.btnName setTitle:value forState:UIControlStateNormal];
                cell.btnName.secondTag = indexPath.row;
                cell.btnName.titleLabel.numberOfLines = 2;
                
                break;
            }
        }
        if ([cell.btnName.currentTitle isEqualToString:@"Runs"]) {
            [cell.btnName addTarget:self action:@selector(RunsSorting) forControlEvents:UIControlEventTouchUpInside];
        }

        cell.btnName.userInteractionEnabled = YES;
        
    }
    else
    {
        [cell.lblRightShadow setHidden:(indexPath.row == 0 ? NO : YES)];
        if (!cell.lblRightShadow.isHidden) {
            cell.lblRightShadow.clipsToBounds = NO;
            [self setShadow:cell.lblRightShadow.layer];
        }
        
        if (indexPath.section % 2 != 0) {
            cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
            
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        [cell.btnName setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        cell.btnName.userInteractionEnabled = NO;
        
        
        for (id temp in headingKeyArray) {
            if ([headingKeyArray indexOfObject:temp] == indexPath.row) {
                 //NSString* str = [AppCommon checkNull:[[PlayerListArray objectAtIndex:indexPath.section-1]valueForKey:temp]];
                NSString *str;
                if (self.TableValuesArray.count) {
                    
                    if([[[self.TableValuesArray objectAtIndex:indexPath.section-1]valueForKey:temp] isKindOfClass:[NSNumber class]])
                        {
                        
                        NSNumber *vv = [self checkNull:[[self.TableValuesArray objectAtIndex:indexPath.section-1]valueForKey:temp]];
                        str = [vv stringValue];
                        }
                    else
                        {
                        str = [self checkNull:[[self.TableValuesArray objectAtIndex:indexPath.section-1]valueForKey:temp]];
                        }
                }
                
                
                if([temp isEqualToString:@"Player"])
                {
                    cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                    //NSLog(@"Player Name %@ ",str);
                }
                else
                {
                    cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                }
                [cell.btnName setTitle:str forState:UIControlStateNormal];
                break;
            }
        }
        
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    //    PlayerStatsVC * nextVC = [[PlayerStatsVC alloc]init];
    //    nextVC = (PlayerStatsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerStats"];
    //    nextVC.SelectedPlayerCode = [[PlayerListArray objectAtIndex:indexPath.section-1] valueForKey:@"PlayerCode"];
    //    [self.navigationController pushViewController:nextVC animated:YES];
    
}
-(void)setShadow:(CALayer *)layer
{
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOffset = CGSizeMake(10,3);
    layer.shadowOpacity = 1.0;
    
    
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}


/*  Chart  */
-(void) loadChart
{
    
    innNum =@"";
    Result = @"";
    types = @"runs";
    [self BattingWebservice];
}

-(void)barchartloadValues
{
    
    
//    [self setupBarLineChartView:_chartView];
    
    _chartView.delegate = self;

    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleCount = 60;

    _chartView.chartDescription.enabled = NO;
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:7.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = self.ChartXAxisValuesArray.count;
   // xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
    xAxis.valueFormatter = [[HorizontalXLblFormatter alloc] initForChart: self.ChartXAxisValuesArray];
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @"";
    leftAxisFormatter.positiveSuffix = @"";
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
    l.enabled = NO;
    [self setDataCount: 0 range: 0];

    
//    XYMarkerView *marker = [[XYMarkerView alloc]
//                            initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                            font: [UIFont systemFontOfSize:12.0]
//                            textColor: UIColor.whiteColor
//                            insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
//                            xAxisValueFormatter: _chartView.xAxis.valueFormatter];
//    marker.chartView = _chartView;
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
//
//    _sliderX.value = 12.0;
//    _sliderY.value = 50.0;
 //   [self slidersValueChanged:nil];
}



- (void)updateChartData
{
//    if (self.shouldHideData)
//    {
//        _chartView.data = nil;
//        return;
//    }
    
  //  [self setDataCount:_sliderX.value + 1 range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{
    double start = 10.0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    if (self.ChartValuesArray.count) {
        for (int i = 0; i < self.ChartValuesArray.count; i++)
            {
                //        double mult = (range + 1);
                //        double val = (double) (arc4random_uniform(mult));
                //        if (arc4random_uniform(100) < 25) {
                //            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];
                //        } else {
                //            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
                //        }
            
            
            double val = [[[self.ChartValuesArray valueForKey:@"Values"]objectAtIndex:i] doubleValue];
            
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i*start y:val]];
            }
    }
    
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
        [set1 setColors:ChartColorTemplates.material];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 10.0f;
    
        _chartView.data = data;
    }
}

//- (void)optionTapped:(NSString *)key
//{
//    [super handleOption:key forChartView:_chartView];
//}

#pragma mark - Actions

//- (IBAction)slidersValueChanged:(id)sender
//{
//    _sliderTextX.text = [@((int)_sliderX.value + 2) stringValue];
//    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
//
//    [self updateChartData];
//}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

-(void) BattingWebservice
{
    
    if(![COMMON isInternetReachable])
    {
        return;
    }
    else if ([lblCompetetion.text isEqualToString:@"Competition Name"])
    {
        return;
    }
    else if([AppCommon isCoach] && [lblteam.text isEqualToString:@"Team Name"])
    {
        return;
    }

        
        [AppCommon showLoading];
        
        NSString *URLString =  URL_FOR_RESOURCE(teamBattingKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *CompetitionCode = [AppCommon getCurrentCompetitionCode];
        NSString *TeamCode = [AppCommon getCurrentTeamCode];
    
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(CompetitionCode)   [dic    setObject:CompetitionCode     forKey:@"CompetitionCode"];
        if(TeamCode)   [dic    setObject:TeamCode     forKey:@"TeamCode"];
        if(innNum)   [dic    setObject:innNum     forKey:@"InningsNum"];
        if(Result)   [dic    setObject:Result     forKey:@"Result"];
        if(types)   [dic    setObject:types     forKey:@"Types"];
        
        
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                self.ChartValuesArray = [[NSMutableArray alloc]init];
                self.TableValuesArray = [[NSMutableArray alloc]init];
                
                self.ChartValuesArray = [responseObject valueForKey:@"bCharList"];
                self.TableValuesArray = [responseObject valueForKey:@"plyrBattingList"];
                
                self.ChartXAxisValuesArray = [[NSMutableArray alloc]init];
            
                if (self.ChartValuesArray.count) {
                    for(int i=0;i<self.ChartValuesArray.count;i++)
                        {
                        NSString * value = [[self.ChartValuesArray valueForKey:@"PlayerName"] objectAtIndex:i];
                        [self.ChartXAxisValuesArray addObject:value];
                        }
                    
                    [self barchartloadValues];
                    [self.resultCollectionView reloadData];
                    
                }
                
                
                [self barchartloadValues];
                [self RunsSorting];
//                [self.resultCollectionView reloadData];
            }
            
            [AppCommon hideLoading];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
            
        }];
    
}

//-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
//{
//    NSLog(@"%@",array[Index.row]);
//    NSLog(@"selected value %@",key);
//    lblCompetetion.text = [[array objectAtIndex:Index.row] valueForKey:key];
//    NSString* Competetioncode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
//
//    [[NSUserDefaults standardUserDefaults] setValue:lblCompetetion.text forKey:@"SelectedCompetitionName"];
//    [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    [self BattingWebservice];
//
//}

-(void)RunsSorting
{
    NSLog(@"SORTING ORDER %ld",runSortingKey);
    
    NSArray* sortedArray = [self.TableValuesArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"Runs" ascending:runSortingKey selector:@selector(localizedStandardCompare:)]]];
    
    if (sortedArray.count > 0) {
        runSortingKey = !runSortingKey;
        self.TableValuesArray = [[NSMutableArray alloc]init];
        [self.TableValuesArray addObjectsFromArray:sortedArray];
        
        [self.resultCollectionView reloadData];
        
    }
}

- (IBAction)actionDropDowns:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    if ([sender tag] == 0) { // OverAll
        
        NSArray* arr = @[@{@"overall":@"Overall",
                           @"inns":@"",
                           @"result":@""},
                         @{@"overall":@"Batting 1st",
                           @"inns":@"1",
                           @"result":@""},
                         @{@"overall":@"Batting 2nd",
                           @"inns":@"2",
                           @"result":@""},
                         @{@"overall":@"Batting 1st Won",
                           @"inns":@"1"
                           ,@"result":@"won"},
                         @{@"overall":@"Batting 2nd Won",
                           @"inns":@"2"
                           ,@"result":@"won"},
                         @{@"overall":@"Batting 1st Lost",
                           @"inns":@"1"
                           ,@"result":@"loss"},
                         @{@"overall":@"Batting 2nd Lost",
                           @"inns":@"2",@"result":@"loss"}];


        dropVC.array = arr;
        dropVC.key = @"overall";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(overallView.frame), CGRectGetMaxY(overallView.superview.frame)+60+50, CGRectGetWidth(overallView.frame), 300)];

    }
    else if ([sender tag] == 1) // Runs
    {
        
        NSArray* arr = @[@{@"Runs":@"Runs"
                           ,@"types":@"runs"},
                         @{@"Runs":@"Strike Rate",
                           @"types":@"sr"},
                         @{@"Runs":@"Average",
                            @"types":@"avg"}];
        
        dropVC.array = arr;
        dropVC.key = @"Runs";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(runsView.frame), CGRectGetMaxY(runsView.superview.frame)+60+50, CGRectGetWidth(runsView.frame), 300)];
        
    }
    else if ([sender tag] == 2) // Competitions
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(CompetitionView.frame), CGRectGetMaxY(CompetitionView.superview.frame)+60+50, CGRectGetWidth(CompetitionView.frame), 300)];

    }
    else if ([sender tag] == 3) // Teams
    {
        dropVC.array = [COMMON getCorrespondingTeamName:lblCompetetion.text];
        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(teamView.frame), CGRectGetMaxY(teamView.superview.frame)+60+50, CGRectGetWidth(teamView.frame), 300)];

    }
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];

}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        NSLog(@"%@",array[Index.row]);
        NSLog(@"selected value %@",key);
        lblCompetetion.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Competetioncode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        lblteam.text = @"Team Name";
        
    }
    else if([key isEqualToString:@"TeamName"])
    {
        lblteam.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Teamcode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:lblteam.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:Teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if([key isEqualToString:@"overall"])
    {
        overViewlbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        Result = [[array objectAtIndex:Index.row] valueForKey:@"result"];
        innNum = [[array objectAtIndex:Index.row] valueForKey:@"inns"];
        
    }
    else if([key isEqualToString:@"Runs"])
    {
        runslbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        types = [[array objectAtIndex:Index.row] valueForKey:@"types"];
    }
    
    [self BattingWebservice];
    
    
}

@end
