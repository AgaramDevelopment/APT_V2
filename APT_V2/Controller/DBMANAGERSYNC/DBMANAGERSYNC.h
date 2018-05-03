//
//  DBMANAGERSYNC.h
//  CAPScoringApp
//
//  Created by Lexicon on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBMANAGERSYNC : NSObject
//competition insert&Update







@property (nonatomic,strong)  NSMutableArray *Assmnt;
@property (nonatomic,strong)  NSMutableArray *AssmntTestMaster;
@property (nonatomic,strong)  NSMutableArray *RangeOfMotion;
@property (nonatomic,strong)  NSMutableArray *TestSplArray;
@property (nonatomic,strong)  NSMutableArray *Testmmt;
@property (nonatomic,strong)  NSMutableArray *TestgaintArray;
@property (nonatomic,strong)  NSMutableArray *TestpostureArray;
@property (nonatomic,strong)  NSMutableArray *TestSCArray;
@property (nonatomic,strong)  NSMutableArray *TestCoachArray;

@property (nonatomic,strong)  NSMutableArray *metadataArray;
@property (nonatomic,strong)  NSMutableArray *SportsInfoArray;
@property (nonatomic,strong)  NSMutableArray *AssessmentRegisterArray;
@property (nonatomic,strong)  NSMutableArray *AtheleteMemRegArray;
@property (nonatomic,strong)  NSMutableArray *AtheleteInfoTeamArray;
@property (nonatomic,strong)  NSMutableArray *SupportStaffInfoArray;
@property (nonatomic,strong)  NSMutableArray *RoleDetailsArray;
@property (nonatomic,strong)  NSMutableArray *UserDetailsArray;
@property (nonatomic,strong)  NSMutableArray *UserRolemapArray;
@property (nonatomic,strong)  NSMutableArray *AthleteinfodetailsArray;
@property (nonatomic,strong)  NSMutableArray * TeamListDetailArray;
@property (nonatomic,strong)  NSMutableArray * SupportStaffArray;
@property (nonatomic,strong)  NSMutableArray * AssessmentEntyArray;


  
+ (id)sharedManager;
-(void) copyDatabaseIfNotExist;


-(BOOL) SELECTASSESSMENT:(NSString*) ASSESSMENTCODE;
-(BOOL) SELECTASSESSMENTTESTMASTER:(NSString *)TESTCODE;
-(BOOL) SELECTRANGEOFMOTION:(NSString *)Testcode;
-(BOOL) TESTSPECIAL:(NSString *)Testcode;
-(BOOL) TESTmmt:(NSString *)Testcode;
-(BOOL) SELECTTESTGAINT:(NSString *)Testcode;
-(BOOL) SELECTTESTPosture:(NSString *)Testcode;
-(BOOL) SELECTTESTSC:(NSString *)Testcode;
-(BOOL) SELECTTESTCoaching:(NSString *)Testcode;

-(BOOL) SELECTmetadata:(NSString *)Metasubcode;
-(BOOL) SELECTSportsInfo:(NSString *)Athletecode;
-(BOOL) SELECTAssementRegister:(NSString *)Assessmentregistercode;
-(BOOL) SELECTAtheleteMemReg:(NSString *)Associationmemberid;
-(BOOL) SELECTAtheleteInfoTeam:(NSString *)Athletecode;
-(BOOL) SELECTSupportStaffInfo:(NSString *)Athletecode:(NSString *)Teamcode;
-(BOOL) SELECTRoleDetails:(NSString *)Rolecode;
-(BOOL) SELECTUserDetails:(NSString *)Usercode;
-(BOOL) SELECTUserRoleMap:(NSString *)Usercode:(NSString *)Rolecode;


-(BOOL)DleteAthleteinfodetails;
-(BOOL)InsertAthleteinfodetails:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Gamecode:(NSString*) Teamcode:(NSString*) Attributevaluecode:(NSString*) Attributevaluedescription:(NSString*) Inputtype:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate ;

-(BOOL)DletegameAttribute;
-(BOOL)InsertgameAttribute:(NSString*) Attributevaluecode:(NSString*) Attributevaluedescription:(NSString*) Gametype:(NSString*) Attributecode:(NSString*) Attributedescription:(NSString*) Inputtype;


-(BOOL)DleteTestGoal;
-(BOOL)InsertTestGoal:(NSString*)Clientcode: (NSString*)Testcode:(NSString*) Min:(NSString*) Max: (NSString*)Recordstatus:(NSString*) Createdby:(NSString*)Createddate:(NSString*)Modifiedby:(NSString*)Modifieddate;

//TeamList

-(BOOL) SELECTTEAM:(NSString *)TEAMCODE;
//SupportStaff
-(BOOL)SELECTSupportStaff:(NSString *)MemberCode;

-(BOOL)SELECTAssementEntry:(NSString *)AssessementEntryCode;
-(BOOL)DeleteTableNameWise:(NSString *)TableName;

//fetch the image
-(NSMutableArray *)getPlayerCode;
-(NSMutableArray *)getTeamCode;

-(NSMutableArray *)getofficailCode;
-(NSMutableArray *)getgroundcode;

-(NSMutableDictionary *)AssessmentEntrySyncBackground;

-(BOOL) UPDATESyncStatus:(NSMutableArray*) entryDetailsList;

@property(nonatomic,strong) NSString *getDBPath;

@end
