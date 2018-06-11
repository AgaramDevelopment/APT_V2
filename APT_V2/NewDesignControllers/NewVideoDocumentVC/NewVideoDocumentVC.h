//
//  NewVideoDocumentVC.h
//  APT_V2
//
//  Created by MAC on 08/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVideoDocumentVC : UIViewController

@property (nonatomic,strong) IBOutlet UIView * headerView;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UILabel *lblcategory;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UITextField *dateTF;
@property (nonatomic,strong) IBOutlet UITextField * search_Txt;
@property (weak, nonatomic) IBOutlet UITableView *tbl_list;
@property (weak, nonatomic) IBOutlet UIView *tableMainView;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionview1;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionview2;
@property (weak, nonatomic) IBOutlet UILabel *lblNovideo;

//PDF properties
@property (strong, nonatomic) IBOutlet UIViewController *pdfView;
@property (weak, nonatomic) IBOutlet UIWebView *docWebview;
@end
