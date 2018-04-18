//
//  OverviewView.m
//  APT_V2
//
//  Created by apple on 23/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "OverviewBowlingView.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"

@implementation OverviewBowlingView

@synthesize lblCompetetion,overViewlbl,runslbl,teamlbl;

@synthesize competView,teamView,barView,lineView;

BOOL isBowlXAxis;
BOOL isBowlYAxis;
BOOL isCompetition;
BOOL isteems;
NSMutableArray *bowlMonths;

/* ----------------------------------Filter----------------------------------------- */


#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(isBowlXAxis==YES)
    {
        return 7;
    }
    else if(isBowlYAxis==YES)
    {
        return 7;
        
    }
    else if(isCompetition ==YES)
    {
        return appDel.ArrayCompetition.count;
    }
    else if(isteems == YES)
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
    
    if(isBowlXAxis==YES)
    {
        cell.textLabel.text = indexPath.row == 0 ? @"Runs" : indexPath.row == 1 ? @"Wickets" : indexPath.row == 2 ? @"Strike Rate" :  indexPath.row == 3 ? @"Runs per over" :  indexPath.row == 4 ? @"Average" :  indexPath.row == 5 ? @"Dot balls %" :  @"Boundaries %";
    }
    else if(isBowlYAxis==YES)
    {
        cell.textLabel.text = indexPath.row == 0 ? @"Runs" : indexPath.row == 1 ? @"Wickets" : indexPath.row == 2 ? @"Strike Rate" :  indexPath.row == 3 ? @"Runs per over" :  indexPath.row == 4 ? @"Average" :  indexPath.row == 5 ? @"Dot balls %" :  @"Boundaries %";
        
    }
    
    else if(isCompetition ==YES)
    {
        cell.textLabel.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
    }
    else if(isteems == YES)
    {
        cell.textLabel.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        
    }
    
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isBowlXAxis==YES)
    {
      
        
        self.overViewlbl.text  = indexPath.row == 0 ? @"Runs" : indexPath.row == 1 ? @"Wickets" : indexPath.row == 2 ? @"Strike Rate" :  indexPath.row == 3 ? @"Runs per over" :  indexPath.row == 4 ? @"Average" :  indexPath.row == 5 ? @"Dot balls %" :  @"Boundaries %";
        
        
        if(indexPath.row == 0)
        {
            Barvalue = @"RUNS";
        }
        else if(indexPath.row == 1)
        {
            Barvalue = @"WICKETS";
        }
        else if(indexPath.row == 2)
        {
            Barvalue = @"STRIKERATE";
        }
        else if(indexPath.row == 3)
        {
            Barvalue = @"RUNSPEROVER";
        }
        else if(indexPath.row == 4)
        {
            Barvalue = @"AVERAGE";
        }
        else if(indexPath.row == 5)
        {
            Barvalue = @"DOTBALLPER";
        }
        else if(indexPath.row == 6)
        {
            Barvalue = @"BOUNDARIESPER";
        }
    }else if(isBowlYAxis==YES)
    {
        self.runslbl.text  = indexPath.row == 0 ? @"Runs" : indexPath.row == 1 ? @"Wickets" : indexPath.row == 2 ? @"Strick Rate" :  indexPath.row == 3 ? @"Runs per over" :  indexPath.row == 4 ? @"Average" :  indexPath.row == 5 ? @"Dot balls %" :  @"Boundaries %";
        
        if(indexPath.row == 0)
        {
            linevalue = @"RUNS";
        }
        else if(indexPath.row == 1)
        {
            linevalue = @"WICKETS";
        }
        else if(indexPath.row == 2)
        {
            linevalue = @"STRIKERATE";
        }
        else if(indexPath.row == 3)
        {
            linevalue = @"RUNSPEROVER";
        }
        else if(indexPath.row == 4)
        {
            linevalue = @"AVERAGE";
        }
        else if(indexPath.row == 5)
        {
            linevalue = @"DOTBALLPER";
        }
        else if(indexPath.row == 6)
        {
            linevalue = @"BOUNDARIESPER";
        }
    }
    
    else if(isCompetition == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
        
        self.lblCompetetion.text = [self checkNull:[[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"]];
        NSString* Competetioncode = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(isteems == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
        
        self.teamlbl.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        NSString* teamcode = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
        [[NSUserDefaults standardUserDefaults] setValue:self.teamlbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    isBowlXAxis = NO;
    isBowlYAxis = NO;
    isCompetition = NO;
    isteems = NO;
    self.PoplistTable.hidden = YES;
    [self ChartsWebservice];
}

- (IBAction)onClickOverViewDD:(id)sender
{
    
    if(isBowlXAxis){
        
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isCompetition = NO;
        isteems =NO;
        self.PoplistTable.hidden = YES;
        
        
    }else{
        
        isBowlXAxis = YES;
        isBowlYAxis = NO;
        isCompetition = NO;
        isteems =NO;
        
        self.PoplistTable.hidden = NO;
        
        self.tableWidth.constant = self.barView.frame.size.width;
        self.tableXposition.constant = self.barView.frame.origin.x;
        
        [self.PoplistTable reloadData];
        
    }
}

- (IBAction)onClickRunsDD:(id)sender
{
    if(isBowlYAxis){
        
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isCompetition = NO;
        isteems =NO;
        self.PoplistTable.hidden = YES;
        
        
    }else{
        isBowlXAxis = NO;
        isBowlYAxis = YES;
        isCompetition = NO;
        self.PoplistTable.hidden = NO;
        self.tableWidth.constant = self.lineView.frame.size.width;
        self.tableXposition.constant = self.lineView.frame.origin.x;
        
        [self.PoplistTable reloadData];
       
    }
}

- (IBAction)onClickCompetition:(id)sender
{
    if(isCompetition){
        
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isteems =NO;
        isCompetition = NO;
        self.PoplistTable.hidden = YES;
        
        
    }else{
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isCompetition = YES;
        isteems =NO;
        self.PoplistTable.hidden = NO;
        //self.tableWidth.constant = 142;
        //self.tableXposition.constant = self.filterView.frame.origin.x+8+142+16;
        
        self.tableWidth.constant = self.competView.frame.size.width;
        self.tableXposition.constant = self.competView.frame.origin.x;
        self.tableYposition.constant = self.competView.frame.origin.y;
        
        [self.PoplistTable reloadData];
        
    }
}

- (IBAction)onClickTeam:(id)sender
{
    if(isteems){
        
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isCompetition = NO;
        isteems = NO;
        self.PoplistTable.hidden = YES;
        
        
    }else{
        isBowlXAxis = NO;
        isBowlYAxis = NO;
        isCompetition = NO;
        isteems = YES;
        self.PoplistTable.hidden = NO;
        //self.tableWidth.constant = 142;
        //self.tableXposition.constant = self.filterView.frame.origin.x+8+142+16;
        
        self.tableWidth.constant = self.teamView.frame.size.width;
        self.tableXposition.constant = self.teamView.frame.origin.x;
        self.tableYposition.constant = self.teamView.frame.origin.y;
        
        [self.PoplistTable reloadData];
        
    }
}

/*  ---------------------------------------------------------Chart --------------------------------------- */
-(void) loadChart{
    
    
    
    
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
    
    self.PoplistTable.delegate = self;
    self.PoplistTable.dataSource = self;
    
    Barvalue = @"RUNS";
    linevalue = @"RUNS";
    
    bowlMonths = [[NSMutableArray alloc]init];

       bowlMonths = @[
                   @"Match1", @"Match2", @"Match3",
                   @"Match4", @"Match5"
                   ];
    
    runslbl.text = @"RUNS";
    [self ChartsWebservice];
    
//    [self chartPP1];
//    [self chartPP2];
//    [self chartPP3];
    
}
/*  ---------------------------------------------------------Chart PP1--------------------------------------- */
-(void) chartPP1
{
    
    
    if(self.lineValuesArray1.count<self.BarValuesArray1.count)
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.BarValuesArray1.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    else
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.lineValuesArray1.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    
    self.barChartPP1.delegate = self;
    
    self.barChartPP1.chartDescription.enabled = NO;
    
    self.barChartPP1.drawGridBackgroundEnabled = NO;
    self.barChartPP1.drawBarShadowEnabled = NO;
    self.barChartPP1.highlightFullBarEnabled = NO;
    
    self.barChartPP1.drawOrder = @[
                             @(CombinedChartDrawOrderBar),
                             @(CombinedChartDrawOrderBubble),
                             @(CombinedChartDrawOrderCandle),
                             @(CombinedChartDrawOrderLine),
                             @(CombinedChartDrawOrderScatter)
                             ];
    
    ChartLegend *l = self.barChartPP1.legend;
    l.wordWrapEnabled = YES;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartYAxis *rightAxis = self.barChartPP1.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *leftAxis = self.barChartPP1.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartXAxis *xAxis = self.barChartPP1.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBothSided;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    
    //Center X-Label
    xAxis.granularityEnabled = true;
    xAxis.centerAxisLabelsEnabled = true;
    
    [self setChartData];

}



- (void)setChartData
{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.barData = [self generateBarData];
    data.lineData = [self generateLineData];
    //data.bubbleData = [self generateBubbleData];
    //data.scatterData = [self generateScatterData];
    //data.candleData = [self generateCandleData];
    
    self.barChartPP1.xAxis.axisMaximum = data.xMax + 0.25;
    
    self.barChartPP1.data = data;
}


- (LineChartData *)generateLineData
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    
    for (int index = 0; index < self.lineValuesArray1.count; index++)
    {
        //[entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(65) + 5)]];
        
        float value = [[self.lineValuesArray1 objectAtIndex:index] floatValue];
        
        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:value]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:self.runslbl.text];
    [set setColor:[UIColor colorWithRed:240/255.f green:0/255.f blue:0/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:240/255.f green:0/255.f blue:0/255.f alpha:1.f]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor colorWithRed:240/255.f green:0/255.f blue:0/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:0/255.f blue:0/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData
{
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *entries2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < self.BarValuesArray1.count; index++)
    {
        // [entries1 addObject:[[BarChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(15) + 5)]];
        
        
        float value = [[self.BarValuesArray1 objectAtIndex:index] floatValue];
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:value]];
        
        // stacked
        
        //[entries2 addObject:[[BarChartDataEntry alloc] initWithX:0.0 yValues:@[@(arc4random_uniform(13) + 12), @(arc4random_uniform(13) + 12)]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:self.overViewlbl.text];
    [set1 setColor:[UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f]];
    set1.valueTextColor = [UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f];
    set1.valueFont = [UIFont systemFontOfSize:10.f];
    set1.axisDependency = AxisDependencyRight;
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@""];
    set2.stackLabels = @[@"Stack 1", @"Stack 2"];
    set2.colors = @[
                    [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f],
                    [UIColor colorWithRed:23/255.f green:197/255.f blue:255/255.f alpha:1.f]
                    ];
    set2.valueTextColor = [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f];
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.axisDependency = AxisDependencyRight;
    
    float groupSpace = 0.06f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    
    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[set1,set2]];
    d.barWidth = barWidth;
    
    // make this BarData object grouped
    [d groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace]; // start at x = 0
    
    return d;
}



#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return bowlMonths[(int)value % bowlMonths.count];
}








/*  ---------------------------------------------------------Chart PP2--------------------------------------- */

-(void) chartPP2
{
    
    if(self.lineValuesArray2.count<self.BarValuesArray2.count)
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.BarValuesArray2.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    else
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.lineValuesArray2.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    
   
    
    
    self.barChartPP2.delegate = self;
    
    self.barChartPP2.chartDescription.enabled = NO;
    
    self.barChartPP2.drawGridBackgroundEnabled = NO;
    self.barChartPP2.drawBarShadowEnabled = NO;
    self.barChartPP2.highlightFullBarEnabled = NO;
    
    self.barChartPP2.drawOrder = @[
                                   @(CombinedChartDrawOrderBar),
                                   @(CombinedChartDrawOrderBubble),
                                   @(CombinedChartDrawOrderCandle),
                                   @(CombinedChartDrawOrderLine),
                                   @(CombinedChartDrawOrderScatter)
                                   ];
    
    ChartLegend *l = self.barChartPP2.legend;
    l.wordWrapEnabled = YES;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartYAxis *rightAxis = self.barChartPP2.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *leftAxis = self.barChartPP2.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartXAxis *xAxis = self.barChartPP2.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBothSided;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    
    //Center X-Label
    xAxis.granularityEnabled = true;
    xAxis.centerAxisLabelsEnabled = true;
    
    [self setChartData2];
    
}



- (void)setChartData2
{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.barData = [self generateBarData2];
    data.lineData = [self generateLineData2];
    //data.bubbleData = [self generateBubbleData];
    //data.scatterData = [self generateScatterData];
    //data.candleData = [self generateCandleData];
    
    self.barChartPP2.xAxis.axisMaximum = data.xMax + 0.25;
    
    self.barChartPP2.data = data;
}



- (LineChartData *)generateLineData2
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    
    for (int index = 0; index < self.lineValuesArray2.count; index++)
    {
        //[entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(35) + 5)]];
        
        float value = [[self.lineValuesArray2 objectAtIndex:index] floatValue];
        
        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:value]];
    }
    
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:self.runslbl.text];
    [set setColor:[UIColor colorWithRed:0/255.f green:255/255.f blue:255/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:0/255.f green:255/255.f blue:255/255.f alpha:1.f]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor colorWithRed:0/255.f green:255/255.f blue:255/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:0/255.f green:255/255.f blue:255/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData2
{
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *entries2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < self.BarValuesArray2.count; index++)
    {
        //[entries1 addObject:[[BarChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(45) + 5)]];
        
        
        float value = [[self.BarValuesArray2 objectAtIndex:index] floatValue];
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:value]];
        //
        // stacked
        
        //[entries2 addObject:[[BarChartDataEntry alloc] initWithX:0.0 yValues:@[@(arc4random_uniform(13) + 12), @(arc4random_uniform(13) + 12)]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:self.overViewlbl.text];
    [set1 setColor:[UIColor colorWithRed:255/255.f green:128/255.f blue:0/255.f alpha:1.f]];
    set1.valueTextColor = [UIColor colorWithRed:255/255.f green:128/255.f blue:0/255.f alpha:1.f];
    set1.valueFont = [UIFont systemFontOfSize:10.f];
    set1.axisDependency = AxisDependencyRight;
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@""];
    set2.stackLabels = @[@"Stack 1", @"Stack 2"];
    set2.colors = @[
                    [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f],
                    [UIColor colorWithRed:23/255.f green:197/255.f blue:255/255.f alpha:1.f]
                    ];
    set2.valueTextColor = [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f];
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.axisDependency = AxisDependencyRight;
    
    float groupSpace = 0.06f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    
    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[set1,set2]];
    d.barWidth = barWidth;
    
    // make this BarData object grouped
    [d groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace]; // start at x = 0
    
    return d;
}




/*  ---------------------------------------------------------Chart PP3--------------------------------------- */

-(void) chartPP3
{
    
    if(self.lineValuesArray3.count<self.BarValuesArray3.count)
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.BarValuesArray3.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    else
    {
        bowlMonths = [[NSMutableArray alloc]init];
        for(int i=0;i<self.lineValuesArray3.count;i++)
        {
            NSString *value = [NSString stringWithFormat:@"Match%d",i+1];
            [bowlMonths addObject:value];
        }
    }
    
    self.barChartPP3.delegate = self;
    
    self.barChartPP3.chartDescription.enabled = NO;
    
    self.barChartPP3.drawGridBackgroundEnabled = NO;
    self.barChartPP3.drawBarShadowEnabled = NO;
    self.barChartPP3.highlightFullBarEnabled = NO;
    
    self.barChartPP3.drawOrder = @[
                                   @(CombinedChartDrawOrderBar),
                                   @(CombinedChartDrawOrderBubble),
                                   @(CombinedChartDrawOrderCandle),
                                   @(CombinedChartDrawOrderLine),
                                   @(CombinedChartDrawOrderScatter)
                                   ];
    
    ChartLegend *l = self.barChartPP3.legend;
    l.wordWrapEnabled = YES;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartYAxis *rightAxis = self.barChartPP3.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *leftAxis = self.barChartPP3.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartXAxis *xAxis = self.barChartPP3.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBothSided;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    
    //Center X-Label
    xAxis.granularityEnabled = true;
    xAxis.centerAxisLabelsEnabled = true;
    
    [self setChartData3];
    
}



- (void)setChartData3
{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.barData = [self generateBarData3];
    data.lineData = [self generateLineData3];

    //data.bubbleData = [self generateBubbleData];
    //data.scatterData = [self generateScatterData];
    //data.candleData = [self generateCandleData];
    
    self.barChartPP3.xAxis.axisMaximum = data.xMax + 0.25;
    
    self.barChartPP3.data = data;
}



- (LineChartData *)generateLineData3
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    
    for (int index = 0; index < self.lineValuesArray3.count; index++)
    {
        // [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(135) + 5)]];
        
        float value = [[self.lineValuesArray3 objectAtIndex:index] floatValue];
        
        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:value]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:self.runslbl.text];
    [set setColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:255/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:255/255.f alpha:1.f]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:255/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:255/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData3
{
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *entries2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index <self.BarValuesArray3.count; index++)
    {
        //[entries1 addObject:[[BarChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(85) + 5)]];
        
        
        float value = [[self.BarValuesArray3 objectAtIndex:index] floatValue];
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:value]];
        //
        // stacked
        
        //[entries2 addObject:[[BarChartDataEntry alloc] initWithX:0.0 yValues:@[@(arc4random_uniform(13) + 12), @(arc4random_uniform(13) + 12)]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:self.overViewlbl.text];
    [set1 setColor:[UIColor colorWithRed:255/255.f green:51/255.f blue:153/255.f alpha:1.f]];
    set1.valueTextColor = [UIColor colorWithRed:255/255.f green:51/255.f blue:153/255.f alpha:1.f];
    set1.valueFont = [UIFont systemFontOfSize:10.f];
    set1.axisDependency = AxisDependencyRight;
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@""];
    set2.stackLabels = @[@"Stack 1", @"Stack 2"];
    set2.colors = @[
                    [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f],
                    [UIColor colorWithRed:23/255.f green:197/255.f blue:255/255.f alpha:1.f]
                    ];
    set2.valueTextColor = [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f];
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.axisDependency = AxisDependencyRight;
    
    float groupSpace = 0.06f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    
    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[set1,set2]];
    d.barWidth = barWidth;
    
    // make this BarData object grouped
    [d groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace]; // start at x = 0
    
    return d;
}

-(void)ChartsWebservice
{
    if(![COMMON isInternetReachable])
    {
        return;
    }
    if ([lblCompetetion.text isEqualToString:@"Competetion Name"]) {
        
        return;
    }
    else if([AppCommon isCoach] && [teamlbl.text isEqualToString:@"Team Name"])
    {
        return;
    }

        [AppCommon showLoading];

        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",bowlingOverViewkKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *COMPETITIONCODE = [AppCommon getCurrentCompetitionCode];
        NSString *TEAMCODE = [AppCommon getCurrentTeamCode];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(COMPETITIONCODE)   [dic    setObject:COMPETITIONCODE    forKey:@"COMPETITIONCODE"];
        if(TEAMCODE)   [dic    setObject:TEAMCODE    forKey:@"TEAMCODE"];
        if(Barvalue)   [dic    setObject:Barvalue    forKey:@"BARTYPE"];
        if(linevalue)   [dic    setObject:linevalue    forKey:@"LINETYPE"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                
                self.lineValuesArray1 = [[NSMutableArray alloc]init];
                self.lineValuesArray2 = [[NSMutableArray alloc]init];
                self.lineValuesArray3 = [[NSMutableArray alloc]init];
                
                self.BarValuesArray1 = [[NSMutableArray alloc]init];
                self.BarValuesArray2 = [[NSMutableArray alloc]init];
                self.BarValuesArray3 = [[NSMutableArray alloc]init];
                
                //line values
                NSMutableArray *lineArray1 = [[NSMutableArray alloc]init];
                lineArray1 = [responseObject valueForKey:@"LineOverBlockOne"];
                for(int i=0;i<lineArray1.count;i++)
                {
                    NSString *value = [[lineArray1 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.lineValuesArray1 addObject:value];
                }
                
                
                NSMutableArray *lineArray2 = [[NSMutableArray alloc]init];
                lineArray2 = [responseObject valueForKey:@"LineOverBlockTwo"];
                for(int i=0;i<lineArray2.count;i++)
                {
                    NSString *value = [[lineArray2 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.lineValuesArray2 addObject:value];
                }
                
                
                NSMutableArray *lineArray3 = [[NSMutableArray alloc]init];
                lineArray3 = [responseObject valueForKey:@"LineOverBlockThree"];
                for(int i=0;i<lineArray3.count;i++)
                {
                    NSString *value = [[lineArray3 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.lineValuesArray3 addObject:value];
                }
                
                
                //barvalues
                
                NSMutableArray *barArray1 = [[NSMutableArray alloc]init];
                barArray1 = [responseObject valueForKey:@"BarOverBlockOne"];
                for(int i=0;i<barArray1.count;i++)
                {
                    NSString *value = [[barArray1 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.BarValuesArray1 addObject:value];
                }
                
                NSMutableArray *barArray2 = [[NSMutableArray alloc]init];
                barArray2 = [responseObject valueForKey:@"BarOverBlockTwo"];
                for(int i=0;i<barArray2.count;i++)
                {
                    NSString *value = [[barArray2 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.BarValuesArray2 addObject:value];
                }
                
                NSMutableArray *barArray3 = [[NSMutableArray alloc]init];
                barArray3 = [responseObject valueForKey:@"BarOverBlockThree"];
                for(int i=0;i<barArray3.count;i++)
                {
                    NSString *value = [[barArray3 valueForKey:@"VALUE"]objectAtIndex:i];
                    [self.BarValuesArray3 addObject:value];
                }
                
                
                [self chartPP1];
                [self chartPP2];
                [self chartPP3];
            }
            
            
            
            [AppCommon hideLoading];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            
        }];
    
}


- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

- (IBAction)actionDropDowns:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    if ([sender tag] == 0) { // X Axis value
        
        NSArray* arr = @[@{@"Xvalue":@"RUNS"},
                         @{@"Xvalue":@"WICKETS"},
                         @{@"Xvalue":@"AVERAGE"},
                         @{@"Xvalue":@"STRIKERATE"},
                         @{@"Xvalue":@"RUNSPEROVER"},
                         @{@"Xvalue":@"DOTBALLPER"},
                         @{@"Xvalue":@"BOUNDARIESPER"}];
        
        
        dropVC.array = arr;
        dropVC.key = @"Xvalue";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(barView.frame), CGRectGetMaxY(barView.superview.frame)+60+50, CGRectGetWidth(barView.frame), 300)];
        
    }
    else if ([sender tag] == 1) // Y Axis value
    {
        
        NSArray* arr = @[@{@"Yvalue":@"RUNS"},
                         @{@"Yvalue":@"WICKETS"},
                         @{@"Yvalue":@"AVERAGE"},
                         @{@"Yvalue":@"STRIKERATE"},
                         @{@"Yvalue":@"RUNSPEROVER"},
                         @{@"Yvalue":@"DOTBALLPER"},
                         @{@"Yvalue":@"BOUNDARIESPER"}];

        
        dropVC.array = arr;
        dropVC.key = @"Yvalue";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(lineView.superview.frame)+60+50, CGRectGetWidth(lineView.frame), 300)];
        
    }
    else if ([sender tag] == 2) // Competitions
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(competView.frame), CGRectGetMaxY(competView.superview.frame)+60+50, CGRectGetWidth(competView.frame), 300)];
        
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
        
        teamlbl.text = @"Team Name";
        
    }
    else if([key isEqualToString:@"TeamName"])
    {
        teamlbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Teamcode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:teamlbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:Teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if([key isEqualToString:@"Xvalue"])
    {
        overViewlbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        
        
        
        
        if(Index.row == 0)
        {
            Barvalue = @"RUNS";
        }
        else if(Index.row == 1)
        {
            Barvalue = @"WICKETS";
        }
        else if(Index.row == 2)
        {
            Barvalue = @"AVERAGE";
        }
        else if(Index.row == 3)
        {
            Barvalue = @"STRIKERATE";
        }
        else if(Index.row == 4)
        {
            Barvalue = @"RUNSPEROVER";
        }
        else if(Index.row == 5)
        {
            Barvalue = @"DOTBALLPER";
        }
        else if( Index.row == 6)
        {
            Barvalue = @"BOUNDARIESPER";
        }
        
    }
    else if([key isEqualToString:@"Yvalue"])
    {
        runslbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        
        if(Index.row == 0)
        {
            linevalue = @"RUNS";
        }
        else if(Index.row == 1)
        {
            linevalue = @"WICKETS";
        }
        else if(Index.row == 2)
        {
            linevalue = @"AVERAGE";
        }
        else if(Index.row == 3)
        {
            linevalue = @"STRIKERATE";
        }
        else if(Index.row == 4)
        {
            linevalue = @"RUNSPEROVER";
        }
        else if(Index.row == 5)
        {
            linevalue = @"DOTBALLPER";
        }
        else if( Index.row == 6)
        {
            linevalue = @"BOUNDARIESPER";
        }
        
    }
    
    [self ChartsWebservice];
    
    
}


@end
