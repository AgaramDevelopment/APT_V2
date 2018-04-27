//
//  DBAConnection.m
//  AlphaProTracker
//
//  Created by Mac on 20/10/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "DBAConnection.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "getimageRecord.h"
//#import "Utitliy.h"
//#import "TestAssessmentViewVC.h"
#import "Header.h"

@implementation DBAConnection

static NSString *SQLITE_FILE_NAME = @"agapt_database.sqlite";

//Copy database to application document
//-(void) copyDatabaseIfNotExist{
//
//    //Using NSFileManager we can perform many file system operations.
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    NSString *dbPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
//
//    //NSString *dbPath = [self getDBPath];
//    BOOL success = [fileManager fileExistsAtPath:dbPath];
//
//    if(!success) {//If file not exist
//        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
//
//        if (!success)
//        {
//            NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//        }
//    }
//}

//Get database path
-(NSString *) getDBPath
{
//    [self copyDatabaseIfNotExist];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    NSString* dbPath = [[DBMANAGERSYNC sharedManager] getDBPath];
    
    return  dbPath;
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}


-(NSNumber *) getNumberValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [NSNumber numberWithInt: [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"0":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]].intValue];
}

//MATCHREGISTRATION

-(NSMutableArray *)AssessmentTestType: (NSString *) clientCode :(NSString *) userCode:(NSString *) moduleCode{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT ASSM.CLIENTCODE, ASSM.MODULECODE, ASSM.ASSESSMENTCODE,ASSM.ASSESSMENTNAME,ASSM.RECORDSTATUS,ASSM.CREATEDBY,ASSM.CREATEDDATE,ASSM.MODIFIEDBY,ASSM.MODIFIEDDATE,MDMODULE.METASUBCODEDESCRIPTION AS MODULENAME FROM  ASSESSMENT ASSM INNER JOIN METADATA MDMODULE  ON MDMODULE.METASUBCODE=ASSM.MODULECODE WHERE ASSM.CLIENTCODE = '%@' AND ASSM.RECORDSTATUS = 'MSC001' AND CREATEDBY = '%@' AND MODULECODE = '%@'",clientCode,userCode,moduleCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
//                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                    f.numberStyle = NSNumberFormatterDecimalStyle;
//                    // [f numberFromString:
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *	setAssessmentCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString *	setAssessmentName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    [dic setObject:setAssessmentCode forKey:@"AssessmentCode"];
                    [dic setObject:setAssessmentName forKey:@"AssessmentName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
    
        return assessment;
    }
}

-(NSMutableArray *)TestByAssessment: (NSString *) clientCode :(NSString *) AssessmentCode:(NSString *) moduleCode:(NSString *)SelectedDate{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
    
//            (CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
            NSString *query=[NSString stringWithFormat:@"SELECT TESTCODE, TESTNAME FROM ASSESSMENTTESTMASTER WHERE CLIENTCODE = '%@' AND MODULECODE = '%@' AND ASSESSMENTCODE = '%@'",clientCode,moduleCode,AssessmentCode];
            
//            NSString *query=[NSString stringWithFormat:@"SELECT TESTCODE, TESTNAME FROM ASSESSMENTTESTMASTER WHERE CLIENTCODE = '%@' AND MODULECODE = '%@' AND ASSESSMENTCODE = '%@' AND CREATEDDATE = '%@'",clientCode,moduleCode,AssessmentCode,SelectedDate];

            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *	setTestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *	setTestName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    
                    [dic setObject:setTestCode forKey:@"TestCode"];
                    [dic setObject:setTestName forKey:@"TestName"];

                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *)AssessmentEntryByDate: (NSString *) AssessmentCode :(NSString *) Usercode:(NSString *) moduleCode:(NSString *) date:(NSString *) Clientcode{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            
            
            //NSString * rd = @"MSC001";
            
            //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTENTRY WHERE ASSESSMENTCODE = '%@' AND CREATEDBY = '%@' AND  DATE(ASSESSMENTENTRYDATE) = DATE('%@') AND  MODULECODE = '%@' AND CLIENTCODE = '%@' AND RECORDSTATUS = 'MSC001'",AssessmentCode,Usercode,date,moduleCode,Clientcode];
            
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    
                    
                    //                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    //                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    //                    // [f numberFromString:
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *	setAssessmentCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString *	setTestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString *	setTestTypeCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString *	setAthleteCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    
                    [dic setObject:setAssessmentCode forKey:@"AssessmentCode"];
                    [dic setObject:setTestCode forKey:@"TestCode"];
                    [dic setObject:setTestTypeCode forKey:@"TestTypeCode"];
                    [dic setObject:setAthleteCode forKey:@"AthleteCode"];

                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *)PlayersByCoach:(NSString *) Clientcode:(NSString *) Userref{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            
            
            //NSString * rd = @"MSC001";
            
            //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
            NSString *query=[NSString stringWithFormat:@"SELECT AIT.ATHLETECODE,COALESCE(AMR.FIRSTNAME,'')||' '||COALESCE(AMR.LASTNAME,'') AS PLAYERNAME FROM ATHLETEINFOTEAM AIT INNER JOIN  ASSOCIATIONMEMBERREGISTRATION AMR ON AMR.ASSOCIATIONMEMBERID = AIT.ATHLETECODE AND AMR.CLIENTCODE=AIT.CLIENTCODE WHERE TEAMCODE IN (SELECT DISTINCT TEAMCODE FROM SUPPORTSTAFFTEAMS AIT WHERE AIT.CODE = '%@' AND AIT.CLIENTCODE = '%@') UNION SELECT AIT.ATHLETECODE,    COALESCE(AMR.FIRSTNAME,'')||' '||COALESCE(AMR.LASTNAME,'') AS PLAYERNAME FROM ATHLETEINFOTEAM AIT INNER JOIN  ASSOCIATIONMEMBERREGISTRATION AMR ON AMR.ASSOCIATIONMEMBERID = AIT.ATHLETECODE AND AMR.CLIENTCODE=AIT.CLIENTCODE WHERE TEAMCODE IN (SELECT DISTINCT TEAMCODE FROM ATHLETEINFOTEAM AIT WHERE AIT.ATHLETECODE = '%@' AND AIT.CLIENTCODE = '%@')",Userref,Clientcode,Userref,Clientcode];
            
            
            
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    
                    
                    //                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    //                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    //                    // [f numberFromString:
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *	setPlayerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *	setPlayerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    
                    [dic setObject:setPlayerCode forKey:@"PlayerCode"];
                    [dic setObject:setPlayerName forKey:@"PlayerName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}


-(NSDictionary *)ScreenId:(NSString *) AssessmentCode:(NSString *) AssessmentTestCode{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        NSString *	result;
        NSMutableDictionary* dict = [NSMutableDictionary new];

        if(retVal ==0){
            
            
            //NSString * rd = @"MSC001";
            
            //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
            NSString *query=[NSString stringWithFormat:@"SELECT VERSION, ASSESSMENTTESTTYPESCREENCODE FROM ASSESSMENTREGISTER WHERE ASSESSMENTCODE= '%@' AND ASSESSMENTTESTCODE= '%@' GROUP BY ASSESSMENTTESTTYPESCREENCODE",AssessmentCode,AssessmentTestCode];
            
            
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString* code=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString* version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];

                    [dict setValue:code forKey:@"ScreenID"];
                    [dict setValue:version forKey:@"version"];
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", result);
        
        return dict;
    }
}

-(NSString *)ScreenCount:(NSString *) AssessmentCode:(NSString *) AssessmentTestCode{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        NSString *	result;
        int re;
        if(retVal ==0){
            
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(ASSESSMENTTESTTYPESCREENCODE) FROM ASSESSMENTREGISTER WHERE ASSESSMENTCODE ='%@' AND ASSESSMENTTESTCODE='%@'",AssessmentCode,AssessmentTestCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", result);
        
        return result;
    }
}


-(NSMutableArray *)AssementForm:(NSString *) ScreenId:(NSString *) clientcode :(NSString *) modulecode:(NSString *) AssessmentCode :(NSString *) AssessmentTestCode{
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        
        if(retVal ==0){
  
            NSString *query=[NSString stringWithFormat:@"SELECT(CASE WHEN '%@'='ASTT001' THEN TRM.TESTCODE WHEN '%@'='ASTT002' THEN TS.TESTCODE WHEN '%@'='ASTT003'  THEN MMT.TESTCODE  WHEN '%@'='ASTT004' THEN TG.TESTCODE WHEN '%@'='ASTT005' THEN TP.TESTCODE WHEN '%@'='ASTT006' THEN SC.TESTCODE  WHEN '%@'='ASTT007' THEN TC.TESTCODE END )   AS TESTTYPECODE, (CASE WHEN '%@'='ASTT001' THEN IFNULL(TRM.JOINT,'')||'-'||IFNULL(TRM.MOVEMENT,'') WHEN '%@'='ASTT002' THEN IFNULL(TS.TESTNAME,'(empty)') WHEN '%@'='ASTT003' THEN IFNULL(MMT.JOINT,'')||'-'||IFNULL(MMT.MOTION,'')||IFNULL(MMT.MUSCLE,'')  WHEN '%@'='ASTT004' THEN IFNULL(TG.PLANE,'')||'-'||IFNULL(TG.TESTNAME,'(empty)') WHEN '%@'='ASTT005' THEN IFNULL(TP.VIEW,'')||'-'||IFNULL(TP.REGION,'') WHEN '%@'='ASTT006' THEN IFNULL(SC.COMPONENT,'')||'-'||IFNULL(SC.TESTNAME,'') WHEN '%@'='ASTT007' THEN IFNULL(TC.KPI,'')||'-'||IFNULL(TC.DESCRIPTION,'') END )   AS TESTTYPENAME  FROM   ASSESSMENTREGISTER  ATM  LEFT JOIN TESTRANGEOFMOTION TRM ON TRM.TESTCODE=ATM.ASSESSMENTTESTTYPECODE  LEFT JOIN TESTSPECIAL TS ON TS.TESTCODE=ATM.ASSESSMENTTESTTYPECODE  LEFT JOIN TESTMMT MMT ON MMT.TESTCODE=ATM.ASSESSMENTTESTTYPECODE LEFT JOIN TESTPOSTURE TP ON TP.TESTCODE=ATM.ASSESSMENTTESTTYPECODE LEFT JOIN TESTGAINT TG ON TG.TESTCODE=ATM.ASSESSMENTTESTTYPECODE  LEFT JOIN TESTSC SC ON SC.TESTCODE=ATM.ASSESSMENTTESTTYPECODE LEFT JOIN TESTCOACHING TC ON TC.TESTCODE=ATM.ASSESSMENTTESTTYPECODE WHERE ATM.ASSESSMENTTESTTYPESCREENCODE='%@'  AND  ATM.CLIENTCODE='%@'  AND    ATM.MODULECODE='%@' AND ATM.RECORDSTATUS= 'MSC001' AND ATM.ASSESSMENTCODE = '%@' AND ATM.ASSESSMENTTESTCODE = '%@'",ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,ScreenId,clientcode,modulecode,AssessmentCode,AssessmentTestCode];
            
            
            
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *	setTestTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *	setTestTypeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];

                    
                    [dic setObject:setTestTypeCode forKey:@"TestTypeCode"];
                    [dic setObject:setTestTypeName forKey:@"TestTypeName"];
                    
                    [assessment addObject:dic];

                    
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}


//TeamLIST

-(NSMutableArray *)AssessmentTeamListDetail :(NSString *) membercode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT TM.TEAMCODE,TEAMNAME FROM TEAMMASTER TM INNER JOIN  SUPPORTSTAFFTEAMS  ON TM.TEAMCODE=SUPPORTSTAFFTEAMS.TEAMCODE LEFT JOIN SUPPORTSTAFF SUP ON SUP.MEMBERCODE=SUPPORTSTAFFTEAMS.CODE WHERE SUP.MEMBERCODE='%@'",membercode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    [dic setObject:setTeamCode forKey:@"TeamCode"];
                    [dic setObject:setTeamName forKey:@"TeamName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *)AssessmentPlayerListDetail :(NSString *) clientCode :(NSString *)userCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT AIT.ATHLETECODE,    COALESCE(AMR.FIRSTNAME,'')||' '||COALESCE(AMR.LASTNAME,'') AS PLAYERNAME FROM ATHLETEINFOTEAM AIT INNER JOIN  ASSOCIATIONMEMBERREGISTRATION AMR ON AMR.ASSOCIATIONMEMBERID = AIT.ATHLETECODE AND AMR.CLIENTCODE=AIT.CLIENTCODE WHERE TEAMCODE IN (SELECT DISTINCT TEAMCODE FROM SUPPORTSTAFFTEAMS AIT WHERE AIT.CODE = '%@' AND AIT.CLIENTCODE = '%@') union SELECT AIT.ATHLETECODE,    COALESCE(AMR.FIRSTNAME,'')||' '||COALESCE(AMR.LASTNAME,'') AS PLAYERNAME FROM ATHLETEINFOTEAM AIT INNER JOIN  ASSOCIATIONMEMBERREGISTRATION AMR ON AMR.ASSOCIATIONMEMBERID = AIT.ATHLETECODE AND AMR.CLIENTCODE=AIT.CLIENTCODE WHERE TEAMCODE IN (SELECT DISTINCT TEAMCODE FROM ATHLETEINFOTEAM AIT WHERE AIT.ATHLETECODE = '%@' AND AIT.CLIENTCODE = '%@')",clientCode,userCode,clientCode,userCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    [dic setObject:setTeamCode forKey:@"ATHLETECODE"];
                    [dic setObject:setTeamName forKey:@"PLAYERNAME"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}


//Assessment By Coach

-(NSMutableArray *)GetAssessmentByCoach:(NSString *)clientCode : (NSString *) ModuleCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT ASSM.CLIENTCODE,ASSM.MODULECODE,ASSM.ASSESSMENTCODE,ASSM.ASSESSMENTNAME,ASSM.RECORDSTATUS,ASSM.CREATEDBY,ASSM.CREATEDDATE,ASSM.MODIFIEDBY,ASSM.MODIFIEDDATE,MDMODULE.METASUBCODEDESCRIPTION AS MODULENAME FROM    ASSESSMENT ASSM INNER JOIN METADATA MDMODULE ON MDMODULE.METASUBCODE=ASSM.MODULECODE WHERE  ASSM.CLIENTCODE= '%@'  AND ASSM.RECORDSTATUS='MSC001' AND MODULECODE = '%@'",clientCode,ModuleCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    [dic setObject:setTeamCode forKey:@"ASSESSMENTCODE"];
                    [dic setObject:setTeamName forKey:@"ASSESSMENTNAME"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *)GetRomWithEntry:(NSString *)version:(NSString *)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString *)clientCode:(NSString *)createdBy:(NSString *)player:(NSString *)assessmentDate:(NSString *)TestTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT DISTINCT ROM.CLIENTCODE,ROM.TESTCODE,ROM.JOINT,ROM.MOVEMENT,ROM.SIDE,ROM.MINIMUMRANGE,ROM.MAXIMUMRANGE  AS Normalrange,ROM.UNIT,ROM. RECORDSTATUS,ROM.CREATEDBY,ROM.CREATEDDATE,ROM.MODIFIEDBY,ROM.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNIT.METASUBCODEDESCRIPTION AS UNITNAME,AE.LEFT,AE.RIGHT,AE.CENTRAL,AE.INFERENCE,AE.REMARKS,AE.ASSESSMENTENTRYCODE,AE.VERSION,AE.IGNORED FROM TESTRANGEOFMOTION ROM INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=ROM.SIDE INNER JOIN METADATA MDUNIT ON MDUNIT.METASUBCODE=ROM.UNIT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE= '%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.CREATEDBY = '%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND AE.CLIENTCODE = ASREG.CLIENTCODE   AND AE.CREATEDBY = '%@' AND AE.MODULECODE = ASREG.MODULECODE AND ROM.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND AE.ASSESSMENTTESTTYPECODE = '%@' AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@' ) AND AE.VERSION ='%@' WHERE   ROM.RECORDSTATUS='MSC001'  AND ROM.CLIENTCODE='%@' AND ROM.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.CREATEDBY ='%@')",clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy,createdBy,TestTypeCode,player,player,assessmentDate,assessmentDate,version,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * clientcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * Testcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * romJoint=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * romMovement=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * romSide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * romMinimumRange=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * romMaximumRange=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * romUnit=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * romRecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * romSideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * romUnitName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * romLeft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString * romRight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString * romCenter=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    // NSString * romValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * romInference=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString * AssessmentEntrycode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString * version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    NSString * Ignore=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                    
                    [dic setObject:clientcode forKey:@"ClientCode"];
                    [dic setObject:Testcode forKey:@"TestCode"];
                    [dic setObject:romJoint forKey:@"Joint"];
                    [dic setObject:romMovement forKey:@"Movement"];
                    [dic setObject:romSide forKey:@"Side"];
                    [dic setObject:romMinimumRange forKey:@"MinimumRange"];
                    [dic setObject:romMaximumRange forKey:@"MaximumRange"];
                    [dic setObject:romUnit forKey:@"Unit"];
                    [dic setObject:romRecordStatus forKey:@"RecordStatus"];
                    [dic setObject:romSideName forKey:@"SideName"];
                    [dic setObject:romUnitName forKey:@"UnitName"];
                    [dic setObject:romLeft forKey:@"Left"];
                    [dic setObject:romRight forKey:@"Right"];
                    [dic setObject:romCenter forKey:@"Center"];
                    //[dic setObject:romValue forKey:@"romValue"];
                    [dic setObject:romInference forKey:@"Inference"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:AssessmentEntrycode forKey:@"AssessmentEntrycode"];
                    [dic setObject:version forKey:@"Version"];
                    [dic setObject:Ignore forKey:@"Ignore"];
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray*)getRomWithoutEntry:(NSString *)version:(NSString*)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString*)clientCode:(NSString *)testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  ROM.CLIENTCODE,ROM.TESTCODE,ROM.JOINT,ROM.MOVEMENT,ROM.SIDE,ROM.MINIMUMRANGE,ROM.MAXIMUMRANGE,ROM.UNIT,ROM.RECORDSTATUS,ROM.CREATEDBY,ROM.CREATEDDATE,ROM.MODIFIEDBY,ROM.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNIT.METASUBCODEDESCRIPTION AS UNITNAME,'' as LEFT,'' as RIGHT,'' as CENTRAL,'' as INFERENCE,'' as REMARKS,'' as ASSESSMENTENTRYCODE,ASREG.VERSION FROM    TESTRANGEOFMOTION ROM INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=ROM.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=rom.TESTCODE AND VERSION = '%@'  AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=ROM.SIDE INNER JOIN METADATA MDUNIT ON MDUNIT.METASUBCODE=ROM.UNIT WHERE   ROM.RECORDSTATUS='MSC001'  AND ROM.CLIENTCODE= '%@' AND ASREG.ASSESSMENTTESTCODE= '%@' AND ROM.TESTCODE='%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * clientcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * Testcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * romJoint=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * romMovement=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * romSide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * romMinimumRange=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * romMaximumRange=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * romUnit=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * romSideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * romUnitName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    
                    NSString * romLeft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * romRight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * romCenter=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * romRemarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * romInference=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];

                    
                    [dic setObject:clientcode forKey:@"ClientCode"];
                    [dic setObject:Testcode forKey:@"TestCode"];
                    [dic setObject:romJoint forKey:@"Joint"];
                    [dic setObject:romMovement forKey:@"Movement"];
                    [dic setObject:romSide forKey:@"Side"];
                    [dic setObject:romMinimumRange forKey:@"MinimumRange"];
                    [dic setObject:romMaximumRange forKey:@"MaximumRange"];
                    [dic setObject:romUnit forKey:@"Unit"];
                    [dic setObject:romSideName forKey:@"SideName"];
                    [dic setObject:romUnitName forKey:@"UnitName"];
                    [dic setObject:@"" forKey:@"Left"];
                    [dic setObject:@"" forKey:@"Right"];
                    [dic setObject:@"" forKey:@"Center"];
                    [dic setObject:@"" forKey:@"Value"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:@"" forKey:@"Ignore"];
                    [dic setObject:version forKey:@"Version"];

                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *) getSCWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *)clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  SC.CLIENTCODE,SC.TESTCODE,SC.COMPONENT,SC.TESTNAME,SC.SIDE,SC.NOOFTRIALS,                         SC.UNITS,SC.SCOREEVALUATION,SC.RECORDSTATUS,AE.INFERENCE,SC.CREATEDBY,SC.CREATEDDATE,SC.MODIFIEDBY,SC.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,MDSCOREEVALUATION.METASUBCODEDESCRIPTION AS SCOREEVALUATIONNAME,AE.REMARKS,AE.LEFT , RIGHT,AE.CENTRAL , LEFT1,AE.RIGHT1 , CENTRAL1, AE.LEFT2, RIGHT2,AE.CENTRAL2, AE.LEFT3, RIGHT3,AE.CENTRAL3,AE.LEFT4, RIGHT4,AE.CENTRAL4,AE.LEFT5, RIGHT5,AE.CENTRAL5,AE.LEFT6 , RIGHT6,AE.LEFT7, RIGHT7,AE.CENTRAL7,AE.LEFT8 , RIGHT8,AE.CENTRAL8,AE.LEFT9 , RIGHT9,AE.CENTRAL9,AE.CENTRAL6,AE.VERSION  ,AE.ASSESSMENTENTRYCODE ,AE.IGNORED FROM    TESTSC SC INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=SC.UNITS INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTTYPECODE = '%@' AND AE.CLIENTCODE = ASREG.CLIENTCODE AND AE.MODULECODE = ASREG.MODULECODE AND SC.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE ='%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') AND AE.VERSION ='%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=SC.SIDE INNER JOIN METADATA MDSCOREEVALUATION ON MDSCOREEVALUATION.METASUBCODE=SC.SCOREEVALUATION WHERE   SC.RECORDSTATUS='MSC001'  AND SC.CLIENTCODE='%@' AND SC.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@'AND ASREG.RECORDSTATUS='MSC001')",clientCode,moduleCode,assessmentCode,assessmentTestCode,version,testTypeCode,player,player,assessmentDate,assessmentDate,version,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * Component=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * TestName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * Side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Nooftrials=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * Scoreevaluation=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * UnitsName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    
                    NSString * ScoreevaluationName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    //NSString * SCInference=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, )];
                    NSString * Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString * left=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    
                    NSString * Right=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    
                    NSString * Center=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString * left1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    
                    NSString * Right1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                    
                    NSString * Center1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                    NSString * left2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                    
                    NSString * Right2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                    
                    NSString * Center2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                    NSString * left3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                    
                    NSString * Right3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                    NSString * Center3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                    NSString * left4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                    
                    NSString * Right4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                    
                    NSString * Center4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                    NSString * left5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                    
                    NSString * Right5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                    
                    NSString * Center5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                    NSString * left6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                    
                    NSString * Right6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                    
                    NSString * Center6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                    NSString * left7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];
                    
                    NSString * Right7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)];
                    
                    NSString * Center7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)];
                    NSString * left8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)];
                    
                    NSString * Right8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                    
                    NSString * Center8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)];
                    
                    NSString * left9=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)];
                    
                    NSString * Right9=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)];
                    
                    NSString * Center9=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)];
                    
                    
                    NSString * Version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)];
                    NSString * AssessmentEntryCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)];
                    NSString * Ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)];
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:Component forKey:@"Component"];
                    [dic setObject:TestName forKey:@"TestName"];
                    [dic setObject:Side forKey:@"Side"];
                    [dic setObject:Nooftrials forKey:@"Nooftrials"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Scoreevaluation forKey:@"ScoreEvaluation"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:UnitsName forKey:@"UnitName"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:ScoreevaluationName forKey:@"ScoreEvaluationName"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Ignore"];
                    [dic setObject:left forKey:@"Left"];
                    [dic setObject:Right forKey:@"Right"];
                    [dic setObject:Center forKey:@"Center"];
                    [dic setObject:left1 forKey:@"Left1"];
                    [dic setObject:Right1 forKey:@"Right1"];
                    [dic setObject:Center1 forKey:@"Center1"];
                    [dic setObject:left2 forKey:@"Left2"];
                    [dic setObject:Right2 forKey:@"Right2"];
                    [dic setObject:Center2 forKey:@"Center2"];
                    [dic setObject:left3 forKey:@"Left3"];
                    [dic setObject:Right3 forKey:@"Right3"];
                    [dic setObject:Center3 forKey:@"Center3"];
                    [dic setObject:left4 forKey:@"Left4"];
                    [dic setObject:Right4 forKey:@"Right4"];
                    [dic setObject:Center4 forKey:@"Center4"];
                    [dic setObject:left5 forKey:@"Left5"];
                    [dic setObject:Right5 forKey:@"Right5"];
                    [dic setObject:Center5 forKey:@"Center5"];
                    [dic setObject:left6 forKey:@"Left6"];
                    [dic setObject:Right6 forKey:@"Right6"];
                    [dic setObject:Center6 forKey:@"Center6"];
                    [dic setObject:left7 forKey:@"Left7"];
                    [dic setObject:Right7 forKey:@"Right7"];
                    [dic setObject:Center7 forKey:@"Center7"];
                    [dic setObject:left8 forKey:@"Left8"];
                    [dic setObject:Right8 forKey:@"Right8"];
                    [dic setObject:Center8 forKey:@"Center8"];
                    [dic setObject:left9 forKey:@"Left9"];
                    [dic setObject:Right9 forKey:@"Right9"];
                    [dic setObject:Center9 forKey:@"Center9"];
                    [dic setObject:@"" forKey:@"Version"];
                    [dic setObject:@"" forKey:@"AssessmentEntryCode"];
                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getSCWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  SC.CLIENTCODE,SC.TESTCODE,SC.COMPONENT,SC.TESTNAME,SC.SIDE,SC.NOOFTRIALS,SC.UNITS,SC.SCOREEVALUATION,SC.RECORDSTATUS,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,SC.CREATEDBY,SC.CREATEDDATE,SC.MODIFIEDBY,SC.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDSCOREEVALUATION.METASUBCODEDESCRIPTION AS SCOREEVALUATIONNAME,'' as [INFERENCE],'' as REMARKS,'' AS TRIAL1,'' AS TRIAL2,'' AS TRIAL3,'' AS TRIAL4,'' AS TRIAL5,'' AS TRIAL6,'' AS TRIAL7,'' AS TRIAL8,'' AS TRIAL9,ASREG.VERSION FROM TESTSC SC INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=SC.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=SC.TESTCODE AND VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=SC.SIDE INNER JOIN METADATA MDSCOREEVALUATION ON MDSCOREEVALUATION.METASUBCODE=SC.SCOREEVALUATION INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=SC.UNITS WHERE   SC.RECORDSTATUS='MSC001'  AND SC.CLIENTCODE='%@'  AND ASREG.ASSESSMENTTESTCODE='%@' AND SC.TESTCODE = '%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * Component=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * TestName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * Side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Nooftrials=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * Scoreevaluation=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * UnitsName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * ScoreevaluationName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:Component forKey:@"Component"];
                    [dic setObject:TestName forKey:@"TestName"];
                    [dic setObject:Side forKey:@"Side"];
                    [dic setObject:Nooftrials forKey:@"Nooftrials"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Scoreevaluation forKey:@"ScoreEvaluation"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:UnitsName forKey:@"UnitsName"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:ScoreevaluationName forKey:@"ScoreEvaluationName"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Ignore"];
                    [dic setObject:@"0" forKey:@"Left"];
                    [dic setObject:@"0" forKey:@"Right"];
                    [dic setObject:@"0" forKey:@"Center"];
                    [dic setObject:@"0" forKey:@"Left1"];
                    [dic setObject:@"0" forKey:@"Right1"];
                    [dic setObject:@"0" forKey:@"Center1"];
                    [dic setObject:@"0" forKey:@"Left2"];
                    [dic setObject:@"0" forKey:@"Right2"];
                    [dic setObject:@"0" forKey:@"Center2"];
                    [dic setObject:@"0" forKey:@"Left3"];
                    [dic setObject:@"0" forKey:@"Right3"];
                    [dic setObject:@"0" forKey:@"Center3"];
                    [dic setObject:@"0" forKey:@"Left4"];
                    [dic setObject:@"0" forKey:@"Right4"];
                    [dic setObject:@"0" forKey:@"Center4"];
                    [dic setObject:@"0" forKey:@"Left5"];
                    [dic setObject:@"0" forKey:@"Right5"];
                    [dic setObject:@"0" forKey:@"Center5"];
                    [dic setObject:@"0" forKey:@"Left6"];
                    [dic setObject:@"0" forKey:@"Right6"];
                    [dic setObject:@"0" forKey:@"Center6"];
                    [dic setObject:@"0" forKey:@"Left7"];
                    [dic setObject:@"0" forKey:@"Right7"];
                    [dic setObject:@"0" forKey:@"Center7"];
                    [dic setObject:@"0" forKey:@"Left8"];
                    [dic setObject:@"0" forKey:@"Right8"];
                    [dic setObject:@"0" forKey:@"Center8"];
                    [dic setObject:@"0" forKey:@"Left9"];
                    [dic setObject:@"0" forKey:@"Right9"];
                    [dic setObject:@"0" forKey:@"Center9"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *) getPositiveNegative
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  METASUBCODE AS RESULT,METASUBCODEDESCRIPTION AS RESULTNAME FROM    METADATA WHERE   METADATATYPECODE='MDT004' AND METASUBCODE IN ('MSC016','MSC017')"];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    [dic setObject:setTeamCode forKey:@"Result"];
                    [dic setObject:setTeamName forKey:@"ResultName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *) getWithMmtCombo
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  METASUBCODE AS RESULT,METASUBCODEDESCRIPTION AS RESULTNAME FROM    METADATA WHERE   METADATATYPECODE='MDT056'"];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                    
                    [dic setObject:setTeamCode forKey:@"Result"];
                    [dic setObject:setTeamName forKey:@"ResultName"];

                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getMMTWithEnrty:(NSString *) version:(NSString *) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString *)  player:(NSString *) assessmentDate:(NSString *) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  MMT.CLIENTCODE,MMT.TESTCODE,MMT.JOINT,MMT.MOTION,MMT.MUSCLE,MMT.SIDE,MMT.RESULT,MMT.RECORDSTATUS,MMT.CREATEDBY,MMT.CREATEDDATE,MMT.MODIFIEDBY,MMT.MODIFIEDDATE,AE.INFERENCE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,AE.[LEFT],AE.[RIGHT],AE.[CENTRAL],AE.REMARKS,AE.VERSION      ,AE.ASSESSMENTENTRYCODE ,AE.IGNORED FROM    TESTMMT MMT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@'  AND ASREG.CREATEDBY = '%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND   AE.ASSESSMENTTESTTYPECODE = '%@' AND AE.CLIENTCODE = ASREG.CLIENTCODE AND AE.MODULECODE = ASREG.MODULECODE AND MMT.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') AND AE.VERSION ='%@' AND AE.CREATEDBY = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=MMT.SIDE INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=MMT.RESULT WHERE MMT.RECORDSTATUS='MSC001'  AND MMT.CLIENTCODE='%@' AND MMT.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.CREATEDBY = '%@')",clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy,testTypeCode,player,player,assessmentDate,assessmentDate,version,createdBy,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * MmtJoint=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * MmtMotion=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * MmtMuscle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * MmtSide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * MmtResult=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * MmtSideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * MmtResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * MmtLeft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString * MmtRight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString * MmtCenter=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString * Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * Version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString * AssessmentEntryCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString * Ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:MmtJoint forKey:@"Joint"];
                    [dic setObject:MmtMotion forKey:@"Motion"];
                    [dic setObject:MmtMuscle forKey:@"Muscle"];
                    [dic setObject:MmtSide forKey:@"Side"];
                    [dic setObject:MmtResult forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:MmtSideName forKey:@"SideName"];
                    [dic setObject:MmtResultName forKey:@"ResultName"];
                    [dic setObject:MmtLeft forKey:@"Left"];
                    [dic setObject:MmtRight forKey:@"Right"];
                    [dic setObject:MmtCenter forKey:@"Center"];
                    
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:Ignored forKey:@"Ignore"];

                    [dic setObject:Version forKey:@"Version"];
                    [dic setObject:AssessmentEntryCode forKey:@"AssessmentEntryCode"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getMMTWithoutEnrty:(NSString *) version:(NSString *) moduleCode:(NSString *) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  MMT.CLIENTCODE,MMT.TESTCODE,MMT.JOINT,MMT.MOTION,MMT.MUSCLE,MMT.SIDE,MMT.RESULT,MMT.RECORDSTATUS,MMT.CREATEDBY,MMT.CREATEDDATE,MMT.MODIFIEDBY,MMT.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,'' as [LEFT],'' as [RIGHT],'' as [CENTRAL],'' as REMARKS,'' as [INFERENCE],ASREG.VERSION FROM    TESTMMT MMT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=MMT.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=MMT.TESTCODE AND VERSION ='%@' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=MMT.SIDE INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=MMT.RESULT WHERE MMT.RECORDSTATUS='MSC001'  AND MMT.CLIENTCODE='%@'  AND ASREG.ASSESSMENTTESTCODE='%@' AND MMT.TESTCODE = '%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * MmtJoint=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * MmtMotion=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * MmtMuscle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * MmtSide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * MmtResult=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * MmtSideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * MmtResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    
                    
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:MmtJoint forKey:@"Joint"];
                    [dic setObject:MmtMotion forKey:@"Motion"];
                    [dic setObject:MmtMuscle forKey:@"Muscle"];
                    [dic setObject:MmtSide forKey:@"Side"];
                    [dic setObject:MmtResult forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:MmtSideName forKey:@"SideName"];
                    [dic setObject:MmtResultName forKey:@"ResultName"];
                    [dic setObject:@"" forKey:@"Left"];
                    [dic setObject:@"" forKey:@"Right"];
                    [dic setObject:@"" forKey:@"Center"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Version"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:@"" forKey:@"Ignore"];

                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getGaintWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  GAINT.CLIENTCODE,GAINT.TESTCODE,GAINT.PLANE,GAINT.TESTNAME,GAINT.SIDE,GAINT.UNITS,GAINT.RESULT,GAINT.RECORDSTATUS,GAINT.CREATEDBY,GAINT.CREATEDDATE,AE.INFERENCE,GAINT.MODIFIEDBY,GAINT.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,AE.[LEFT],AE.[RIGHT],AE.[CENTRAL],AE.REMARKS,AE.VALUE,AE.VERSION      ,AE.ASSESSMENTENTRYCODE,AE.IGNORED FROM TESTGAINT GAINT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND  ASREG.CREATEDBY = '%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND AE.CLIENTCODE = ASREG.CLIENTCODE  AND AE.CREATEDBY = ASREG.CREATEDBY    AND   AE.ASSESSMENTTESTTYPECODE = '%@' AND AE.MODULECODE = ASREG.MODULECODE AND GAINT.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') AND AE.VERSION ='%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=GAINT.SIDE INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=GAINT.UNITS INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=GAINT.RESULT WHERE   GAINT.RECORDSTATUS='MSC001' AND GAINT.CLIENTCODE='%@' AND GAINT.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.CREATEDBY = '%@')",clientCode,moduleCode,createdBy,assessmentCode,assessmentTestCode,version,testTypeCode,player,player,assessmentDate,assessmentDate,version,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * clientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * Plane=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * TestName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * UnitName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * ResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString * ResultLeft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString * ResultRight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString * ResultCenter=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * ResultRemarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString * ResultValues=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString * Version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    NSString * AssessmentEntryCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                    NSString * Ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                    
                    [dic setObject:clientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:Plane forKey:@"Plane"];
                    [dic setObject:TestName forKey:@"TestName"];
                    [dic setObject:side forKey:@"side"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Result forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:UnitName forKey:@"UnitName"];
                    [dic setObject:ResultName forKey:@"ResultName"];
                    [dic setObject:ResultLeft forKey:@"Left"];
                    [dic setObject:ResultRight forKey:@"Right"];
                    [dic setObject:ResultCenter forKey:@"Center"];
                    [dic setObject:ResultRemarks forKey:@"Remarks"];
                    [dic setObject:ResultValues forKey:@"Values"];
                    [dic setObject:Version forKey:@"Version"];
                    [dic setObject:AssessmentEntryCode forKey:@"AssessmentEntryCode"];
                    [dic setObject:Ignored forKey:@"Ignore"];
                    [dic setObject:@"" forKey:@"Inference"];
                    
                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray*) getGaintWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:( NSString *) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  GAINT.CLIENTCODE,GAINT.TESTCODE,GAINT.PLANE,GAINT.TESTNAME,GAINT.SIDE,GAINT.UNITS,GAINT.RESULT,GAINT.RECORDSTATUS,GAINT.CREATEDBY,GAINT.CREATEDDATE,GAINT.MODIFIEDBY,GAINT.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,'' as [LEFT],'' as [RIGHT],'' as [CENTRAL],'' as REMARKS,'' AS VALUE,'' as [INFERENCE],ASREG.VERSION FROM    TESTGAINT GAINT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=GAINT.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=GAINT.TESTCODE AND VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=GAINT.SIDE INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=GAINT.UNITS INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=GAINT.RESULT WHERE   GAINT.RECORDSTATUS='MSC001' AND GAINT.CLIENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND GAINT.TESTCODE = '%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * clientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * Plane=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * TestName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * UnitName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * ResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    
                    
                    [dic setObject:clientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:Plane forKey:@"Plane"];
                    [dic setObject:TestName forKey:@"TestName"];
                    [dic setObject:side forKey:@"side"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Result forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:UnitName forKey:@"UnitName"];
                    [dic setObject:ResultName forKey:@"ResultName"];
                    [dic setObject:@"" forKey:@"Left"];
                    [dic setObject:@"" forKey:@"Right"];
                    [dic setObject:@"" forKey:@"Center"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Values"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [dic setObject:@"" forKey:@"Ignore"];
                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *)getResultCombo

{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  METASUBCODE AS RESULT,METASUBCODEDESCRIPTION AS RESULTNAME FROM    METADATA WHERE   METADATATYPECODE='MDT004' AND METASUBCODE BETWEEN 'MSC016' AND 'MSC021'"];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    [dic setObject:setTeamCode forKey:@"Result"];
                    [dic setObject:setTeamName forKey:@"ResultName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *) getwithPostureRESULTS
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  METASUBCODE AS RESULT,UPPER(METASUBCODEDESCRIPTION) AS RESULTNAME FROM   METADATA WHERE   METADATATYPECODE='MDT004' AND((METASUBCODE BETWEEN 'MSC009' AND  'MSC015')  OR(METASUBCODE BETWEEN 'MSC382' AND  'MSC397')) "];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *    setTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString *    setTeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    [dic setObject:setTeamCode forKey:@"Result"];
                    [dic setObject:setTeamName forKey:@"ResultName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getPostureWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  POSTURE.CLIENTCODE,POSTURE.TESTCODE,POSTURE.[VIEW],POSTURE.REGION,POSTURE.SIDE,POSTURE.UNITS,POSTURE.RESULT,POSTURE.RECORDSTATUS,POSTURE.CREATEDBY,POSTURE.CREATEDDATE,POSTURE.MODIFIEDBY,POSTURE.MODIFIEDDATE,AE.[LEFT],AE.[RIGHT],AE.[CENTRAL],AE.REMARKS,AE.VALUE  , AE.INFERENCE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,AE.VERSION       ,AE.ASSESSMENTENTRYCODE ,AE.IGNORED FROM TESTPOSTURE POSTURE INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@'  AND ASREG.CREATEDBY = '%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTTYPECODE = '%@'   AND AE.CLIENTCODE = ASREG.CLIENTCODE AND AE.MODULECODE = ASREG.MODULECODE    AND AE.CREATEDBY =  ASREG.CREATEDBY AND POSTURE.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') AND AE.VERSION ='%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=POSTURE.SIDE INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=POSTURE.UNITS INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=POSTURE.RESULT WHERE POSTURE.RECORDSTATUS='MSC001' AND POSTURE.CLIENTCODE='%@' AND POSTURE.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.CREATEDBY ='%@')",clientCode,moduleCode,createdBy,assessmentCode,assessmentTestCode,version,testTypeCode,player,player,assessmentDate,assessmentDate,version,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * View=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * Region=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * Side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * ResultLeft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString * ResultRight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * ResultCenter=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString * Values=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * UnitsName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString * ResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString * Version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    NSString * AssessmentEntryCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                    NSString * Ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:View forKey:@"View"];
                    [dic setObject:Region forKey:@"Region"];
                    [dic setObject:Side forKey:@"Side"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Result forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:ResultLeft forKey:@"Left"];
                    [dic setObject:ResultRight forKey:@"Right"];
                    [dic setObject:ResultCenter forKey:@"Center"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:Values forKey:@"Values"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:UnitsName forKey:@"UnitName"];
                    [dic setObject:ResultName forKey:@"ResultName"];
                    
                    [dic setObject:Version forKey:@"Version"];
                    [dic setObject:AssessmentEntryCode forKey:@"AssessmentEntryCode"];
                    
                    [dic setObject:Ignored forKey:@"Ignore"];
                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getPostureWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  POSTURE.CLIENTCODE,POSTURE.TESTCODE,POSTURE.[VIEW],POSTURE.REGION,POSTURE.SIDE,POSTURE.UNITS,POSTURE.RESULT,POSTURE.RECORDSTATUS,POSTURE.CREATEDBY,POSTURE.CREATEDDATE,POSTURE.MODIFIEDBY,POSTURE.MODIFIEDDATE,'' as [LEFT],'' as [RIGHT],'' as [CENTRAL],'' as REMARKS,'' AS VALUE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDUNITS.METASUBCODEDESCRIPTION AS UNITSNAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME ,ASREG.VERSION,'' as [INFERENCE] FROM    TESTPOSTURE POSTURE INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=POSTURE.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=POSTURE.TESTCODE AND VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=POSTURE.SIDE INNER JOIN METADATA MDUNITS ON MDUNITS.METASUBCODE=POSTURE.UNITS INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=POSTURE.RESULT WHERE   POSTURE.RECORDSTATUS='MSC001' AND POSTURE.CLIENTCODE='%@'  AND ASREG.ASSESSMENTTESTCODE='%@' AND POSTURE.TESTCODE ='%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString * TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * View=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * Region=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * Side=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString * Units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * Result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * CreatedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * ModifiedDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * SideName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString * UnitsName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * ResultName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    
                    
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:View forKey:@"View"];
                    [dic setObject:Region forKey:@"Region"];
                    [dic setObject:Side forKey:@"Side"];
                    [dic setObject:Units forKey:@"Unit"];
                    [dic setObject:Result forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:@"" forKey:@"Left"];
                    [dic setObject:@"" forKey:@"Right"];
                    [dic setObject:@"" forKey:@"Center"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Values"];
                    [dic setObject:SideName forKey:@"SideName"];
                    [dic setObject:UnitsName forKey:@"UnitName"];
                    [dic setObject:ResultName forKey:@"ResultName"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray*) getTestCoachWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString *) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  DISTINCT TC.CLIENTCODE,KPI,TC.RECORDSTATUS,AE.INFERENCE,TC.CREATEDBY,TC.MODIFIEDBY,AE.[DESCRIPTION],AE.REMARKS,AE.VERSION      ,AE.ASSESSMENTENTRYCODE ,AE.IGNORED FROM    TESTCOACHING TC INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@'  AND ASREG.CREATEDBY = '%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND  AE.ASSESSMENTTESTTYPECODE = '%@' AND AE.CLIENTCODE = ASREG.CLIENTCODE AND AE.MODULECODE = ASREG.MODULECODE  AND AE.CREATEDBY = ASREG.CREATEDBY AND TC.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND AE.VERSION ='%@' AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') WHERE   TC.RECORDSTATUS='MSC001' AND TC.CLIENTCODE='%@' AND TC.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.CREATEDBY = '%@')",clientCode,moduleCode,assessmentCode,assessmentTestCode,createdBy,version,testTypeCode,player,player,version,assessmentDate,assessmentDate,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *  ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *  Kpi=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString *  RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString *  CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString *  ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString *  Description=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString *  Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString *  Version=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString *  AssessmentEntryCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString *  Ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:Kpi forKey:@"Kpi"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:Description forKey:@"Description"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:Version forKey:@"Version"];
                    [dic setObject:AssessmentEntryCode forKey:@"AssessmentEntryCode"];
                    [dic setObject:Ignored forKey:@"Ignore"];
                    [dic setObject:@"" forKey:@"Inference"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *) getTestCoachWithoutEnrty:(NSString *) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  DISTINCT TESTCOACHING.CLIENTCODE,KPI,TESTCOACHING.RECORDSTATUS,TESTCOACHING.CREATEDBY,TESTCOACHING.MODIFIEDBY, '' as [DESCRIPTION],'' as [REMARKS],ASREG.VERSION,'' as [INFERENCE] FROM    TESTCOACHING INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=TESTCOACHING.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=TESTCOACHING.TESTCODE AND VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' WHERE   TESTCOACHING.RECORDSTATUS='MSC001' AND TESTCOACHING.CLIENTCODE='%@'  AND ASREG.ASSESSMENTTESTCODE='%@' AND TESTCOACHING.TESTCODE = '%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *  ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSString *  Kpi=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString *  RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString *  CreatedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString *  ModifiedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:Kpi forKey:@"Kpi"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:@"" forKey:@"Description"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Inference"];
                    
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

#pragma MARK Assessment Insert

-(BOOL)updateAssessmentEntry:(NSDictionary *)dict
{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
//            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTENTRY SET  Clientcode='%@',Modulecode='%@' ,Assessmentcode='%@' ,Assessmenttestcode='%@' ,Assessmenttesttypecode='%@' ,Assessmenttesttypescreencode='%@' ,Version ='%@',Assessor ='%@',Playercode='%@' ,Assessmententrydate='%@' ,Left='%@' ,Right='%@' ,Central='%@' ,Value='%@' ,Remarks='%@' ,Inference='%@' ,Units='%@' ,Description='%@' ,Recordstatus='%@' ,Createdby='%@' ,Createddate='%@' ,Modifiedby='%@' ,Modifieddate='%@' ,Ignored='%@' ,Left1='%@' ,Right1='%@' ,Central1='%@' ,Left2='%@' ,Right2='%@' ,Central2='%@' ,Left3='%@' ,Right3='%@' ,Central3='%@' ,Left4='%@' ,Right4='%@' ,Central4='%@' ,Left5='%@' ,Right5='%@' ,Central5='%@' ,Left6='%@' ,Right6='%@' ,Central6='%@' ,Left7='%@' ,Right7='%@' ,Central7='%@' ,Left8='%@' ,Right8='%@' ,Central8='%@' ,Left9='%@' ,Right9='%@' ,Central9='%@',issync='%@'",Clientcode,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync];
            
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTENTRY SET  Clientcode='%@',Modulecode='%@' ,Assessmentcode='%@' ,Assessmenttestcode='%@' ,Assessmenttesttypecode='%@' ,Assessmenttesttypescreencode='%@' ,Version ='%@',Assessor ='%@',Playercode='%@' ,Assessmententrydate='%@' ,Left='%@' ,Right='%@' ,Central='%@' ,Value='%@' ,Remarks='%@' ,Inference='%@' ,Units='%@' ,Description='%@' ,Recordstatus='%@' ,Createdby='%@' ,Createddate='%@' ,Modifiedby='%@' ,Modifieddate='%@' ,Ignored='%@' ,Left1='%@' ,Right1='%@' ,Central1='%@' ,Left2='%@' ,Right2='%@' ,Central2='%@' ,Left3='%@' ,Right3='%@' ,Central3='%@' ,Left4='%@' ,Right4='%@' ,Central4='%@' ,Left5='%@' ,Right5='%@' ,Central5='%@' ,Left6='%@' ,Right6='%@' ,Central6='%@' ,Left7='%@' ,Right7='%@' ,Central7='%@' ,Left8='%@' ,Right8='%@' ,Central8='%@' ,Left9='%@' ,Right9='%@' ,Central9='%@',issync='%@' WHERE ASSESSMENTENTRYCODE = '%@' ",dict[@"Clientcode"],dict[@"Modulecode"] ,dict[@"Assessmentcode"] ,dict[@"Assessmenttestcode"] ,dict[@"Assessmenttesttypecode"] ,dict[@"Assessmenttesttypescreencode"] ,dict[@"Version"] ,dict[@"Assessor"] ,dict[@"Playercode"] ,dict[@"Assessmententrydate"] ,dict[@"Left"] ,dict[@"Right"] ,dict[@"Centeral"] ,dict[@"Value"] ,dict[@"Remarks"] ,dict[@"inference"] ,dict[@"Units"] ,dict[@"Description"] ,dict[@"Recordstatus"] ,dict[@"Createdby"] ,dict[@"Createddate"] ,dict[@"Modifiedby"] ,dict[@"Modifieddate"] ,dict[@"isIgnored"] ,dict[@"Left1"] ,dict[@"Right1"] ,dict[@"Central1"] ,dict[@"Left2"] ,dict[@"Right2"] ,dict[@"Central2"] ,dict[@"Left3"] ,dict[@"Right3"] ,dict[@"Central3"] ,dict[@"Left4"] ,dict[@"Right4"] ,dict[@"Central4"] ,dict[@"Left5"] ,dict[@"Right5"] ,dict[@"Central5"] ,dict[@"Left6"] ,dict[@"Right6"] ,dict[@"Central6"] ,dict[@"Left7"] ,dict[@"Right7"] ,dict[@"Central7"] ,dict[@"Left8"] ,dict[@"Right8"] ,dict[@"Central8"] ,dict[@"Left9"] ,dict[@"Right9"] ,dict[@"Central9"],dict[@"issync"],dict[@"AssessmentEntrycode"]];


            
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            }
            
            NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            
            sqlite3_close(dataBase);
        }
        return NO;
    }

}


-(BOOL) UPDATEAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSNumber*) Left:(NSString*) Right:(NSString*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync
{
    
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTENTRY SET  Clientcode='%@',Modulecode='%@' ,Assessmentcode='%@' ,Assessmenttestcode='%@' ,Assessmenttesttypecode='%@' ,Assessmenttesttypescreencode='%@' ,Version ='%@',Assessor ='%@',Playercode='%@' ,Assessmententrydate='%@' ,Left='%@' ,Right='%@' ,Central='%@' ,Value='%@' ,Remarks='%@' ,Inference='%@' ,Units='%@' ,Description='%@' ,Recordstatus='%@' ,Createdby='%@' ,Createddate='%@' ,Modifiedby='%@' ,Modifieddate='%@' ,Ignored='%@' ,Left1='%@' ,Right1='%@' ,Central1='%@' ,Left2='%@' ,Right2='%@' ,Central2='%@' ,Left3='%@' ,Right3='%@' ,Central3='%@' ,Left4='%@' ,Right4='%@' ,Central4='%@' ,Left5='%@' ,Right5='%@' ,Central5='%@' ,Left6='%@' ,Right6='%@' ,Central6='%@' ,Left7='%@' ,Right7='%@' ,Central7='%@' ,Left8='%@' ,Right8='%@' ,Central8='%@' ,Left9='%@' ,Right9='%@' ,Central9='%@',issync='%@'",Clientcode,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync];
            
            
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            }
            
            NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}


-(BOOL)insertAssessmentEntry:(NSDictionary *)dict
{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
//            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTENTRY(Clientcode  ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,Ignored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync];

NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTENTRY(Clientcode  ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,Ignored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dict[@"Clientcode"],dict[@"Modulecode"] ,dict[@"Assessmentcode"] ,dict[@"Assessmenttestcode"] ,dict[@"Assessmenttesttypecode"] ,dict[@"Assessmenttesttypescreencode"] ,dict[@"Version"] ,dict[@"Assessor"] ,dict[@"Playercode"] ,dict[@"Assessmententrydate"] ,dict[@"Left"] ,dict[@"Right"] ,dict[@"Centeral"] ,dict[@"Value"] ,dict[@"Remarks"] ,dict[@"inference"] ,dict[@"Units"] ,dict[@"Description"] ,dict[@"Recordstatus"] ,dict[@"Createdby"] ,dict[@"Createddate"] ,dict[@"Modifiedby"] ,dict[@"Modifieddate"] ,dict[@"isIgnored"] ,dict[@"Left1"] ,dict[@"Right1"] ,dict[@"Central1"] ,dict[@"Left2"] ,dict[@"Right2"] ,dict[@"Central2"] ,dict[@"Left3"] ,dict[@"Right3"] ,dict[@"Central3"] ,dict[@"Left4"] ,dict[@"Right4"] ,dict[@"Central4"] ,dict[@"Left5"] ,dict[@"Right5"] ,dict[@"Central5"] ,dict[@"Left6"] ,dict[@"Right6"] ,dict[@"Central6"] ,dict[@"Left7"] ,dict[@"Right7"] ,dict[@"Central7"] ,dict[@"Left8"] ,dict[@"Right8"] ,dict[@"Central8"] ,dict[@"Left9"] ,dict[@"Right9"] ,dict[@"Central9"],dict[@"issync"]];

            const char *update_stmt = [INSERTSQL UTF8String];
            if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;

                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            }

            NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));

            sqlite3_close(dataBase);
        }
        return NO;
    }

    
}
-(BOOL) INSERTAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSNumber*) Left:(NSString*) Right:(NSString*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync {
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTENTRY(Clientcode  ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,Ignored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync];
            
            const char *update_stmt = [INSERTSQL UTF8String];
            if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                    
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            }
            
            NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}
-(NSMutableArray *)getAssessmentEnrtyByDateTestType:(NSString *) assessmentCode:(NSString *) userCode:(NSString *) moduleCode :(NSString *) date:(NSString *) clientCode:(NSString *) testTypeCode:(NSString *) testCode
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query1=[NSString stringWithFormat:@"SELECT  * FROM ASSESSMENTENTRY WHERE ASSESSMENTCODE = '%@' AND CREATEDBY = '%@' AND DATE(ASSESSMENTENTRYDATE) = DATE('%@') AND ASSESSMENTTESTTYPECODE = '%@' AND ASSESSMENTTESTCODE = '%@' AND MODULECODE = '%@' AND CLIENTCODE = '%@' AND RECORDSTATUS = 'MSC001'",assessmentCode,userCode,date,testTypeCode,testCode,moduleCode,clientCode];
            
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTENTRY WHERE ASSESSMENTCODE = '%@' AND CREATEDBY = '%@' AND ASSESSMENTENTRYDATE = '%@' AND ASSESSMENTTESTTYPECODE = '%@' AND ASSESSMENTTESTCODE = '%@' AND MODULECODE = '%@' AND CLIENTCODE = '%@' AND RECORDSTATUS = 'MSC001'",assessmentCode,userCode,date,testTypeCode,testCode,moduleCode,clientCode];

            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * AssessmentCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                    NSString * playerCode   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString *    Remarks=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)];
                    NSString *    Inference=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                    NSString *    ignored=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)];

                    [dic setObject:AssessmentCode forKey:@"AssessmentEntryCode"];
                    [dic setObject:playerCode forKey:@"playerCode"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:Inference forKey:@"Inference"];
                    [dic setObject:ignored forKey:@"ignored"];

                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *) getSpecWithEnrty:(NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode: (NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode {
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  SPEC.CLIENTCODE,SPEC.TESTCODE,SPEC.REGION,SPEC.TESTNAME,SPEC.SIDE,SPEC.RESULT,SPEC.RECORDSTATUS,SPEC.CREATEDBY,SPEC.CREATEDDATE,SPEC.MODIFIEDBY,SPEC.MODIFIEDDATE,        MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,AE.INFERENCE,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,                      AE.[LEFT],AE.[RIGHT],AE.[CENTRAL],AE.REMARKS,AE.VERSION      ,AE.ASSESSMENTENTRYCODE,AE.IGNORED    FROM TESTSPECIAL SPEC INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=SPEC.SIDE                         INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=SPEC.RESULT INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@'   AND ASREG.CREATEDBY = '%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' INNER JOIN ASSESSMENTENTRY AE ON AE.ASSESSMENTTESTTYPECODE = ASREG.ASSESSMENTTESTTYPECODE AND        AE.ASSESSMENTTESTTYPECODE = '%@' AND AE.CLIENTCODE = ASREG.CLIENTCODE AND AE.MODULECODE = ASREG.MODULECODE AND SPEC.TESTCODE=AE.ASSESSMENTTESTTYPECODE AND AE.CREATEDBY = ASREG.CREATEDBY AND AE.ASSESSMENTTESTCODE = ASREG.ASSESSMENTTESTCODE AND ('%@' = '' OR AE.PLAYERCODE = '%@') AND ('%@' = '' OR  AE.ASSESSMENTENTRYDATE = '%@') AND AE.VERSION ='%@' WHERE SPEC.RECORDSTATUS='MSC001' AND SPEC.CLIENTCODE='%@' AND SPEC.TESTCODE IN (SELECT  ASSESSMENTTESTTYPECODE FROM    ASSESSMENTREGISTER ASREG WHERE  ASREG.CLIENTCODE='%@' AND ASREG.MODULECODE='%@' AND ASREG.ASSESSMENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND ASREG.VERSION = '%@'  AND ASREG.CREATEDBY = '%@' AND ASREG.RECORDSTATUS='MSC001')",clientCode,moduleCode,assessmentCode,createdBy,assessmentTestCode,version,testTypeCode,player,player,assessmentDate,assessmentDate,version,clientCode,clientCode,moduleCode,assessmentCode,assessmentTestCode,version,createdBy];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString * TestCode   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * SpecialRegion   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * SpecialTestName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * SpecialSide   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                    NSString * SpecialResult   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * RecordStatus   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * CreatedBy   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedDate   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * ModifiedBy   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedDate   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * SpecialSideName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * SpecialResultName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString * SpecialResultLeft   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString * SpecialResultRight   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString * SpecialResultCenter   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString * Remarks   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString * Version   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString * AssessmentEntryCode   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString * Ignored   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:SpecialRegion forKey:@"Region"];
                    [dic setObject:SpecialTestName forKey:@"TestName"];
                    [dic setObject:SpecialSide forKey:@"Side"];
                    [dic setObject:SpecialResult forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SpecialSideName forKey:@"SideName"];
                    [dic setObject:SpecialResultName forKey:@"ResultName"];
                    [dic setObject:SpecialResultLeft forKey:@"Left"];
                    [dic setObject:SpecialResultRight forKey:@"Right"];
                    [dic setObject:SpecialResultCenter forKey:@"Center"];
                    [dic setObject:Remarks forKey:@"Remarks"];
                    [dic setObject:Version forKey:@"Version"];
                    [dic setObject:AssessmentEntryCode forKey:@"AssessmentEntryCode"];
                    [dic setObject:Ignored forKey:@"Ignore"];
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}
-(NSMutableArray *)getSpecWithoutEnrty: (NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) testTypeCode {
    
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  SPEC.CLIENTCODE,SPEC.TESTCODE,SPEC.REGION,SPEC.TESTNAME,SPEC.SIDE,SPEC.RESULT,SPEC.RECORDSTATUS,SPEC.CREATEDBY,SPEC.CREATEDDATE,SPEC.MODIFIEDBY,SPEC.MODIFIEDDATE,MDSIDE.METASUBCODEDESCRIPTION AS SIDENAME,MDRESULT.METASUBCODEDESCRIPTION AS RESULTNAME,'' as LEFT,'' as RIGHT,'' as CENTRAL,'' as REMARKS,'' as INFERENCE,ASREG.VERSION FROM    TESTSPECIAL SPEC INNER JOIN  ASSESSMENTREGISTER ASREG ON ASREG.CLIENTCODE=SPEC.CLIENTCODE AND ASREG.ASSESSMENTTESTTYPECODE=SPEC.TESTCODE AND VERSION ='%@' AND ASREG.RECORDSTATUS='MSC001' AND ASREG.ASSESSMENTCODE = '%@' AND ASREG.MODULECODE = '%@' INNER JOIN METADATA MDSIDE ON MDSIDE.METASUBCODE=SPEC.SIDE INNER JOIN METADATA MDRESULT ON MDRESULT.METASUBCODE=SPEC.RESULT WHERE SPEC.RECORDSTATUS='MSC001' AND SPEC.CLIENTCODE='%@' AND ASREG.ASSESSMENTTESTCODE='%@' AND SPEC.TESTCODE = '%@'",version,assessmentCode,moduleCode,clientCode,assessmentTestCode,testTypeCode];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString * ClientCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString * TestCode   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString * SpecialRegion   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    NSString * SpecialTestName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString * SpecialSide   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                    NSString * SpecialResult   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString * RecordStatus   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString * CreatedBy   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString * CreatedDate   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString * ModifiedBy   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString * ModifiedDate   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString * SpecialSideName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString * SpecialResultName   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    
                    
                    [dic setObject:ClientCode forKey:@"ClientCode"];
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:SpecialRegion forKey:@"Region"];
                    [dic setObject:SpecialTestName forKey:@"TestName"];
                    [dic setObject:SpecialSide forKey:@"Side"];
                    [dic setObject:SpecialResult forKey:@"Result"];
                    [dic setObject:RecordStatus forKey:@"RecordStatus"];
                    [dic setObject:CreatedBy forKey:@"CreatedBy"];
                    [dic setObject:CreatedDate forKey:@"CreatedDate"];
                    [dic setObject:ModifiedBy forKey:@"ModifiedBy"];
                    [dic setObject:ModifiedDate forKey:@"ModifiedDate"];
                    [dic setObject:SpecialSideName forKey:@"SideName"];
                    [dic setObject:SpecialResultName forKey:@"ResultName"];
                    [dic setObject:@"" forKey:@"Left"];
                    [dic setObject:@"" forKey:@"Right"];
                    [dic setObject:@"" forKey:@"Center"];
                    [dic setObject:@"" forKey:@"Remarks"];
                    [dic setObject:@"" forKey:@"Inference"];
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

-(NSMutableArray *)getTestcode:(NSString *)kpiStr
{
    @synchronized ([AppCommon syncId])  {
        int retVal;
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([dbPath UTF8String], &dataBase);
        NSMutableArray *assessment = [[NSMutableArray alloc]init];
        if(retVal ==0){
            
            NSString *query=[NSString stringWithFormat:@"SELECT  TESTCODE,DESCRIPTION,KPI FROM  TESTCOACHING  WHERE RECORDSTATUS='MSC001'"];
            
            NSLog(@"%@",query);
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSLog(@"Success");
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    NSString *  TestCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                    NSString *  Description=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString *  kpi=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                    
                    [dic setObject:TestCode forKey:@"TestCode"];
                    [dic setObject:Description forKey:@"Description"];
                    [dic setObject:kpi forKey:@"kpi"];
                    
                    [assessment addObject:dic];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        NSLog(@"%@", assessment);
        
        return assessment;
    }
}

@end
