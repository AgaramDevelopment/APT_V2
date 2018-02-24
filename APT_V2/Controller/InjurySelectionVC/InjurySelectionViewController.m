//
//  InjurySelectionViewController.m
//  APT_V2
//
//  Created by user on 23/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "InjurySelectionViewController.h"
#import "Header.h"
#import "UIImage+GetPoints.h"

@interface InjurySelectionViewController ()
{
    CALayer *blueLayer;
    CALayer *redLayer;
    CALayer *yellowLayer;
    CALayer *greenLayer;
}

@end

@implementation InjurySelectionViewController
@synthesize lblVertical,imgFront;
@synthesize lbl1;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self customnavigationmethod];
    
    
//    CAShapeLayer* shape1= [CAShapeLayer new];
//    CGPoint p1 = CGPointMake(lbl1.frame.origin.x, lbl1.frame.origin.y);
//    CGPoint p2 = CGPointMake(lbl1.frame.origin.x+lbl1.frame.size.width, lbl1.frame.origin.y);
//    CGPoint p3 = CGPointMake(lbl1.frame.origin.x+lbl1.frame.size.width, lbl1.frame.origin.y+lbl1.frame.size.height);
//    CGPoint p4 = CGPointMake(lbl1.frame.origin.x, lbl1.frame.origin.y+lbl1.frame.size.height);
//    UIBezierPath* path1 = [UIBezierPath bezierPath];
//    [path1 moveToPoint:p1];
//    [path1 addLineToPoint:p2];
//    [path1 addLineToPoint:p3];
//    [path1 addLineToPoint:p4];
//    [path1 closePath];
//    UIImage
//
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:lbl1.frame];
//    [shape1 setPath:lbl1.layer.path];
    
//    let image = UIImage(named: "yourImage.png")
//    let pointsOfColor = image?.getPoints(displayP3Red: 204.0/255.0, green: 33.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    
//    UIImage* img = [UIImage imageNamed:@"shape1"];
    NSMutableArray* arr = [_imgTemp.image getPointsfromRGB:0.0 :0.0 :0.0 andAlpha:1.0];
    NSLog(@"%@",arr);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    for (NSValue* value in arr) {
        if (arr[0] == value) {
            [path moveToPoint:CGPointMake([value CGPointValue].x, [value CGPointValue].y)];
        }
     
        [path addLineToPoint:CGPointMake([value CGPointValue].x, [value CGPointValue].y)];
    }
    [path closePath];
    
    //    CALayer* layer1 = [CALayer new];
    //    layer1.accessibilityPath = trianglePath;
    //    layer1.backgroundColor = [UIColor greenColor].CGColor;
    //    [imgFront.layer addSublayer:layer1];
//    CALayer* cal1 = [CALayer layer];
//    cal1.accessibilityPath.CGPath = path.CGPath;
//    cal1.backgroundColor = [UIColor yellowColor].CGColor;
//    cal1.borderWidth = 10.0;
//    [self.view.layer addSublayer:cal1];
    
    CAShapeLayer* shape1 = [CAShapeLayer layer];
    shape1.path = path.CGPath;
    shape1.backgroundColor = [UIColor yellowColor].CGColor;
    shape1.borderWidth = 1.0;
    shape1.borderColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shape1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    blueLayer = [[CALayer alloc] init];
    blueLayer.frame = CGRectMake(100, 100, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.name = @"Blue";
//    [self.view.layer addSublayer:blueLayer];
    
    
//    blueLayer.accessibilityPath.bezierPath;
    redLayer = [[CALayer alloc] init];
    redLayer.frame = CGRectMake(200, 200, 100, 100);
    redLayer.backgroundColor = [UIColor redColor].CGColor;
    redLayer.name=@"Red";
//    [self.view.layer addSublayer:redLayer];
    
    yellowLayer = [[CALayer alloc] init];
    yellowLayer.frame = CGRectMake(300, 300, 100, 100);
    yellowLayer.backgroundColor = [UIColor yellowColor].CGColor;
    yellowLayer.name = @"Yellow";
//    [self.view.layer addSublayer:yellowLayer];
    
    greenLayer = [[CALayer alloc] init];
    greenLayer.frame = CGRectMake(400, 400, 100, 100);
    greenLayer.backgroundColor = [UIColor greenColor].CGColor;
    greenLayer.name=@"Green";
//    [self.view.layer addSublayer:greenLayer];
    
    
    /*
     
     var path = UIBezierPath()
     path.moveToPoint(CGPointMake(20, 30))
     path.addLineToPoint(CGPointMake(40, 30))
     
     // add as many coordinates you need...
     
     path.closePath()
     
     var layer = CAShapeLayer()
     layer.path = path.CGPath
     layer.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5).CGColor
     layer.hidden = true
     
     bodyImage.layer.addSublayer(layer)
     
     CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
     And set its path:
     
     [shapeView setPath:[self createPath].CGPath];
     Finally add it:
     
     [[self.view layer] addSublayer:shapeView];
     */
    
   
    
//    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
//    [trianglePath moveToPoint:lblVertical.frame.origin];
//    [trianglePath addLineToPoint:CGPointMake(lblVertical.frame.origin.x, lblVertical.frame.origin.y+20)];
//    [trianglePath addLineToPoint:CGPointMake(lblVertical.frame.origin.x-20, lblVertical.frame.origin.y+20)];
//    [trianglePath closePath];
//    CALayer* layer1 = [CALayer new];
//    layer1.accessibilityPath = trianglePath;
//    layer1.backgroundColor = [UIColor greenColor].CGColor;
//    [imgFront.layer addSublayer:layer1];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
}

//The next step is to use the UIViewController's inheritance from the UIResponder class to take advantage of the touchesEnded: method.
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
//    [super touchesBegan:touches withEvent:event];
//    [self.nextResponder touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self.view];
    CALayer *hitLayer = [self.view.layer hitTest:[self.view convertPoint:location fromView:nil]];
    
    [self displayInfo:hitLayer.name];
}

-(void)displayInfo:(NSString *)nameOfLayer
{
    NSLog(@"%@",nameOfLayer);
}


-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //    objCustomNavigation.btn_back.hidden =isBackEnable;
    //
    //    objCustomNavigation.menu_btn.hidden = objCustomNavigation.btn_back.isHidden;
    //    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)actionBack
{
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    
}

@end