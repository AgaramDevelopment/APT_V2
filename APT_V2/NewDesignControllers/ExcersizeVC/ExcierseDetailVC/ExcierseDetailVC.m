//
//  ExcierseDetailVC.m
//  AlphaProTracker
//
//  Created by apple on 16/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import "ExcierseDetailVC.h"
#import "CustomNavigation.h"
#import "ExcerciseAttachmentCVC.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "ExcerciseParameterTVC.h"
#import "ExcersizeDetailItemVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ExcierseDetailVC ()

{
    NSString * cliendcode;
    NSString * userref;
    NSString * usercode;
    NSMutableArray *parameterArray;
    NSMutableArray *videoArray;
    NSMutableArray *documentArray;
    NSMutableArray *imageArray;
    NSMutableArray *paramActualArray;


}

@end

@implementation ExcierseDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self customnavigationmethod];
    
    [self.imageCView registerNib:[UINib nibWithNibName:@"ExcerciseAttachmentCVC" bundle:nil] forCellWithReuseIdentifier:@"attachmentCVC"];
    [self.docuCView registerNib:[UINib nibWithNibName:@"ExcerciseAttachmentCVC" bundle:nil] forCellWithReuseIdentifier:@"attachmentCVC"];
    [self.videoCView registerNib:[UINib nibWithNibName:@"ExcerciseAttachmentCVC" bundle:nil] forCellWithReuseIdentifier:@"attachmentCVC"];

//    self.ExcerciseCode =@"EXE0000005";
//    self.ProgramCode = @"PGM0000014";
//    self.OrderNo = @"1";

    usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    userref = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    
//    cliendcode = @"CLI0000001";
//    usercode = @"USM0000012";
//    userref = @"AMR0000011";
    self.paramTView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
   // [self exerciseDetailWebservice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Excercise";
    objCustomNavigation.btn_back.hidden = NO;
    objCustomNavigation.home_btn.hidden = NO;
    [objCustomNavigation.btn_back addTarget:self action:@selector(MenuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)MenuBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)HomeBtnAction:(id)sender
{
//    HomeVC  * objTabVC=[[HomeVC alloc]init];
//    objTabVC = (HomeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:objTabVC animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == _imageCView){
        return imageArray.count;
    }else if(collectionView == _videoCView){
        return videoArray.count;
    }else if(collectionView == _docuCView){
        return documentArray.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   // MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];

    
  // ExcerciseAttachmentCVC * objCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
    
    if(collectionView == self.imageCView){
        
        NSMutableDictionary *dict = [imageArray objectAtIndex:indexPath.row];
        
        
   
        ExcerciseAttachmentCVC* cell = [self.imageCView dequeueReusableCellWithReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];

        NSURL *url=[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"FilePath"]]];

        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_image"]];
        
        return cell;

    }else if(collectionView == self.videoCView){
        ExcerciseAttachmentCVC* cell = [self.videoCView dequeueReusableCellWithReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
        
        [cell.image setImage:  [UIImage imageNamed:@"default_video"]];

   //     ExcerciseAttachmentCVC * cell = [self.videoCView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
        return cell;
        
    }else if(collectionView == self.docuCView){
        ExcerciseAttachmentCVC* cell = [self.docuCView dequeueReusableCellWithReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
        [cell.image setImage:  [UIImage imageNamed:@"default_pdf"]];


      //  ExcerciseAttachmentCVC * cell = [self.docuCView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
        return cell;
        
    }
//
//
// //   ExcerciseAttachmentCVC * objCell = [collectionView dequeueReusableCellWithIdentifier:@"InjuryListCell"];
//
//    if (objCell == nil)
//    {
//        [[NSBundle mainBundle] loadNibNamed:@"ExcerciseAttachmentCVC" owner:self options:nil];
//        objCell = self.attachmentCVC;
//    }
    
    
  //  ExcerciseAttachmentCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attachmentCVC" forIndexPath:indexPath];
    
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // IMAGE_URL
    
    if(collectionView == _imageCView){
        
        NSMutableDictionary *dict = [imageArray objectAtIndex:indexPath.row];
        
//        ExcersizeDetailItemVC  * vc=[[ExcersizeDetailItemVC alloc]init];
        ExcersizeDetailItemVC *vc = [appDel.storyBoard instantiateViewControllerWithIdentifier:@"ExcersizeDetailItemVC"];
        vc.isImage = YES;
        vc.contentImages = imageArray;
        vc.indexPath = indexPath.row;
        //Transparency Color
//        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//        [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//
//        [self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(collectionView == _videoCView){
        NSMutableDictionary *dict = [videoArray objectAtIndex:indexPath.row];
        
//        ExcersizeDetailItemVC  * vc=[[ExcersizeDetailItemVC alloc]init];
        ExcersizeDetailItemVC *vc = [appDel.storyBoard instantiateViewControllerWithIdentifier:@"ExcersizeDetailItemVC"];
        vc.isVideo = YES;
        vc.contentImages = videoArray;
        vc.indexPath = indexPath.row;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if(collectionView == _docuCView){
        NSMutableDictionary *dict = [documentArray objectAtIndex:indexPath.row];
        
//        ExcersizeDetailItemVC  * vc=[[ExcersizeDetailItemVC alloc]init];
        ExcersizeDetailItemVC *vc = [appDel.storyBoard instantiateViewControllerWithIdentifier:@"ExcersizeDetailItemVC"];
        vc.isPDF = YES;
        vc.contentImages = documentArray;
        vc.indexPath = indexPath.row;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void) exerciseDetailWebservice
{
    //[COMMON loadingIcon:self.view];
    if([COMMON isInternetReachable])
    {
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",OPENPLAYEREXERCISEDETAILS]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic    setObject: cliendcode    forKey:@"Clientcode"];
        [dic    setObject:usercode     forKey:@"UserCode"];
        [dic    setObject:userref     forKey:@"UserReferenceCode"];
        [dic    setObject:self.ExcerciseCode     forKey:@"ExcerciseCode"];
        [dic    setObject:self.ProgramCode     forKey:@"ProgramCode"];
        [dic    setObject:self.OrderNo     forKey:@"OrderNo"];

        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject > 0 ){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setDictionary:responseObject];
                
                parameterArray = [[NSMutableArray alloc] init];
                videoArray = [[NSMutableArray alloc] init];
                documentArray = [[NSMutableArray alloc] init];
                imageArray = [[NSMutableArray alloc] init];
                paramActualArray  = [[NSMutableArray alloc] init];
                parameterArray =  [dic valueForKey:@"lstExcercise_Parameters"];
                
                NSString *excInst = @"";
                NSMutableArray *excArr = [dic valueForKey:@"lstExcercise_Details"];
                if(excArr.count >0){
                  excInst =  [[excArr objectAtIndex:0] valueForKey:@"Instruction"];
                }
                
                for (NSDictionary *paramDic in parameterArray){
                    
                    [paramActualArray setObject:[paramDic valueForKey:@"ActualValue"] atIndexedSubscript:paramActualArray.count];
                }

                

                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                tempArray =  [dic valueForKey:@"lstExcercise_filedetails"];

                for (NSDictionary *attcDic in tempArray){
                    
                    if([[attcDic valueForKey:@"FileType"] isEqualToString:@".jpg"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@"jpeg"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@".JPG"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@"JPEG"]||[[attcDic valueForKey:@"FileType"] isEqualToString:@".png"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@".PNG"]){
                        
                        [imageArray setObject:attcDic atIndexedSubscript:imageArray.count];
                        
                    }else if([[attcDic valueForKey:@"FileType"] isEqualToString:@".mp4"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@".MP4"]){
                        
                        [videoArray setObject:attcDic atIndexedSubscript:videoArray.count];
                        
                    }else if([[attcDic valueForKey:@"FileType"] isEqualToString:@".pdf"] || [[attcDic valueForKey:@"FileType"] isEqualToString:@"PDF"]){
                        
                        [documentArray setObject:attcDic atIndexedSubscript:documentArray.count];
                        
                    }

                    

                    
                }
                
                
                int rootHeight = 793;
                int attachmentHeight = 157;
                int tableViewHeight = 107;
                
                //Reset
                rootHeight = rootHeight - (tableViewHeight + (attachmentHeight *3));
                
                
//                793
//                107
//                157
                
                if(imageArray.count>0){
                    [_imageCView reloadData];
                    _imageContainerView.hidden = NO;
                    rootHeight = rootHeight + attachmentHeight;

                }else{
                    _imageContainerView.hidden = YES;
                    _attImageHeight.constant = 0;
                }
                
                if(videoArray.count>0){
                    [_videoCView reloadData];
                    _videoContainerView.hidden = NO;
                    rootHeight = rootHeight + attachmentHeight;
                }else{
                    _videoContainerView.hidden = YES;
                    _attVideoHeight.constant = 0;
                }
                
                if(documentArray.count>0){
                    [_docuCView reloadData];
                    _documentContainerView.hidden = NO;
                    rootHeight = rootHeight + attachmentHeight;
                }else{
                    _documentContainerView.hidden = YES;
                    _attDocmHeight.constant = 0;
                }
                
                rootHeight = rootHeight + (int)([parameterArray count] * 44);
                
                self.paramTblViewHeight.constant = (int)([parameterArray count] * 44);
                
                

                _instructionLbl.text = excInst;
                
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:excInst attributes:@{NSFontAttributeName:_instructionLbl.font}];
                CGRect rect = [attributedText boundingRectWithSize:(CGSize){_instructionLbl.frame.size.width, CGFLOAT_MAX}
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
                
                
                

              //  _instructionLbl.frame = rect;
                
                _instructionLblHeight.constant = rect.size.height ;
                
              //  self.imgViewContainerTop.constant = rect.size.height+15;
                
             //   CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rect.height)
                
                rootHeight = rootHeight +  rect.size.height;
                
                self.rootViewHeight.constant = rootHeight;

                
//                 ceil(rect.size.height);
//
//
//                CGSize expectedLabelSize = [@"" boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSAttributedStringKey,id> *)#> context:<#(nullable NSStringDrawingContext *)#>
//
//                CGSize expectedLabelSize = [@"" sizeWithFont:_instructionLbl.font constrainedToSize:maximumLabelSize lineBreakMode:_instructionLbl.lineBreakMode];
//
//                //adjust the label the the new height.
//                CGRect newFrame = _instructionLbl.frame;
//                newFrame.size.height = expectedLabelSize.height;
               // _instructionLbl.frame = newFrame;
                
                
                [_paramTView reloadData];
                
            }
            
//            if([[responseObject valueForKey:@"Status"] isEqualToString:@"PSUCCESS"] && [responseObject valueForKey:@"Status"] != NULL)
//            {
//                NSDictionary * objRole =[responseObject valueForKey:@"Roles"];
//                
//                NSString * objRoleCode =[[objRole valueForKey:@"Rolecode"] objectAtIndex:0];
//                
//                NSString * objRoleName =[[objRole valueForKey:@"RoleName"] objectAtIndex:0];
//                [[NSUserDefaults standardUserDefaults] setObject:[responseObject valueForKey:@"UserCode"] forKey:@"UserCode"];
//                [[NSUserDefaults standardUserDefaults] setObject:[responseObject valueForKey:@"ClientCode"] forKey:@"ClientCode"];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:[responseObject valueForKey:@"Userreferencecode"] forKey:@"Userreferencecode"];
//               
//            }
//            else{
//              
//                [COMMON RemoveLoadingIcon];
//            }
            
            //[COMMON RemoveLoadingIcon];
            [self.view setUserInteractionEnabled:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
           // [COMMON webServiceFailureError];
            [self.view setUserInteractionEnabled:YES];
            
        }];
    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return parameterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"paramTVC";
    
    ExcerciseParameterTVC * objCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (objCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ExcerciseParameterTVC" owner:self options:nil];
        objCell = self.paramTVC;
    }
    
    NSMutableDictionary *dic = [parameterArray objectAtIndex:indexPath.row];
    //NSString * param = [dic valueForKey:@"value"];
    objCell.parameterLbl.text = [dic valueForKey:@"ParameterName"];
    objCell.valueLbl.text = [[dic valueForKey:@"value"] stringValue];
   objCell.actualTFld.text = [[dic valueForKey:@"ActualValue"] stringValue];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *uiBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)];
    uiBarBtn.tag = indexPath.row;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], uiBarBtn
                            ];
    //[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad:)],
    [numberToolbar sizeToFit];
    objCell.actualTFld.inputAccessoryView = numberToolbar;
    
    //[[parameterArray objectAtIndex:indexPath.row] valueForKey:@"ActualValue"];
    
    objCell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return objCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


//-(void)cancelNumberPad:(id) sender{
//
//    ExcerciseParameterTVC *cell = [_paramTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//
//    [cell.actualTFld resignFirstResponder];
//}

-(void)doneWithNumberPad:(id) sender{
    ExcerciseParameterTVC *cell = [_paramTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    [cell.actualTFld resignFirstResponder];
}

- (IBAction)onClickSaveBtn:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:cliendcode forKey:@"Clientcode"];
    [dict setValue:usercode forKey:@"UserCode"];
    [dict setValue:_ProgramCode forKey:@"ProgramCode"];
    [dict setValue:_ExcerciseCode forKey:@"ExcerciseCode"];
    [dict setValue:_OrderNo forKey:@"OrderNo"];
    [dict setValue:userref forKey:@"UserReferenceCode"];

    

 
    BOOL flag = false;
    
    NSMutableArray *paramArray = [[NSMutableArray alloc] init];
    for(int i=0;i<parameterArray.count;i++){
        ExcerciseParameterTVC *cell = [_paramTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setValue:[[parameterArray objectAtIndex:i] objectForKey:@"ParameterCode"] forKey:@"ParameterCode"];
        [paramDict setValue:[[parameterArray objectAtIndex:i] objectForKey:@"value"] forKey:@"value"];
        
        NSString *actualValue = cell.actualTFld.text;
        actualValue = [actualValue stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];

        if([actualValue isEqualToString:@""] ){
            flag = true;
            break;
        }
        
        [paramDict setValue: actualValue forKey:@"ActualValue"];
          //[initWithObjectsAndKeys: cell.name.text, @"name", cell.age.text, @"age", nil];
        
        [paramArray addObject:paramDict];
    }
    
    [dict setValue:paramArray forKey:@"lstExcercise_Parameters"];

    if(!flag){
        [self saveParamWebservice:dict];
    }else{
        [self showAlertWithMessage:@"Actual value can not be empty"];
    }
}
-(void) showAlertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [appDel.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


-(void) saveParamWebservice : (NSMutableDictionary *) dict
{
    //[COMMON loadingIcon:self.view];
    if([COMMON isInternetReachable])
    {
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",@"SAVEPLAYEREXCERCISEDETAILS"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic    setObject: cliendcode    forKey:@"Clientcode"];
//        [dic    setObject:usercode     forKey:@"UserCode"];
//        [dic    setObject:userref     forKey:@"UserReferenceCode"];
//        [dic    setObject:self.ExcerciseCode     forKey:@"ExcerciseCode"];
//        [dic    setObject:self.ProgramCode     forKey:@"ProgramCode"];
//        [dic    setObject:self.OrderNo     forKey:@"OrderNo"];
        
        NSLog(@"parameters : %@",dict);
        [manager POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject > 0 ){
                
                [self showAlertWithMessage:@"Saved successfully"];
            }else{
                [self showAlertWithMessage:@"Saved failed"];
            }
            
           
            
           // [COMMON RemoveLoadingIcon];
            [self.view setUserInteractionEnabled:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
           // [COMMON webServiceFailureError];
            [self.view setUserInteractionEnabled:YES];
            
        }];
    }
    
}



@end
