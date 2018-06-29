//
//  InjuryVC.h
//  APT_V2
//
//  Created by Mac on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface InjuryVC : UIViewController

@property (strong, nonatomic) IBOutlet StepSlider *Slider1;
@property (nonatomic,strong)NSMutableArray  * InjuryListArray;
@property (nonatomic,weak) IBOutlet UITextField * compliant_Txt;
@property (nonatomic,weak) IBOutlet UITextField * comfirmatory_Txt;
@property (nonatomic,weak) IBOutlet UITextField * diagnosis_Txt;
@property (nonatomic,weak) IBOutlet UIButton * delay_Btn;
@property (nonatomic,weak) IBOutlet UIButton * tur_Btn;
@property (nonatomic,weak) IBOutlet UIButton * right_Btn;
@property (nonatomic,weak) IBOutlet UIButton * left_Btn;
@property (nonatomic,weak) IBOutlet UIButton * expectedright_Btn;
@property (nonatomic,weak) IBOutlet UIButton * expectedLeft_Btn;
@property (nonatomic,weak) IBOutlet UILabel * date_lbl;
@property (nonatomic,weak) IBOutlet UIView * navigation_view;
@property (nonatomic,weak) IBOutlet UITableView * pop_Tbl;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint * popviewYposition;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint * popviewXposition;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint * popviewWidth;

@property (nonatomic,weak) IBOutlet UIView * occurrence_view;
@property (nonatomic,weak) IBOutlet UIView * location_view;
@property (nonatomic,weak) IBOutlet UIView * site_view;
@property (nonatomic,weak) IBOutlet UIView * type_view;
@property (nonatomic,weak) IBOutlet UIView * casuse_view;
@property (strong, nonatomic) IBOutlet UIView *fileView;
@property (weak, nonatomic) IBOutlet UIView *filepopview;

@property (nonatomic,weak) IBOutlet UIButton * selectFile;
@property (nonatomic,strong) NSMutableArray * commonArray;
@property (nonatomic,strong) NSMutableArray * MainArray;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *occurancelbl;
@property (weak, nonatomic) IBOutlet UILabel *locationlbl;
@property (weak, nonatomic) IBOutlet UILabel *sitelbl;
@property (weak, nonatomic) IBOutlet UILabel *typelbl;
@property (weak, nonatomic) IBOutlet UILabel *causelbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgFile1;
@property (nonatomic,assign)  BOOL isUpdate;

@property (nonatomic,strong) IBOutlet UIButton * occurranceBtn;

@property (nonatomic,strong) IBOutlet UIView * locationselectview;

@property (nonatomic,strong) IBOutlet UIView * TypeAndCaseView;
@property (weak, nonatomic) IBOutlet UIButton *btnF1;
@property (weak, nonatomic) IBOutlet UIButton *btnF2;
@property (weak, nonatomic) IBOutlet UIButton *btnF3;
@property (weak, nonatomic) IBOutlet UIButton *btnF4;
@property (strong, atomic) NSString*  TeamCode;
@property (weak, nonatomic) IBOutlet UIButton *btnAssment;
@property (weak, nonatomic) IBOutlet UIButton *btnOnsetDate;
@property (weak, nonatomic) IBOutlet UITextField *txtInjuryName;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@end
