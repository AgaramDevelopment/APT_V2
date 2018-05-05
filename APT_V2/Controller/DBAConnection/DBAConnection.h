//
//  DBAConnection.h
//  AlphaProTracker
//
//  Created by Mac on 20/10/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBAConnection : NSObject

+ (id)sharedManager;

-(NSMutableArray *)AssessmentTestType: (NSString *) clientCode :(NSString *) userCode:(NSString *) moduleCode;
//-(NSMutableArray *)TestByAssessment: (NSString *) clientCode :(NSString *) AssessmentCode:(NSString *) moduleCode;
-(NSMutableArray *)TestByAssessment: (NSString *) clientCode :(NSString *) AssessmentCode:(NSString *) moduleCode:(NSString *)SelectedDate;
-(NSMutableArray *)TestByAssessmentAll: (NSString *) clientCode :(NSString *) AssessmentCode:(NSString *) moduleCode;


-(NSMutableArray *)AssessmentEntryByDate: (NSString *) AssessmentCode :(NSString *) Usercode:(NSString *) moduleCode:(NSString *) date:(NSString *) Clientcode;

-(NSMutableArray *)getAssessmentEnrtyByDateTestType:(NSString *) assessmentCode:(NSString *) userCode:(NSString *) moduleCode :(NSString *) date:(NSString *) clientCode:(NSString *) testTypeCode:(NSString *) testCode andVersion:(NSString *)version andPlayerCode:(NSString*)playerCode;

-(NSMutableArray *)PlayersByCoach:(NSString *) Clientcode:(NSString *) Usercode;

-(NSDictionary *)ScreenId:(NSString *) AssessmentCode:(NSString *) AssessmentTestCode;
-(NSString *)ScreenCount:(NSString *) AssessmentCode:(NSString *) AssessmentTestCode;

-(NSMutableArray *)AssementForm:(NSString *) ScreenId:(NSString *) clientcode :(NSString *) modulecode:(NSString *) AssessmentCode :(NSString *) AssessmentTestCode  andVersion:(NSString *)version;
-(NSMutableArray *)AssessmentTeamListDetail :(NSString *) membercode;
-(NSMutableArray *)AssessmentPlayerListDetail :(NSString *) clientCode :(NSString *)userCode;
-(NSMutableArray *)GetAssessmentByCoach:(NSString *)clientCode : (NSString *) ModuleCode;

-(NSMutableArray *)GetRomWithEntry:(NSString *)version:(NSString *)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString *)clientCode:(NSString *)createdBy:(NSString *)player:(NSString *)assessmentDate:(NSString *)TestTypeCode;

-(NSMutableArray*)getRomWithoutEntry:(NSString *)version:(NSString*)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString*)clientCode:(NSString *)testTypeCode;
-(NSMutableArray *) getSCWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *)clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode;

-(NSMutableArray *) getSCWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString*) testTypeCode;

-(NSMutableArray *) getMMTWithEnrty:(NSString *) version:(NSString *) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString *)  player:(NSString *) assessmentDate:(NSString *) testTypeCode;

-(NSMutableArray *) getMMTWithoutEnrty:(NSString *) version:(NSString *) moduleCode:(NSString *) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode;

-(NSMutableArray *) getGaintWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode;

-(NSMutableArray*) getGaintWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:( NSString *) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode;

-(NSMutableArray *) getPostureWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode;

-(NSMutableArray *) getPostureWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode;

-(NSMutableArray*) getTestCoachWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString *) testTypeCode;

-(NSMutableArray *) getTestCoachWithoutEnrty:(NSString *) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode;
-(NSMutableArray *) getSpecWithEnrty:(NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode: (NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode;

-(NSMutableArray *)getSpecWithoutEnrty: (NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) testTypeCode;


-(NSMutableArray *)getResultCombo;

-(NSMutableArray *) getPositiveNegative;
-(NSMutableArray *) getWithMmtCombo;
-(NSMutableArray *) getwithPostureRESULTS;
-(NSMutableArray*)getTestcode:(NSString *)kpiStr;

#pragma InsertAssessment
-(BOOL) UPDATEAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSString*) Left:(NSString*) Right:(NSString*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync;

-(BOOL) INSERTAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSString*) Left:(NSString*) Right:(NSString*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync;


-(BOOL)updateAssessmentEntry:(NSDictionary *)dict;
-(BOOL)insertAssessmentEntry:(NSDictionary *)dict;
@end
