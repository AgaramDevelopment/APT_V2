//
//  DropDownTableViewController.m
//  APT_V2
//
//  Created by user on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "DropDownTableViewController.h"
#import "Header.h"

@interface DropDownTableViewController ()
{
    BOOL IfNoData;
}

@end

@implementation DropDownTableViewController
@synthesize array,key;

@synthesize protocol;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    array = @[@"one",@"two",@"three"];
//    [self addshadow];
}

-(void)viewDidAppear:(BOOL)animated
{
//    UIPopoverPresentationController* poppresenter = [dropVC popoverPresentationController];
//    [poppresenter.containerView addSubview:dropVC.view];
//    poppresenter.sourceView = sender;
//    poppresenter.sourceRect = [sender bounds];
//    poppresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    poppresenter.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addshadow
{
    self.tblDropDown.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tblDropDown.layer.shadowOffset = CGSizeZero;
    self.tblDropDown.layer.shadowRadius = 2.0f;
    self.tblDropDown.layer.shadowOpacity = 1.0f;
    self.tblDropDown.layer.masksToBounds = NO;
    self.tblDropDown.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.tblDropDown.bounds cornerRadius:self.tblDropDown.layer.cornerRadius].CGPath;
    
//    self.Shadowview.layer.masksToBounds = NO;
//    self.Shadowview.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.Shadowview.layer.shadowOffset = CGSizeZero;
//    self.Shadowview.layer.shadowRadius = 10.0f;
//    self.Shadowview.layer.shadowOpacity = 1.0f;


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    if (array.count == 0) {
        IfNoData = YES;
        array = @[@{@"DATA":@"NO Data Found"}];
        key = @"DATA";
    }
    CGFloat height = 45 * 5;
    if (array.count < 5) {
        height = array.count * 45;
    }

    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width,height);

    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:26.0/255.0 blue:68.0/255.0 alpha:0.5];
    cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:(IS_IPAD ? 13.0 : 13.0 )];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[array objectAtIndex:indexPath.row] valueForKey:key];
    
//    if (indexPath.row % 2 == 0) {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [protocol selectedValue:[[array objectAtIndex:indexPath.row] valueForKey:key]andKey:key];
    if (!IfNoData) {
        [protocol selectedValue:array andKey:key andIndex:indexPath];
    }
    NSLog(@"Selected Name and code %@",[array objectAtIndex:indexPath.row]);

    [self close:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
