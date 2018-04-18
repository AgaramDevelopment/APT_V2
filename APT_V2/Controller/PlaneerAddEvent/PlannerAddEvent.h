//
//  PlannerAddEvent.h
//  AlphaProTracker
//
//  Created by Mac on 28/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddParticipantCell.h"

@interface PlannerAddEvent : UIViewController

@property (nonatomic,strong) IBOutlet AddParticipantCell * participantCell;

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,strong) NSString * selectDateStr;

@property (nonatomic,strong) NSMutableArray * ListeventTypeArray;

@property (nonatomic,strong) NSMutableArray * ListeventStatusArray;

@property (nonatomic,strong) NSMutableArray * ListparticipantTypeArray;

@property (nonatomic,strong) NSMutableArray * TeamArray;

@property (strong,nonatomic) IBOutlet UIView * view_datepicker;

@property (nonatomic,strong) NSDictionary * objSelectEditDic;

@property (strong, nonatomic) IBOutlet UIView *navi_View;

@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *isNotification;

@end
