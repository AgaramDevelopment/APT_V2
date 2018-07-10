//
//  ExcersizeDetailItemVC.m
//  AlphaProTracker
//
//  Created by MAC on 19/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import "ExcersizeDetailItemVC.h"
#import "PageItemController.h"
#import "AppCommon.h"
#import "WebService.h"

@interface ExcersizeDetailItemVC ()

@end

@implementation ExcersizeDetailItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createPageViewController];
    //    [self setupPageControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPageViewController
{
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    
    pageController.dataSource = self;
    pageController.delegate = self;
    if([_contentImages count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex:self.indexPath]];
        [pageController setViewControllers:startingViewControllers
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
        self.indexPath = self.indexPath+1;
        NSString *contentString = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.indexPath, (unsigned long)[_contentImages count]];
        self.contentLabel.text = contentString;
    }
    
    self.pageViewController = pageController;
    [self addChildViewController:self.pageViewController];
    [[self.pageViewController view] setFrame:[[self containerView] bounds]];
    [self.containerView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor blackColor]];
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PageItemController *itemController = (PageItemController *)viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex:itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PageItemController *itemController = (PageItemController *)viewController;
    
    if (itemController.itemIndex+1 < [_contentImages count])
    {
        return [self itemControllerForIndex:itemController.itemIndex+1];
    }
    return nil;
}

- (PageItemController *)itemControllerForIndex:(NSUInteger)itemIndex
{
    if (itemIndex < [_contentImages count])
    {
        PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemController"];
        pageItemController.itemIndex = itemIndex;
        
        NSMutableDictionary *dict = [_contentImages objectAtIndex:itemIndex];
        NSString *stringURL = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"FilePath"]];
        
        pageItemController.currentURL = stringURL;
        pageItemController.currentImage = self.isImage;
        pageItemController.currentVideo = self.isVideo;
        pageItemController.currentPDF = self.isPDF;
        return pageItemController;
    }
    return nil;
}

- (void)viewControllerItemsCount:(NSUInteger)count currentItemIndex:(NSUInteger)index
{
    NSLog(@"currentItemIndex: %ld", index);
    //Current Image Number / No.of Images Count
    NSString *contentString = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index, (unsigned long)count];
    self.contentLabel.text = contentString;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    PageItemController* controller = pendingViewControllers[0];
    NSInteger index = [controller itemIndex];
    [controller.avPlayer play];
    //    NSInteger nextIndex = [self indexOfViewController:controller];
    NSLog(@"nextIndex:%ld", index);
    
    NSString *contentString = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index+1, (unsigned long)[_contentImages count]];
    self.contentLabel.text = contentString;
}
- (IBAction)closeButtonAction:(id)sender {
    
    PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemController"];
    [pageItemController.avPlayer seekToTime:CMTimeMake(0, 1)];
    [pageItemController.avPlayer pause];
    [pageItemController.avPlayerViewController.view removeFromSuperview];
    pageItemController.avPlayer = NULL;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        PageItemController * viewController = [previousViewControllers lastObject];
        
        [viewController.avPlayer seekToTime:CMTimeMake(0, 1)];
        [viewController.avPlayer pause];
        //        [viewController.avPlayerViewController.view removeFromSuperview];
        //        viewController.avPlayer = NULL;
    }
}

#pragma mark Page Indicator
/*
 - (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
 {
 return [_contentImages count];
 }
 
 - (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
 {
 return 0;
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

@end

