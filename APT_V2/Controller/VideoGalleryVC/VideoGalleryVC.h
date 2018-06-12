//
//  VideoGalleryVC.h
//  APT_V2
//
//  Created by Apple on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoGalleryVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionview1;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionview2;
@property (nonatomic,strong) IBOutlet UIView * headerView;

@property (nonatomic,strong) IBOutlet UIButton * clearBtn;
@property (nonatomic,strong) IBOutlet UIImageView * CancelTextImg;

@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
- (IBAction)showFilter:(id)sender;
- (IBAction)actionFilterVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dropdownView;
@property (weak, nonatomic) IBOutlet UIButton *btnTeam;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnType;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;

@property (strong, nonatomic) IBOutlet UILabel *lblTeam;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblcategory;

@property (weak, nonatomic) IBOutlet UIView *tableMainView;
@property (weak, nonatomic) IBOutlet UITableView *tbl_list;
@property (weak, nonatomic) IBOutlet UILabel *lblNovideo;

@property (strong, nonatomic) IBOutlet UITextField *dateTF;
@property (strong, nonatomic)  NSString *isBack;

@end
