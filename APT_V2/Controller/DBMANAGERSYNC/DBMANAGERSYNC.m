//
//  DBMANAGERSYNC.m
//  CAPScoringApp
//
//  Created by Lexicon on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBMANAGERSYNC.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "getimageRecord.h"
//#import "Utitliy.h"
#import "Header.h"


@interface DBMANAGERSYNC ()
@end
@implementation DBMANAGERSYNC

static NSString *SQLITE_FILE_NAME = @"agapt_database.sqlite";

static NSString * DBPath;

static DBMANAGERSYNC *sharedMyManager = nil;
static dispatch_once_t onceToken;

+ (id)sharedManager {
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        [self copyDatabaseIfNotExist];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//        NSString *documentsDir = [paths objectAtIndex:0];
//        self.getDBPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
//        NSLog(@"%@", self.getDBPath);
    }
    return self;
}

//Copy database to application document
-(void) copyDatabaseIfNotExist{
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    DBPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    //NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:DBPath];
    NSLog(@"Database path %@ ",DBPath);
    if(!success) {//If file not exist
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:DBPath error:&error];
        
        if (!success)
            NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

//Get database path
-(NSString *) getDBPath
{
//    [self copyDatabaseIfNotExist];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    return DBPath;
}

//- (id)init
//{
//    self = [super init];
//    if (self)
//    {
//        [self copyDatabaseIfNotExist];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//        NSString *documentsDir = [paths objectAtIndex:0];
//        self.getDBPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
//        NSLog(@"%@", self.getDBPath);
//    }
//    return self;
//}
-(void)getdetails
{
    NSLog(@"%@", self.getDBPath);
    
    
    
}

-(BOOL) SELECTASSESSMENT:(NSString *)ASSESSMENTCODE{
    @synchronized ([AppCommon syncId])  {
        
        
        
         NSString *CLIENTCODE = [self.Assmnt objectAtIndex:0];
         NSString *MODULECODE=[self.Assmnt objectAtIndex:1];
         NSString *ASSESEMENTCODE=[self.Assmnt objectAtIndex:2];
         NSString *ASSESSMENTNAME=[self.Assmnt objectAtIndex:3];
         NSString *RECORDSTATUS=[self.Assmnt objectAtIndex:4];
         NSString *CREATEDBY=[self.Assmnt objectAtIndex:5];
         NSString *CREATEDDATE=[self.Assmnt objectAtIndex:6];
         NSString *MODIFIEDBY=[self.Assmnt objectAtIndex:7];
         NSString *MODIFIEDATE=[self.Assmnt objectAtIndex:8];
    
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENT WHERE ASSESSMENTCODE ='%@'",ASSESSMENTCODE];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
    
                    [self UpdateAssessment:CLIENTCODE :MODULECODE :ASSESEMENTCODE :ASSESSMENTNAME:RECORDSTATUS:CREATEDBY :CREATEDDATE :MODIFIEDBY :MODIFIEDATE];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                [self InsertAssessment:CLIENTCODE :MODULECODE :ASSESEMENTCODE :ASSESSMENTNAME:RECORDSTATUS:CREATEDBY :CREATEDDATE :MODIFIEDBY :MODIFIEDATE];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
                        
            sqlite3_close(dataBase);
        }
        return NO;
    }
}


-(BOOL) InsertAssessment:(NSString*) CLIENTCODE:(NSString*) MODULECODE:(NSString*) ASSESEMENTCODE:(NSString*) ASSESSMENTNAME:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY :(NSString*) MODIFIEDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENT(CLIENTCODE,MODULECODE,ASSESSMENTCODE,ASSESSMENTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",CLIENTCODE,MODULECODE,ASSESEMENTCODE,ASSESSMENTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDATE];
            
            
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

-(BOOL) UpdateAssessment:(NSString*) CLIENTCODE:(NSString*) MODULECODE:(NSString*) ASSESEMENTCODE:(NSString*) ASSESSMENTNAME:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY :(NSString*) MODIFIEDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENT SET  CLIENTCODE='%@',MODULECODE='%@',ASSESSMENTCODE='%@',ASSESSMENTNAME='%@',RECORDSTATUS='%@',CREATEDBY='%@', CREATEDDATE='%@',MODIFIEDBY='%@', MODIFIEDDATE='%@' WHERE ASSESSMENTCODE ='%@'",CLIENTCODE,MODULECODE,ASSESEMENTCODE,ASSESSMENTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDATE,ASSESEMENTCODE];
            
            
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


-(BOOL) SELECTASSESSMENTTESTMASTER:(NSString *)TESTCODE{
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *CLIENTCODE = [self.AssmntTestMaster objectAtIndex:0];
        NSString *MODULECODE=[self.AssmntTestMaster objectAtIndex:1];
        NSString *ASSESEMENTCODE=[self.AssmntTestMaster objectAtIndex:2];
        NSString *TESTCODE=[self.AssmntTestMaster objectAtIndex:3];
        NSString *TESTNAME =[self.AssmntTestMaster objectAtIndex:4];
        NSString *RECORDSTATUS=[self.AssmntTestMaster objectAtIndex:5];
        NSString *CREATEDBY=[self.AssmntTestMaster objectAtIndex:6];
        NSString *CREATEDDATE=[self.AssmntTestMaster objectAtIndex:7];
        NSString *MODIFIEDBY=[self.AssmntTestMaster objectAtIndex:8];
        NSString *MODIFIEDATE=[self.AssmntTestMaster objectAtIndex:9];
    
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTTESTMASTER WHERE TESTCODE ='%@'",TESTCODE];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    //[self InsertQuery:CLIENTCODE :MODULECODE :ASSESSMENTCODE :ASSESSMENTNAME :CREATEDBY :CREATEDDATE :MODIFIEDBY :MODIFIEDATE];
                    
                    [self UpdateAssessmentTESTMASTER:CLIENTCODE :MODULECODE :ASSESEMENTCODE :TESTCODE:TESTNAME:RECORDSTATUS:CREATEDBY :CREATEDDATE :MODIFIEDBY :MODIFIEDATE];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                [self InsertAssessmentTESTMASTER:CLIENTCODE :MODULECODE :ASSESEMENTCODE :TESTCODE:TESTNAME:RECORDSTATUS:CREATEDBY :CREATEDDATE :MODIFIEDBY :MODIFIEDATE];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL) InsertAssessmentTESTMASTER:(NSString*) CLIENTCODE:(NSString*) MODULECODE:(NSString*) ASSESEMENTCODE:(NSString*) TESTCODE:(NSString*) TESTNAME:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY :(NSString*) MODIFIEDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTTESTMASTER(CLIENTCODE,MODULECODE,ASSESSMENTCODE,TESTCODE,TESTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",CLIENTCODE,MODULECODE,ASSESEMENTCODE,TESTCODE,TESTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDATE];
            
            NSLog(@"ASSESSMENTTESTMASTER sqlite3_open");

            const char *update_stmt = [INSERTSQL UTF8String];
            if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                NSLog(@"ASSESSMENTTESTMASTER sqlite3_prepare");

                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"ASSESSMENTTESTMASTER INSERT");
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

-(BOOL) UpdateAssessmentTESTMASTER:(NSString*) CLIENTCODE:(NSString*) MODULECODE:(NSString*) ASSESEMENTCODE:(NSString*) TESTCODE:(NSString*) TESTNAME:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY :(NSString*) MODIFIEDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTTESTMASTER SET  CLIENTCODE='%@',MODULECODE='%@',ASSESSMENTCODE='%@',TESTCODE='%@',TESTNAME='%@',RECORDSTATUS='%@',CREATEDBY='%@', CREATEDDATE='%@',MODIFIEDBY='%@', MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",CLIENTCODE,MODULECODE,ASSESEMENTCODE,TESTCODE,TESTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDATE,TESTCODE];
            
            
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






-(BOOL) SELECTRANGEOFMOTION:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {

        NSString * Clientcode =[self.RangeOfMotion objectAtIndex:0];
        NSString * Testcode =[self.RangeOfMotion objectAtIndex:1];
        NSString * Joint =[self.RangeOfMotion objectAtIndex:2];
        NSString * Movement =[self.RangeOfMotion objectAtIndex:3];
        NSString * Side =[self.RangeOfMotion objectAtIndex:4];
        NSString * Minimumrange =[self.RangeOfMotion objectAtIndex:5];
        NSString * Maximumrange = [self.RangeOfMotion objectAtIndex:6];
        NSString * Unit = [self.RangeOfMotion objectAtIndex:7];
        NSString * Inputtype = [self.RangeOfMotion objectAtIndex:8];
        NSString * Recordstatus =[self.RangeOfMotion objectAtIndex:9];
        NSString * Createdby = [self.RangeOfMotion objectAtIndex:10];
        NSString * Createddate =[self.RangeOfMotion objectAtIndex:11];
        NSString * Modifiedby =[self.RangeOfMotion objectAtIndex:12];
        NSString * Modifieddate =[self.RangeOfMotion objectAtIndex:13];
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTRANGEOFMOTION WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    [self UpdateRangeOfMotion:Clientcode :Testcode :Joint :Movement :Side :Minimumrange :Maximumrange :Unit :Inputtype :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertRangeOfMotion:Clientcode :Testcode :Joint :Movement :Side :Minimumrange :Maximumrange :Unit :Inputtype :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}
-(BOOL)InsertRangeOfMotion:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Joint:(NSString*) Movement:(NSString*) Side:(NSString*) Minimumrange:(NSString*) Maximumrange:(NSString*) Unit:(NSString*) Inputtype :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTRANGEOFMOTION(CLIENTCODE,TESTCODE,JOINT,MOVEMENT,SIDE,MINIMUMRANGE,MAXIMUMRANGE,UNIT,INPUTTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Joint,Movement,Side,Minimumrange,Maximumrange,Unit,Inputtype,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
            
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

-(BOOL)UpdateRangeOfMotion:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Joint:(NSString*) Movement:(NSString*) Side:(NSString*) Minimumrange:(NSString*) Maximumrange:(NSString*) Unit:(NSString*) Inputtype :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTRANGEOFMOTION SET  CLIENTCODE='%@',TESTCODE='%@',JOINT='%@',MOVEMENT='%@',SIDE='%@',MINIMUMRANGE='%@',MAXIMUMRANGE='%@', UNIT='%@',INPUTTYPE='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Joint,Movement,Side,Minimumrange,Maximumrange,Unit,Inputtype,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
            
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



-(BOOL) TESTSPECIAL:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString * Clientcode = [self.TestSplArray objectAtIndex:0];
        NSString * Testcode = [self.TestSplArray objectAtIndex:1];
        NSString * Region = [self.TestSplArray objectAtIndex:2];
        NSString * Testname = [self.TestSplArray objectAtIndex:3];
        NSString * Side =  [self.TestSplArray objectAtIndex:4];
        NSString * Result =  [self.TestSplArray objectAtIndex:5];
        NSString * Recordstatus = [self.TestSplArray objectAtIndex:6];
        NSString * Createdby = [self.TestSplArray objectAtIndex:7];
        NSString * Createddate = [self.TestSplArray objectAtIndex:8];
        NSString * Modifiedby = [self.TestSplArray objectAtIndex:9];
        NSString * Modifieddate = [self.TestSplArray objectAtIndex:10];
        
       
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTSPECIAL WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateTESTSPECIAL:Clientcode :Testcode :Region :Testname :Side :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTSPECIAL:Clientcode :Testcode :Region :Testname :Side :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTSPECIAL:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Region:(NSString*) Testname:(NSString*) Side:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTSPECIAL(CLIENTCODE,TESTCODE,REGION,TESTNAME,SIDE,RESULT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Region,Testname,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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

-(BOOL)UpdateTESTSPECIAL:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Region:(NSString*) Testname:(NSString*) Side:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTSPECIAL SET  CLIENTCODE='%@',TESTCODE='%@',REGION='%@',TESTNAME='%@',SIDE='%@',RESULT='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Region,Testname,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
            
            
            
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

-(BOOL) TESTmmt:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        NSString * Clientcode = [self.Testmmt objectAtIndex:0];
        NSString * Testcode = [self.Testmmt objectAtIndex:1];
        NSString * Joint = [self.Testmmt objectAtIndex:2];
        NSString * Motion = [self.Testmmt objectAtIndex:3];
        NSString * Muscle = [self.Testmmt objectAtIndex:4];
        NSString * Side = [self.Testmmt objectAtIndex:5];
        NSString * Result = [self.Testmmt objectAtIndex:6];
        NSString * Recordstatus = [self.Testmmt objectAtIndex:7];
        NSString * Createdby = [self.Testmmt objectAtIndex:8];
        NSString * Createddate = [self.Testmmt objectAtIndex:9];
        NSString * Modifiedby = [self.Testmmt objectAtIndex:10];
        NSString * Modifieddate = [self.Testmmt objectAtIndex:11];
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTMMT WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateTESTmmt:Clientcode :Testcode :Joint :Motion :Muscle :Side :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTmmt:Clientcode :Testcode :Joint :Motion :Muscle :Side :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTmmt:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Joint:(NSString*) Motion:(NSString*) Muscle:(NSString*) Side:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
   
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTMMT(CLIENTCODE,TESTCODE,JOINT,MOTION,MUSCLE,SIDE,RESULT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Joint,Motion,Muscle,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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

-(BOOL)UpdateTESTmmt:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Joint:(NSString*) Motion:(NSString*) Muscle:(NSString*) Side:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTMMT SET  CLIENTCODE='%@',TESTCODE='%@',JOINT='%@',MOTION='%@',MUSCLE='%@',SIDE='%@',RESULT='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Joint,Motion,Muscle,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
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


-(BOOL) SELECTTESTGAINT:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString * Clientcode = [self.TestgaintArray objectAtIndex:0];
        NSString * Testcode = [self.TestgaintArray objectAtIndex:1];
        NSString * Plane = [self.TestgaintArray objectAtIndex:2];
        NSString * Testname = [self.TestgaintArray objectAtIndex:3];
        NSString * Side =[self.TestgaintArray objectAtIndex:4];
        NSString * Units =[self.TestgaintArray objectAtIndex:5];
        NSString * Result =[self.TestgaintArray objectAtIndex:6];
        NSString * Recordstatus =[self.TestgaintArray objectAtIndex:7];
        NSString * Createdby =[self.TestgaintArray objectAtIndex:8];
        NSString * Createddate =[self.TestgaintArray objectAtIndex:9];
        NSString * Modifiedby =[self.TestgaintArray objectAtIndex:10];
        NSString * Modifieddate =[self.TestgaintArray objectAtIndex:11];

        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTGAINT WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateTESTGaint:Clientcode :Testcode :Plane :Testname :Side :Units :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTGaint:Clientcode :Testcode :Plane :Testname :Side :Units :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTGaint:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Plane:(NSString*) Testname:(NSString*) Side:(NSString*) Units:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTGAINT(CLIENTCODE,TESTCODE,PLANE,TESTNAME,SIDE,UNITS,RESULT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Plane,Testname,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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

-(BOOL)UpdateTESTGaint:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Plane:(NSString*) Testname:(NSString*) Side:(NSString*) Units:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
        
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTGAINT SET  CLIENTCODE='%@',TESTCODE='%@',PLANE='%@',TESTNAME='%@',SIDE='%@',UNITS='%@',RESULT='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Plane,Testname,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
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


-(BOOL) SELECTTESTPosture:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString * Clientcode = [self.TestpostureArray objectAtIndex:0];
        NSString * Testcode = [self.TestpostureArray objectAtIndex:1];
        NSString * View = [self.TestpostureArray objectAtIndex:2];
        NSString * Region = [self.TestpostureArray objectAtIndex:3];
        NSString * Side =[self.TestpostureArray objectAtIndex:4];
        NSString * Units =[self.TestpostureArray objectAtIndex:5];
        NSString * Result =[self.TestpostureArray objectAtIndex:6];
        NSString * Recordstatus =[self.TestpostureArray objectAtIndex:7];
        NSString * Createdby =[self.TestpostureArray objectAtIndex:8];
        NSString * Createddate =[self.TestpostureArray objectAtIndex:9];
        NSString * Modifiedby =[self.TestpostureArray objectAtIndex:10];
        NSString * Modifieddate =[self.TestpostureArray objectAtIndex:11];
        
        

        

        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTPOSTURE WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateTESTPOSTURE:Clientcode :Testcode :View :Region :Side :Units :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTPOSTURE:Clientcode :Testcode :View :Region :Side :Units :Result :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTPOSTURE:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) View:(NSString*) Region:(NSString*) Side:(NSString*) Units:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTPOSTURE(CLIENTCODE,TESTCODE,VIEW,REGION,SIDE,UNITS,RESULT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,View,Region,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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

-(BOOL)UpdateTESTPOSTURE:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) View:(NSString*) Region:(NSString*) Side:(NSString*) Units:(NSString*) Result :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTPOSTURE SET  CLIENTCODE='%@',TESTCODE='%@',VIEW='%@',REGION='%@',SIDE='%@',UNITS='%@',RESULT='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,View,Region,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
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




-(BOOL) SELECTTESTSC:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString * Clientcode = [self.TestSCArray objectAtIndex:0];
        NSString * Testcode = [self.TestSCArray objectAtIndex:1];
        NSString * Component = [self.TestSCArray objectAtIndex:2];
        NSString * Testname = [self.TestSCArray objectAtIndex:3];
        NSString * Side =[self.TestSCArray objectAtIndex:4];
        NSString * Nooftrials =[self.TestSCArray objectAtIndex:5];
        NSString * Units =[self.TestSCArray objectAtIndex:6];
        NSString * Scoreevaluation =[self.TestSCArray objectAtIndex:7];
        NSString * Recordstatus =[self.TestSCArray objectAtIndex:8];
        NSString * Createdby =[self.TestSCArray objectAtIndex:9];
        NSString * Createddate =[self.TestSCArray objectAtIndex:10];
        NSString * Modifiedby =[self.TestSCArray objectAtIndex:11];
        NSString * Modifieddate =[self.TestSCArray objectAtIndex:12];
        
       
        
        
        
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTSC WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateTESTSC:Clientcode :Testcode :Component :Testname :Side: Nooftrials :Units :Scoreevaluation :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTSC:Clientcode :Testcode :Component :Testname :Side: Nooftrials :Units :Scoreevaluation :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTSC:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Component:(NSString*) Testname:(NSString*) Side:(NSString*) Nooftrials:(NSString*) Units:(NSString*) Scoreevaluation :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        

        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTSC(CLIENTCODE,TESTCODE,COMPONENT,TESTNAME,SIDE,NOOFTRIALS,UNITS,SCOREEVALUATION,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Component,Testname,Side,Nooftrials,Units,Scoreevaluation,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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

-(BOOL)UpdateTESTSC:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Component:(NSString*) Testname:(NSString*) Side:(NSString*) Nooftrials:(NSString*) Units:(NSString*) Scoreevaluation :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTSC SET  CLIENTCODE='%@',TESTCODE='%@',COMPONENT='%@',TESTNAME='%@',SIDE='%@',NOOFTRIALS='%@',UNITS='%@',SCOREEVALUATION='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Component,Testname,Side,Nooftrials,Units,Scoreevaluation,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
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

-(BOOL) SELECTTESTCoaching:(NSString *)Testcode{
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString * Clientcode = [self.TestCoachArray objectAtIndex:0];
        NSString * Testcode = [self.TestCoachArray objectAtIndex:1];
        NSString * Kpi = [self.TestCoachArray objectAtIndex:2];
        NSString * Description = [self.TestCoachArray objectAtIndex:3];
        NSString * Recordstatus =[self.TestCoachArray objectAtIndex:4];
        NSString * Createdby =[self.TestCoachArray objectAtIndex:5];
        NSString * Createddate =[self.TestCoachArray objectAtIndex:6];
        NSString * Modifiedby =[self.TestCoachArray objectAtIndex:7];
        NSString * Modifieddate =[self.TestCoachArray objectAtIndex:8];
        
        
    
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TESTCOACHING WHERE TESTCODE ='%@'",Testcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateTESTCoaching:Clientcode :Testcode :Kpi :Description :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertTESTCoaching:Clientcode :Testcode :Kpi :Description :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertTESTCoaching:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Kpi:(NSString*) Description :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        

        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTCOACHING(CLIENTCODE,TESTCODE,KPI,DESCRIPTION,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Testcode,Kpi,Description,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateTESTCoaching:(NSString*) Clientcode:(NSString*) Testcode:(NSString*) Kpi:(NSString*) Description :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TESTCOACHING SET  CLIENTCODE='%@',TESTCODE='%@',KPI='%@',DESCRIPTION='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE TESTCODE ='%@'",Clientcode,Testcode,Kpi,Description,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Testcode];
            
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



-(BOOL)SELECTmetadata:(NSString *)Metasubcode{
    @synchronized ([AppCommon syncId])  {
        
    
        
        NSString * Metasubcode =[self.metadataArray objectAtIndex:0];
        NSString * Metadatatypecode =[self.metadataArray objectAtIndex:1];
        NSString * Metadatatypedescription =[self.metadataArray objectAtIndex:2];
        NSString * Metasubcodedescription =[self.metadataArray objectAtIndex:3];
        NSString * Metasubcodevalue =[self.metadataArray objectAtIndex:4];
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM METADATA WHERE METASUBCODE ='%@'",Metasubcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                  [self UpdateMetadata:Metasubcode :Metadatatypecode :Metadatatypedescription :Metasubcodedescription :Metasubcodevalue];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertMetadata:Metasubcode :Metadatatypecode :Metadatatypedescription :Metasubcodedescription :Metasubcodevalue];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertMetadata:(NSString*) Metasubcode:(NSString*) Metadatatypecode:(NSString*) Metadatatypedescription:(NSString*) Metasubcodedescription :(NSString*) Metasubcodevalue   {
    
    
    @synchronized ([AppCommon syncId])  {
    
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO METADATA(METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION,METASUBCODEVALUE)VALUES('%@','%@','%@','%@','%@')",Metasubcode,Metadatatypecode,Metadatatypedescription,Metasubcodedescription,Metasubcodevalue];
            
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
-(BOOL)UpdateMetadata:(NSString*) Metasubcode:(NSString*) Metadatatypecode:(NSString*) Metadatatypedescription:(NSString*) Metasubcodedescription :(NSString*) Metasubcodevalue   {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE METADATA SET  METASUBCODE='%@',METADATATYPECODE='%@',METADATATYPEDESCRIPTION='%@',METASUBCODEDESCRIPTION='%@', METASUBCODEVALUE='%@', WHERE METASUBCODE ='%@'",Metasubcode,Metadatatypecode,Metadatatypedescription,Metasubcodedescription,Metasubcodevalue,Metasubcode];
            
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




-(BOOL) SELECTSportsInfo:(NSString *)Athletecode{
    @synchronized ([AppCommon syncId])  {
        
        
    
        
        
        
        NSString * Clientcode =[self.SportsInfoArray objectAtIndex:0];
        NSString * Athletecode =[self.SportsInfoArray objectAtIndex:1];
        NSString * Height =[self.SportsInfoArray objectAtIndex:2];
        NSString * Weight =[self.SportsInfoArray objectAtIndex:3];
        NSString * Allergies =[self.SportsInfoArray objectAtIndex:4];
        NSString * Orthotics =[self.SportsInfoArray objectAtIndex:5];
        NSString * Recordstatus =[self.SportsInfoArray objectAtIndex:6];
        NSString * Createdby =[self.SportsInfoArray objectAtIndex:7];
        NSString * Createddate =[self.SportsInfoArray objectAtIndex:8];
        NSString * Modifiedby =[self.SportsInfoArray objectAtIndex:9];
        NSString * Modifieddate =[self.SportsInfoArray objectAtIndex:10];
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ATHLETEINFO WHERE ATHLETECODE ='%@'",Athletecode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    [self UpdateSportsInfo:Clientcode :Athletecode :Height :Weight :Allergies:Orthotics:Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertSportsInfo:Clientcode :Athletecode :Height :Weight :Allergies:Orthotics:Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertSportsInfo:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Height:(NSString*) Weight:(NSString*) Allergies:(NSString*) Orthotics :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ATHLETEINFO(CLIENTCODE,ATHLETECODE,HEIGHT,WEIGHT,ALLERGIES,ORTHOTICS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode,Athletecode,Height,Allergies,Weight,Orthotics,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateSportsInfo:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Height:(NSString*) Weight:(NSString*) Allergies:(NSString*) Orthotics :(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ATHLETEINFO SET  CLIENTCODE='%@',ATHLETECODE='%@',HEIGHT='%@',WEIGHT='%@',ALLERGIES='%@',ORTHOTICS='%@', RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE ATHLETECODE ='%@'",Clientcode,Athletecode,Height,Weight,Allergies,Orthotics,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate,Athletecode];
            
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




-(BOOL) SELECTAssementRegister:(NSString *)Assessmentregistercode{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.AssessmentRegisterArray objectAtIndex:0];
        NSString * Assessmentregistercode =[self.AssessmentRegisterArray objectAtIndex:1];
        NSString * Modulecode =[self.AssessmentRegisterArray objectAtIndex:2];
        NSString * Assessmentcode =[self.AssessmentRegisterArray objectAtIndex:3];
        NSString * Assessmenttesttypescreencode = [self.AssessmentRegisterArray objectAtIndex:4];
        NSString * Assessmenttestcode =[self.AssessmentRegisterArray objectAtIndex:5];
        NSString * Assessmenttesttypecode = [self.AssessmentRegisterArray objectAtIndex:6];
        NSString * Version =[self.AssessmentRegisterArray objectAtIndex:7];
        NSString * Recordstatus =[self.AssessmentRegisterArray objectAtIndex:8];
        NSString * Createdby =[self.AssessmentRegisterArray objectAtIndex:9];
        NSString * Createddate =[self.AssessmentRegisterArray objectAtIndex:10];
        NSString * Modifiedby =[self.AssessmentRegisterArray objectAtIndex:11];
        NSString * Modifieddate =[self.AssessmentRegisterArray objectAtIndex:12];
        
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTREGISTER WHERE ASSESSMENTREGISTERCODE ='%@'",Assessmentregistercode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateAssessmentRegister:Clientcode :Assessmentregistercode :Modulecode :Assessmentcode:Assessmenttesttypescreencode :Assessmenttestcode:Assessmenttesttypecode:Version:Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertAssessmentRegister:Clientcode :Assessmentregistercode :Modulecode :Assessmentcode:Assessmenttesttypescreencode :Assessmenttestcode:Assessmenttesttypecode:Version:Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL)InsertAssessmentRegister:(NSString*) Clientcode:(NSString*) Assessmentregistercode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) assessmentTestTypeScreenCode:(NSString*) assessmentTestCode:(NSString*) assessmentTestTypeCode :(NSString*) version:(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTREGISTER(CLIENTCODE,ASSESSMENTREGISTERCODE,MODULECODE,ASSESSMENTCODE,ASSESSMENTTESTTYPESCREENCODE,ASSESSMENTTESTCODE,ASSESSMENTTESTTYPECODE,VERSION,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", Clientcode ,Assessmentregistercode ,Modulecode ,Assessmentcode,assessmentTestTypeScreenCode ,assessmentTestCode,assessmentTestTypeCode,version,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate];
            
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
-(BOOL)UpdateAssessmentRegister:(NSString*) Clientcode:(NSString*) Assessmentregistercode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) assessmentTestTypeScreenCode:(NSString*) assessmentTestCode:(NSString*) assessmentTestTypeCode :(NSString*) version:(NSString*) Recordstatus :(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate  {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTREGISTER SET  CLIENTCODE='%@',ASSESSMENTREGISTERCODE='%@',MODULECODE='%@',ASSESSMENTCODE='%@',ASSESSMENTTESTTYPESCREENCODE='%@',ASSESSMENTTESTCODE='%@',ASSESSMENTTESTTYPECODE='%@', VERSION='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE ASSESSMENTREGISTERCODE ='%@'",Clientcode ,Assessmentregistercode ,Modulecode ,Assessmentcode,assessmentTestTypeScreenCode ,assessmentTestCode,assessmentTestTypeCode,version,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate,Assessmentregistercode];
            NSLog(updateSQL);
            
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

-(BOOL) SELECTAtheleteMemReg:(NSString *)Associationmemberid{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.AtheleteMemRegArray valueForKey:@"Clientcode"];
        NSString * Associationmemberid =[self.AtheleteMemRegArray valueForKey:@"Associationmemberid"];
        NSString * Associationid =[self.AtheleteMemRegArray valueForKey:@"Associationid"];
        NSString * Firstname =[self.AtheleteMemRegArray valueForKey:@"Firstname"];
        NSString * Lastname =[self.AtheleteMemRegArray valueForKey:@"Lastname"];
        NSString * Alicename =[self.AtheleteMemRegArray valueForKey:@"Alicename"];
        NSString * Registrationnumber =[self.AtheleteMemRegArray valueForKey:@"Registrationnumber"];
        NSString * Registrationdate =[self.AtheleteMemRegArray valueForKey:@"Registrationdate"];
        NSString * Gender =[self.AtheleteMemRegArray valueForKey:@"Gender"];
        NSString * Dateofbirth =[self.AtheleteMemRegArray valueForKey:@"Dateofbirth"];
        NSString * Age =[self.AtheleteMemRegArray valueForKey:@"Age"];
        NSString * Group =[self.AtheleteMemRegArray valueForKey:@"Group"];
        NSString * Subgroup =[self.AtheleteMemRegArray valueForKey:@"Subgroup"];
        NSString * Contactactnumberone =[self.AtheleteMemRegArray valueForKey:@"Contactactnumberone"];
        NSString * Contactnumbertwo =[self.AtheleteMemRegArray valueForKey:@"Contactnumbertwo"];
        NSString * Memberphoto =[self.AtheleteMemRegArray valueForKey:@"Memberphoto"];
        NSString * Memberemail =[self.AtheleteMemRegArray valueForKey:@"Memberemail"];
        NSString * Memberaddress =[self.AtheleteMemRegArray valueForKey:@"Memberaddress"];
        NSString * Fathersname =[self.AtheleteMemRegArray valueForKey:@"Fathersname"];
        NSString * Effectivefrom =[self.AtheleteMemRegArray valueForKey:@"Effectivefrom"];
        NSString * Effetiveto =[self.AtheleteMemRegArray valueForKey:@"Effetiveto"];
        NSString * City =[self.AtheleteMemRegArray valueForKey:@"City"];
        NSString * State =[self.AtheleteMemRegArray valueForKey:@"State"];
        NSString * Country =[self.AtheleteMemRegArray valueForKey:@"Country"];
        NSString * Pincode =[self.AtheleteMemRegArray valueForKey:@"Pincode"];
        NSString * Placeofbirth =[self.AtheleteMemRegArray valueForKey:@"Placeofbirth"];
        NSString * Ageproof =[self.AtheleteMemRegArray valueForKey:@"Ageproof"];
        NSString * Identificationmarks =[self.AtheleteMemRegArray valueForKey:@"Identificationmarks"];
        NSString * Biometrics =[self.AtheleteMemRegArray valueForKey:@"Biometrics"];
        NSString * Aadharnumber =[self.AtheleteMemRegArray valueForKey:@"Aadharnumber"];
        NSString * Pannumber =[self.AtheleteMemRegArray valueForKey:@"Pannumber"];
        NSString * Passportnumber =[self.AtheleteMemRegArray valueForKey:@"Passportnumber"];
        NSString * Personalcontactnumber =[self.AtheleteMemRegArray valueForKey:@"Personalcontactnumber"];
        NSString * Personalemailid =[self.AtheleteMemRegArray valueForKey:@"Personalemailid"];
        NSString * Gaurdiancontactnumber =[self.AtheleteMemRegArray valueForKey:@"Gaurdiancontactnumber"];
        NSString * Gaurdianemail =[self.AtheleteMemRegArray valueForKey:@"Gaurdianemail"];
        NSString * Recordstatus =[self.AtheleteMemRegArray valueForKey:@"Recordstatus"];
        NSString * Createdby =[self.AtheleteMemRegArray valueForKey:@"Createdby"];
        NSString * Createddate =[self.AtheleteMemRegArray valueForKey:@"Createddate"];
        NSString * Modifiedby =[self.AtheleteMemRegArray valueForKey:@"Modifiedby"];
        NSString * Modifieddate =[self.AtheleteMemRegArray valueForKey:@"Modifieddate"];
        
        
        
    
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSOCIATIONMEMBERREGISTRATION WHERE ASSOCIATIONMEMBERID ='%@'",Associationmemberid];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                
                    
                    [self UpdateAtheleteMemReg: Clientcode: Associationmemberid: Associationid: Firstname: Lastname: Alicename: Registrationnumber: Registrationdate: Gender: Dateofbirth: Age: Group: Subgroup: Contactactnumberone: Contactnumbertwo: Memberphoto:Memberemail: Memberaddress: Fathersname: Effectivefrom: Effetiveto: City:State:Country: Pincode: Placeofbirth: Ageproof: Identificationmarks: Biometrics: Aadharnumber: Pannumber: Passportnumber: Personalcontactnumber: Personalemailid: Gaurdiancontactnumber: Gaurdianemail: Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertAtheleteMemReg: Clientcode: Associationmemberid: Associationid: Firstname: Lastname: Alicename: Registrationnumber: Registrationdate: Gender: Dateofbirth: Age: Group: Subgroup: Contactactnumberone: Contactnumbertwo: Memberphoto:Memberemail: Memberaddress: Fathersname: Effectivefrom: Effetiveto: City:State:Country: Pincode: Placeofbirth: Ageproof: Identificationmarks: Biometrics: Aadharnumber: Pannumber: Passportnumber: Personalcontactnumber: Personalemailid: Gaurdiancontactnumber: Gaurdianemail: Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertAtheleteMemReg:(NSString*) Clientcode:(NSString*) Associationmemberid:(NSString*) Associationid:(NSString*) Firstname:(NSString*) Lastname:(NSString*) Alicename:(NSString*) Registrationnumber:(NSString*) Registrationdate:(NSString*) Gender:(NSString*) Dateofbirth:(NSString*) Age:(NSString*) Group:(NSString*) Subgroup:(NSString*) Contactactnumberone:(NSString*) Contactnumbertwo:(NSString*) Memberphoto:(NSString*) Memberemail:(NSString*) Memberaddress:(NSString*) Fathersname:(NSString*) Effectivefrom:(NSString*) Effetiveto:(NSString*) City:(NSString*) State:(NSString*) Country:(NSString*) Pincode:(NSString*) Placeofbirth:(NSString*) Ageproof:(NSString*) Identificationmarks:(NSString*) Biometrics:(NSString*) Aadharnumber:(NSString*) Pannumber:(NSString*) Passportnumber:(NSString*) Personalcontactnumber:(NSString*) Personalemailid:(NSString*) Gaurdiancontactnumber:(NSString*) Gaurdianemail:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSOCIATIONMEMBERREGISTRATION (CLIENTCODE,ASSOCIATIONMEMBERID,ASSOCIATIONID,FIRSTNAME,LASTNAME,ALICENAME,REGISTRATIONNUMBER,REGISTRATIONDATE,GENDER,DATEOFBIRTH,AGE,[GROUP],SUBGROUP,CONTACTACTNUMBERONE,CONTACTNUMBERTWO,MEMBERPHOTO,MEMBEREMAIL,MEMBERADDRESS,FATHERSNAME,EFFECTIVEFROM,EFFETIVETO,CITY,STATE,COUNTRY,PINCODE,PLACEOFBIRTH,AGEPROOF,IDENTIFICATIONMARKS,BIOMETRICS,AADHARNUMBER,PANNUMBER,PASSPORTNUMBER,PERSONALCONTACTNUMBER,PERSONALEMAILID,GAURDIANCONTACTNUMBER,GAURDIANEMAIL,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Associationmemberid, Associationid, Firstname, Lastname, Alicename, Registrationnumber, Registrationdate, Gender, Dateofbirth, Age, Group, Subgroup, Contactactnumberone, Contactnumbertwo, Memberphoto,Memberemail, Memberaddress, Fathersname, Effectivefrom, Effetiveto, City,State,Country, Pincode, Placeofbirth, Ageproof, Identificationmarks, Biometrics, Aadharnumber, Pannumber, Passportnumber, Personalcontactnumber, Personalemailid, Gaurdiancontactnumber, Gaurdianemail, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateAtheleteMemReg:(NSString*) Clientcode:(NSString*) Associationmemberid:(NSString*) Associationid:(NSString*) Firstname:(NSString*) Lastname:(NSString*) Alicename:(NSString*) Registrationnumber:(NSString*) Registrationdate:(NSString*) Gender:(NSString*) Dateofbirth:(NSString*) Age:(NSString*) Group:(NSString*) Subgroup:(NSString*) Contactactnumberone:(NSString*) Contactnumbertwo:(NSString*) Memberphoto:(NSString*) Memberemail:(NSString*) Memberaddress:(NSString*) Fathersname:(NSString*) Effectivefrom:(NSString*) Effetiveto:(NSString*) City:(NSString*) State:(NSString*) Country:(NSString*) Pincode:(NSString*) Placeofbirth:(NSString*) Ageproof:(NSString*) Identificationmarks:(NSString*) Biometrics:(NSString*) Aadharnumber:(NSString*) Pannumber:(NSString*) Passportnumber:(NSString*) Personalcontactnumber:(NSString*) Personalemailid:(NSString*) Gaurdiancontactnumber:(NSString*) Gaurdianemail:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ATHLETEINFO SET  CLIENTCODE='%@',ASSOCIATIONMEMBERID='%@',ASSOCIATIONID='%@',FIRSTNAME='%@',LASTNAME='%@',ALICENAME='%@',REGISTRATIONNUMBER='%@',REGISTRATIONDATE='%@',GENDER='%@',DATEOFBIRTH='%@',AGE='%@',GROUP='%@',SUBGROUP='%@',CONTACTACTNUMBERONE='%@',CONTACTNUMBERTWO='%@',MEMBERPHOTO='%@',MEMBEREMAIL='%@',MEMBERADDRESS='%@',FATHERSNAME='%@',EFFECTIVEFROM='%@',EFFETIVETO='%@',CITY='%@',STATE='%@',COUNTRY='%@',PINCODE='%@',PLACEOFBIRTH='%@',AGEPROOF='%@',IDENTIFICATIONMARKS='%@',BIOMETRICS='%@',AADHARNUMBER='%@',PANNUMBER='%@',PASSPORTNUMBER='%@',PERSONALCONTACTNUMBER='%@',PERSONALEMAILID='%@',GAURDIANCONTACTNUMBER='%@',GAURDIANEMAIL='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE ASSESSMENTREGISTERCODE ='%@'",Clientcode, Associationmemberid, Associationid, Firstname, Lastname, Alicename, Registrationnumber, Registrationdate, Gender, Dateofbirth, Age, Group, Subgroup, Contactactnumberone, Contactnumbertwo, Memberphoto,Memberemail, Memberaddress, Fathersname, Effectivefrom, Effetiveto, City,State,Country, Pincode, Placeofbirth, Ageproof, Identificationmarks, Biometrics, Aadharnumber, Pannumber, Passportnumber, Personalcontactnumber, Personalemailid, Gaurdiancontactnumber, Gaurdianemail, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate,Associationmemberid];
            
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



-(BOOL) SELECTAtheleteInfoTeam:(NSString *)Athletecode{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.AtheleteInfoTeamArray objectAtIndex:0];
        NSString * Athletecode =[self.AtheleteInfoTeamArray objectAtIndex:1];
        NSString * Teamcode =[self.AtheleteInfoTeamArray objectAtIndex:2];
        NSString * Recordstatus =[self.AtheleteInfoTeamArray objectAtIndex:3];
        NSString * Createdby =[self.AtheleteInfoTeamArray objectAtIndex:4];
        NSString * Createddate =[self.AtheleteInfoTeamArray objectAtIndex:5];
        NSString * Modifiedby =[self.AtheleteInfoTeamArray objectAtIndex:6];
        NSString * Modifieddate =[self.AtheleteInfoTeamArray objectAtIndex:7];
        
        
        
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ATHLETEINFOTEAM WHERE ATHLETECODE ='%@'",Athletecode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)== SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                   [self UpdateAtheleteInfoTeam: Clientcode: Athletecode: Teamcode:  Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertAtheleteInfoTeam: Clientcode: Athletecode: Teamcode:  Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertAtheleteInfoTeam:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Teamcode:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ATHLETEINFOTEAM (CLIENTCODE,ATHLETECODE,TEAMCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Athletecode, Teamcode,Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateAtheleteInfoTeam:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Teamcode:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ATHLETEINFOTEAM SET  CLIENTCODE='%@',ATHLETECODE='%@',TEAMCODE='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE ATHLETECODE ='%@'",Clientcode, Athletecode, Teamcode, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate,Athletecode];
            
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
            
            
            sqlite3_close(dataBase);
            NSLog(@"Database Error Message : %s", sqlite3_errmsg(dataBase));

        }
        return NO;
    }
}


-(BOOL) SELECTSupportStaffInfo:(NSString *)Athletecode:(NSString *)Teamcode{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.SupportStaffInfoArray objectAtIndex:0];
        NSString * Code =[self.SupportStaffInfoArray objectAtIndex:1];
        NSString * Teamcode =[self.SupportStaffInfoArray objectAtIndex:2];
        NSString * Recordstatus =[self.SupportStaffInfoArray objectAtIndex:3];
        NSString * Createdby =[self.SupportStaffInfoArray objectAtIndex:4];
        NSString * Createddate =[self.SupportStaffInfoArray objectAtIndex:5];
        NSString * Modifiedby =[self.SupportStaffInfoArray objectAtIndex:6];
        NSString * Modifieddate =[self.SupportStaffInfoArray objectAtIndex:7];
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM SUPPORTSTAFFTEAMS WHERE CODE ='%@' AND TEAMCODE ='%@'",Athletecode,Teamcode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateSupportStaffInfo: Clientcode: Code: Teamcode:  Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertSupportStaffInfo: Clientcode: Code: Teamcode:  Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertSupportStaffInfo:(NSString*) Clientcode:(NSString*) Code:(NSString*) Teamcode:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO SUPPORTSTAFFTEAMS (CLIENTCODE,CODE,TEAMCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Code, Teamcode,Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateSupportStaffInfo:(NSString*) Clientcode:(NSString*) Code:(NSString*) Teamcode:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE SUPPORTSTAFFTEAMS SET  CLIENTCODE='%@',CODE='%@',TEAMCODE='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE CODE ='%@' AND Teamcode='%@",Clientcode, Code, Teamcode, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate,Code,Teamcode];
            
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


-(BOOL) SELECTRoleDetails:(NSString *)Rolecode{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.RoleDetailsArray objectAtIndex:0];
        NSString * Rolecode =[self.RoleDetailsArray objectAtIndex:1];
        NSString * Role =[self.RoleDetailsArray objectAtIndex:2];
        NSString * Ischecked =[self.RoleDetailsArray objectAtIndex:2];
        NSString * Recordstatus =[self.RoleDetailsArray objectAtIndex:3];
        NSString * Createdby =[self.RoleDetailsArray objectAtIndex:4];
        NSString * Createddate =[self.RoleDetailsArray objectAtIndex:5];
        NSString * Modifiedby =[self.RoleDetailsArray objectAtIndex:6];
        NSString * Modifieddate =[self.RoleDetailsArray objectAtIndex:7];
        
       

        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ROLEMASTER WHERE ROLECODE ='%@'",Rolecode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateSRoleDetails: Clientcode: Rolecode: Role:Ischecked : Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertRoleDetails: Clientcode: Rolecode: Role:Ischecked : Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertRoleDetails:(NSString*) Clientcode:(NSString*) Rolecode:(NSString*) Role:(NSString*) Ischecked:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ROLEMASTER (CLIENTCODE,ROLECODE,ROLE,ISCHECKED,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Rolecode, Role,Ischecked, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateSRoleDetails:(NSString*) Clientcode:(NSString*) Rolecode:(NSString*) Role:(NSString*) Ischecked:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ROLEMASTER SET  CLIENTCODE='%@',ROLECODE='%@',ROLE='%@',ISCHECKED='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE ROLECODE ='%@' ",Clientcode, Rolecode, Role,Ischecked, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate,Rolecode];
            
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
-(BOOL) SELECTUserDetails:(NSString *)Usercode{
    @synchronized ([AppCommon syncId])  {
        NSString * Clientcode =[self.UserDetailsArray valueForKey:@"Clientcode"];
        NSString * Usercode =[self.UserDetailsArray valueForKey:@"Usercode"];
        NSString * Username =[self.UserDetailsArray valueForKey:@"Username"];
        NSString * Loginid =[self.UserDetailsArray valueForKey:@"Loginid"];
        NSString * Password =[self.UserDetailsArray valueForKey:@"Password"];
        NSString * Userreferencecode =[self.UserDetailsArray valueForKey:@"Userreferencecode"];
        NSString * Associationid =[self.UserDetailsArray valueForKey:@"Associationid"];
        NSString * Dob =[self.UserDetailsArray valueForKey:@"Dob"];
        NSString * Gender =[self.UserDetailsArray valueForKey:@"Gender"];
        NSString * Fathername =[self.UserDetailsArray valueForKey:@"Fathername"];
        NSString * Nationality =[self.UserDetailsArray valueForKey:@"Nationality"];
        NSString * Birthplace =[self.UserDetailsArray valueForKey:@"Birthplace"];
        NSString * Birthproof =[self.UserDetailsArray valueForKey:@"Birthproof"];
        NSString * Occupation =[self.UserDetailsArray valueForKey:@"Occupation"];
        NSString * Address1 =[self.UserDetailsArray valueForKey:@"Address1"];
        NSString * Address2 =[self.UserDetailsArray valueForKey:@"Address2"];
        NSString * City =[self.UserDetailsArray valueForKey:@"City"];
        NSString * State =[self.UserDetailsArray valueForKey:@"State"];
        NSString * Country =[self.UserDetailsArray valueForKey:@"Country"];
        NSString * Pincode =[self.UserDetailsArray valueForKey:@"Pincode"];
        NSString * Contactnumber1 =[self.UserDetailsArray valueForKey:@"Contactnumber1"];
        NSString * Contactnumber2 =[self.UserDetailsArray valueForKey:@"Contactnumber2"];
        NSString * Emailid =[self.UserDetailsArray valueForKey:@"Emailid"];
        NSString * Photo =[self.UserDetailsArray valueForKey:@"Photo"];
        NSString * Fcmid =[self.UserDetailsArray valueForKey:@"Fcmid"];
        NSString * Recordstatus =[self.UserDetailsArray valueForKey:@"Recordstatus"];
        NSString * Createdby =[self.UserDetailsArray valueForKey:@"Createdby"];
        NSString * Createddate =[self.UserDetailsArray valueForKey:@"Createddate"];
        NSString * Modifiedby =[self.UserDetailsArray valueForKey:@"Modifiedby"];
        NSString * Modifieddate =[self.UserDetailsArray valueForKey:@"Modifieddate"];
        NSString * Logincount =[self.UserDetailsArray valueForKey:@"Logincount"];
        NSString * Role =[self.UserDetailsArray valueForKey:@"Role"];
        NSString * Rememberme =[self.UserDetailsArray valueForKey:@"Rememberme"];
        NSString * Rementdate =[self.UserDetailsArray valueForKey:@"Rementdate"];
        
        

        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM USERDETAILS WHERE USERCODE ='%@'",Usercode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateUserDetails: Clientcode: Usercode: Username: Loginid: Password: Userreferencecode: Associationid: Dob: Gender: Fathername: Nationality: Birthplace: Birthproof: Occupation: Address1: Address2: City: State: Country: Pincode: Contactnumber1: Contactnumber2: Emailid: Photo: Fcmid:Recordstatus:Createdby: Createddate: Modifiedby: Modifieddate: Logincount: Role: Rememberme: Rementdate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertUserDetails: Clientcode: Usercode: Username: Loginid: Password: Userreferencecode: Associationid: Dob: Gender: Fathername: Nationality: Birthplace: Birthproof: Occupation: Address1: Address2: City: State: Country: Pincode: Contactnumber1: Contactnumber2: Emailid: Photo: Fcmid:Recordstatus:Createdby: Createddate: Modifiedby: Modifieddate: Logincount: Role: Rememberme: Rementdate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertUserDetails:(NSString*) Clientcode:(NSString*) Usercode:(NSString*) Username:(NSString*) Loginid:(NSString*) Password:(NSString*) Userreferencecode:(NSString*) Associationid:(NSString*) Dob:(NSString*) Gender:(NSString*) Fathername:(NSString*) Nationality:(NSString*) Birthplace:(NSString*) Birthproof:(NSString*) Occupation:(NSString*) Address1:(NSString*) Address2:(NSString*) City:(NSString*) State:(NSString*) Country:(NSString*) Pincode:(NSString*) Contactnumber1:(NSString*) Contactnumber2:(NSString*) Emailid:(NSString*) Photo:(NSString*) Fcmid:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate:(NSString*) Logincount:(NSString*) Role:(NSString*) Rememberme:(NSString*) Rementdate{
    
    
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO USERDETAILS (CLIENTCODE,USERCODE,USERNAME,LOGINID,PASSWORD,USERREFERENCECODE,ASSOCIATIONID,DOB,GENDER,FATHERNAME,NATIONALITY,BIRTHPLACE,BIRTHPROOF,OCCUPATION,ADDRESS1,ADDRESS2,CITY,STATE,COUNTRY,PINCODE,CONTACTNUMBER1,CONTACTNUMBER2,EMAILID,PHOTO,FCMID,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,LOGINCOUNT,ROLE,REMEMBERME,REMENTDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", Clientcode, Usercode, Username, Loginid, Password, Userreferencecode, Associationid, Dob, Gender, Fathername, Nationality, Birthplace, Birthproof, Occupation, Address1, Address2, City, State, Country, Pincode, Contactnumber1, Contactnumber2, Emailid, Photo, Fcmid, Recordstatus, Createdby, Createddate, Modifiedby, Modifieddate, Logincount, Role, Rememberme, Rementdate];
            
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
-(BOOL)UpdateUserDetails:(NSString*) Clientcode:(NSString*) Usercode:(NSString*) Username:(NSString*) Loginid:(NSString*) Password:(NSString*) Userreferencecode:(NSString*) Associationid:(NSString*) Dob:(NSString*) Gender:(NSString*) Fathername:(NSString*) Nationality:(NSString*) Birthplace:(NSString*) Birthproof:(NSString*) Occupation:(NSString*) Address1:(NSString*) Address2:(NSString*) City:(NSString*) State:(NSString*) Country:(NSString*) Pincode:(NSString*) Contactnumber1:(NSString*) Contactnumber2:(NSString*) Emailid:(NSString*) Photo:(NSString*) Fcmid:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate:(NSString*) Logincount:(NSString*) Role:(NSString*) Rememberme:(NSString*) Rementdate{
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ATHLETEINFO SET  CLIENTCODE='%@',USERCODE='%@',USERNAME='%@',LOGINID='%@',PASSWORD='%@',USERREFERENCECODE='%@',ASSOCIATIONID='%@',DOB='%@',GENDER='%@',FATHERNAME='%@',NATIONALITY='%@',BIRTHPLACE='%@',BIRTHPROOF='%@',OCCUPATION='%@',ADDRESS1='%@',ADDRESS2='%@',CITY='%@',STATE='%@',COUNTRY='%@',PINCODE='%@',CONTACTNUMBER1='%@',CONTACTNUMBER2='%@',EMAILID='%@',PHOTO='%@',FCMID='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@',LOGINCOUNT='%@',ROLE='%@',REMEMBERME='%@',REMENTDATE ='%@' WHERE USERCODE ='%@'",Clientcode, Usercode, Username, Loginid, Password, Userreferencecode, Associationid, Dob, Gender, Fathername, Nationality, Birthplace, Birthproof, Occupation, Address1, Address2, City, State, Country, Pincode, Contactnumber1, Contactnumber2, Emailid, Photo, Fcmid, Recordstatus, Createdby, Createddate, Modifiedby, Modifieddate, Logincount, Role, Rememberme, Rementdate,Usercode];
            
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



-(BOOL) SELECTUserRoleMap:(NSString *)Usercode:(NSString *)Rolecode{
    @synchronized ([AppCommon syncId])  {
        
        NSString * Clientcode =[self.UserRolemapArray objectAtIndex:0];
        NSString * Usercode =[self.UserRolemapArray objectAtIndex:1];
        NSString * Rolecode =[self.UserRolemapArray objectAtIndex:2];
        NSString * Isdefaultrole =[self.UserRolemapArray objectAtIndex:3];
        NSString * Recordstatus =[self.UserRolemapArray objectAtIndex:4];
        NSString * Createdby =[self.UserRolemapArray objectAtIndex:5];
        NSString * Createddate =[self.UserRolemapArray objectAtIndex:6];
        NSString * Modifiedby =[self.UserRolemapArray objectAtIndex:7];
        NSString * Modifieddate =[self.UserRolemapArray objectAtIndex:8];
    
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM USERROLEMAPPING WHERE USERCODE ='%@' AND ROLECODE ='%@'",Usercode,Rolecode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    
                    
                    [self UpdateUserRoleMap: Clientcode: Usercode: Rolecode:Isdefaultrole : Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self InsertUserRoleMap: Clientcode: Usercode: Rolecode:Isdefaultrole : Recordstatus: Createdby: Createddate: Modifiedby:Modifieddate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}




-(BOOL)InsertUserRoleMap:(NSString*) Clientcode:(NSString*) Usercode:(NSString*) Rolecode:(NSString*) Isdefaultrole:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO USERROLEMAPPING (CLIENTCODE,USERCODE,ROLECODE,ISDEFAULTROLE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Usercode, Rolecode,Isdefaultrole, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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
-(BOOL)UpdateUserRoleMap:(NSString*) Clientcode:(NSString*) Usercode:(NSString*) Rolecode:(NSString*) Isdefaultrole:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE USERROLEMAPPING SET  CLIENTCODE='%@',USERCODE='%@',ROLECODE='%@',ISDEFAULTROLE='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@' WHERE USERCODE ='%@' AND ROLECODE ='%@' ",Clientcode, Usercode, Rolecode,Isdefaultrole, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate,Usercode,Rolecode];
            
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

-(BOOL)DleteAthleteinfodetails{
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = @"DELETE  FROM ATHLETEINFODETAILS";
            
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

-(BOOL)InsertAthleteinfodetails:(NSString*) Clientcode:(NSString*) Athletecode:(NSString*) Gamecode:(NSString*) Teamcode:(NSString*) Attributevaluecode:(NSString*) Attributevaluedescription:(NSString*) Inputtype:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*) Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ATHLETEINFODETAILS (CLIENTCODE,ATHLETECODE,GAMECODE,TEAMCODE,ATTRIBUTEVALUECODE,ATTRIBUTEVALUEDESCRIPTION,INPUTTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Athletecode, Gamecode,Teamcode,Attributevaluecode,Attributevaluedescription,Inputtype, Recordstatus, Createdby, Createddate, Modifiedby,Modifieddate];
            
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

    
-(BOOL)DletegameAttribute{
        
    @synchronized ([AppCommon syncId])  {
            
        
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [DBPath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                
                
                NSString *INSERTSQL = @"DELETE  FROM GAMEATTRIBUTEMETADATA";
                
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

-(BOOL)InsertgameAttribute:(NSString*) Attributevaluecode:(NSString*) Attributevaluedescription:(NSString*) Gametype:(NSString*) Attributecode:(NSString*) Attributedescription:(NSString*) Inputtype {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
        
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO GAMEATTRIBUTEMETADATA (ATTRIBUTEVALUECODE,ATTRIBUTEVALUEDESCRIPTION,GAMETYPE,ATTRIBUTECODE,ATTRIBUTEDESCRIPTION,INPUTTYPE)VALUES('%@','%@','%@','%@','%@','%@')",Attributevaluecode, Attributevaluedescription, Gametype,Attributecode,Attributedescription,Inputtype];
            
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
    
-(BOOL)DleteTestGoal{
        
    @synchronized ([AppCommon syncId])  {
            
            
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [DBPath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                
                
                NSString *INSERTSQL = @"DELETE  FROM TESTSCGOAL";
                
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

-(BOOL)InsertTestGoal:(NSString*)Clientcode: (NSString*)Testcode:(NSString*) Min:(NSString*) Max: (NSString*)Recordstatus:(NSString*) Createdby:(NSString*)Createddate:(NSString*)Modifiedby:(NSString*)Modifieddate {
    
    @synchronized ([AppCommon syncId])  {
        
        
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TESTSCGOAL (CLIENTCODE,TESTCODE,MIN,MAX,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode, Testcode, Min,Max,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate];
            
        
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




#pragma teamlistsyn

-(BOOL) SELECTTEAM:(NSString *)TEAMCODE{
    @synchronized ([AppCommon syncId])  {
        
        NSString *CLIENTCODE = [self.TeamListDetailArray objectAtIndex:0];
        NSString *TEAMCODE=[self.TeamListDetailArray objectAtIndex:1];
        NSString *TEAMNAME=[self.TeamListDetailArray objectAtIndex:2];
        NSString *TEAMSHORTNAME=[self.TeamListDetailArray objectAtIndex:3];
        NSString *GAME=[self.TeamListDetailArray objectAtIndex:4];
        NSString *RECORDSTATUS=[self.TeamListDetailArray objectAtIndex:5];
        NSString *CREATEDBY=[self.TeamListDetailArray objectAtIndex:6];
        NSString *CREATEDDATE=[self.TeamListDetailArray objectAtIndex:7];
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM TEAMMASTER WHERE TEAMCODE='%@'",TEAMCODE];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)== SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                
            [self UPDATETEAMLIST:CLIENTCODE :TEAMCODE :TEAMNAME :TEAMSHORTNAME :GAME :RECORDSTATUS :CREATEDBY :CREATEDDATE];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
               
                [self INSERTTEAMLIST:CLIENTCODE :TEAMCODE :TEAMNAME :TEAMSHORTNAME :GAME :RECORDSTATUS :CREATEDBY :CREATEDDATE];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}


-(BOOL) UPDATETEAMLIST:(NSString*) CLIENTCODE:(NSString*) TEAMCODE:(NSString*) TEAMNAME:(NSString*) TEAMSHORTNAME:(NSString*) GAME:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TEAMMASTER SET  CLIENTCODE='%@',GAME='%@',TEAMCODE='%@',TEAMNAME='%@',TEAMSHORTNAME='%@',RECORDSTATUS='%@',CREATEDBY='%@', CREATEDDATE='%@' WHERE TEAMCODE ='%@'",CLIENTCODE,GAME,TEAMCODE,TEAMNAME,TEAMSHORTNAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,TEAMCODE];
            
            
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

-(BOOL) INSERTTEAMLIST:(NSString*) CLIENTCODE:(NSString*) TEAMCODE:(NSString*) TEAMNAME:(NSString*) TEAMSHORTNAME:(NSString*) GAME:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY :(NSString*) CREATEDDATE{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TEAMMASTER(CLIENTCODE,TEAMCODE,TEAMNAME,TEAMSHORTNAME,GAME,RECORDSTATUS,CREATEDBY,CREATEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",CLIENTCODE,TEAMCODE,TEAMNAME,TEAMSHORTNAME,GAME,RECORDSTATUS,CREATEDBY,CREATEDDATE];
            
            
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

#pragma SupportStaff

-(BOOL)SELECTSupportStaff:(NSString *)MemberCode
{
    @synchronized ([AppCommon syncId])  {
        
        NSString *CLIENTCODE = [self.SupportStaffArray objectAtIndex:0];
        NSString *MemberCode=[self.SupportStaffArray objectAtIndex:1];
        NSString *StaffType=[self.SupportStaffArray objectAtIndex:2];
        NSString *Levels=[self.SupportStaffArray objectAtIndex:3];
        NSString *Recordstatus=[self.SupportStaffArray objectAtIndex:4];
        NSString *Createdby=[self.SupportStaffArray objectAtIndex:5];
        NSString *Createddate=[self.SupportStaffArray objectAtIndex:6];
        NSString *Modifiedby=[self.SupportStaffArray objectAtIndex:7];
        NSString *Modifieddate=[self.SupportStaffArray objectAtIndex:8];

        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM SUPPORTSTAFF WHERE MEMBERCODE='%@'",MemberCode];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    [self UPDATESUPPORTSTAFFLIST:CLIENTCODE :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate :MemberCode :StaffType:Levels];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                [self INSERTSUPPORTSTAFFLIST:CLIENTCODE :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate :MemberCode :StaffType:Levels];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL) UPDATESUPPORTSTAFFLIST:(NSString*) CLIENTCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)MEMBERCODE :(NSString*) STAFFTYPE: (NSString*)LEVEL
{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE SUPPORTSTAFF SET  CLIENTCODE='%@',RECORDSTATUS='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@', STAFFTYPE='%@', LEVELS='%@' WHERE  MEMBERCODE='%@' ",CLIENTCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,STAFFTYPE,LEVEL,MEMBERCODE];
            
            
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

-(BOOL) INSERTSUPPORTSTAFFLIST:(NSString*) CLIENTCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)MEMBERCODE :(NSString*) STAFFTYPE: (NSString*)LEVEL{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO SUPPORTSTAFF(CLIENTCODE,MEMBERCODE,STAFFTYPE,LEVELS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",CLIENTCODE,MEMBERCODE,STAFFTYPE,LEVEL,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
            
            
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

-(BOOL)SELECTAssementEntry:(NSString *)AssessementEntryCode
{
    @synchronized ([AppCommon syncId])  {
        
        NSString *Clientcode = [self.AssessmentEntyArray valueForKey:@"Clientcode"];
        NSString *Assessmententrycode=[self.AssessmentEntyArray valueForKey:@"Assessmententrycode"];
        NSString *Modulecode=[self.AssessmentEntyArray valueForKey:@"Modulecode"];
        NSString *Assessmentcode=[self.AssessmentEntyArray valueForKey:@"Assessmentcode"];
        NSString *Assessmenttestcode=[self.AssessmentEntyArray valueForKey:@"Assessmenttestcode"];
        NSString *Assessmenttesttypecode=[self.AssessmentEntyArray valueForKey:@"Assessmenttesttypecode"];
        NSString *Assessmenttesttypescreencode=[self.AssessmentEntyArray valueForKey:@"Assessmenttesttypescreencode"];
        NSString *Version=[self.AssessmentEntyArray valueForKey:@"Version"];
        NSString *Assessor=[self.AssessmentEntyArray valueForKey:@"Assessor"];
        NSString *Playercode = [self.AssessmentEntyArray valueForKey:@"Playercode"];
        NSString *Assessmententrydate=[self.AssessmentEntyArray valueForKey:@"Assessmententrydate"];
        NSNumber *Left=[self.AssessmentEntyArray valueForKey:@"Left"];
        NSNumber *Right=[self.AssessmentEntyArray valueForKey:@"Right"];
        NSNumber *Central=[self.AssessmentEntyArray valueForKey:@"Central"];
        NSString *Value=[self.AssessmentEntyArray valueForKey:@"Value"];
        NSString *Remarks=[self.AssessmentEntyArray valueForKey:@"Remarks"];
        NSString *Inference=[self.AssessmentEntyArray valueForKey:@"Inference"];
        NSString *Units=[self.AssessmentEntyArray valueForKey:@"Units"];
        NSString *Description = [self.AssessmentEntyArray valueForKey:@"Description"];
        NSString *Recordstatus=[self.AssessmentEntyArray valueForKey:@"Recordstatus"];
        NSString *Createdby=[self.AssessmentEntyArray valueForKey:@"Createdby"];
        NSString *Createddate=[self.AssessmentEntyArray valueForKey:@"Createddate"];
        NSString *Modifiedby=[self.AssessmentEntyArray valueForKey:@"Modifiedby"];
        NSString *Modifieddate=[self.AssessmentEntyArray valueForKey:@"Modifieddate"];
        NSString *isIgnored=[self.AssessmentEntyArray valueForKey:@"isIgnored"];
        NSNumber *Left1=[self.AssessmentEntyArray valueForKey:@"Left1"];
        NSNumber *Right1=[self.AssessmentEntyArray valueForKey:@"Right1"];
        NSNumber *Central1=[self.AssessmentEntyArray valueForKey:@"Central1"];
        NSNumber *Left2=[self.AssessmentEntyArray valueForKey:@"Left2"];
        NSNumber *Right2=[self.AssessmentEntyArray valueForKey:@"Right2"];
        NSNumber *Central2=[self.AssessmentEntyArray valueForKey:@"Central2"];
        NSNumber *Left3=[self.AssessmentEntyArray valueForKey:@"Left3"];
        NSNumber *Right3=[self.AssessmentEntyArray valueForKey:@"Right3"];
        NSNumber *Central3=[self.AssessmentEntyArray valueForKey:@"Central3"];
        NSNumber *Left4=[self.AssessmentEntyArray valueForKey:@"Left4"];
        NSNumber *Right4=[self.AssessmentEntyArray valueForKey:@"Right4"];
        NSNumber *Central4=[self.AssessmentEntyArray valueForKey:@"Central4"];
        NSNumber *Left5=[self.AssessmentEntyArray valueForKey:@"Left5"];
        NSNumber *Right5=[self.AssessmentEntyArray valueForKey:@"Right5"];
        NSNumber *Central5=[self.AssessmentEntyArray valueForKey:@"Central5"];
        NSNumber *Left6=[self.AssessmentEntyArray valueForKey:@"Left6"];
        NSNumber *Right6=[self.AssessmentEntyArray valueForKey:@"Right6"];
        NSNumber *Central6=[self.AssessmentEntyArray valueForKey:@"Central6"];
        NSNumber *Left7=[self.AssessmentEntyArray valueForKey:@"Left7"];
        NSNumber *Right7=[self.AssessmentEntyArray valueForKey:@"Right7"];
        NSNumber *Central7=[self.AssessmentEntyArray valueForKey:@"Central7"];
        NSNumber *Left8=[self.AssessmentEntyArray valueForKey:@"Left8"];
        NSNumber *Right8=[self.AssessmentEntyArray valueForKey:@"Right8"];
        NSNumber *Central8=[self.AssessmentEntyArray valueForKey:@"Central8"];
        NSNumber *Left9=[self.AssessmentEntyArray valueForKey:@"Left9"];
        NSNumber *Right9=[self.AssessmentEntyArray valueForKey:@"Right9"];
        NSNumber *Central9=[self.AssessmentEntyArray valueForKey:@"Central9"];
        
        
        
        
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTENTRY WHERE ASSESSMENTTESTTYPECODE ='%@' And CLIENTCODE ='%@' And MODULECODE ='%@' And CREATEDBY ='%@' And ASSESSMENTTESTCODE ='%@' And PLAYERCODE ='%@' And VERSION ='%@' And ASSESSMENTENTRYDATE = '%@'   ",Assessmenttesttypecode,Clientcode,Modulecode,Createdby,Assessmenttestcode,Playercode,Version,Assessmententrydate];
            
            stmt=[query UTF8String];
            
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *aname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSLog(@" Load completed Name = %@ ",aname);
                    
                    NSString * issync = @"0";
                    [self UPDATEAssessmentEntry:Clientcode :Assessmententrycode :Modulecode :Assessmentcode :Assessmenttestcode :Assessmenttesttypecode :Assessmenttesttypescreencode :Version :Assessor :Playercode :Assessmententrydate :Left :Right :Central :Value :Remarks :Inference :Units :Description :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate :isIgnored :Left1 :Right1 :Central1 :Left2 :Right2 :Central2 :Left3 :Right3 :Central3 :Left4 :Right4 :Central4 :Left5 :Right5 :Central5 :Left6 :Right6 :Central6 :Left7 :Right7 :Central7 :Left8 :Right8 :Central8 :Left9 :Right9 :Central9:issync];
                    
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
                NSString * issync = @"0";
                [self INSERTAssessmentEntry:Clientcode :Assessmententrycode :Modulecode :Assessmentcode :Assessmenttestcode :Assessmenttesttypecode :Assessmenttesttypescreencode :Version :Assessor :Playercode :Assessmententrydate :Left :Right:Central :Value :Remarks :Inference :Units :Description :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate :isIgnored :Left1 :Right1 :Central1 :Left2 :Right2 :Central2 :Left3 :Right3 :Central3 :Left4 :Right4 :Central4 :Left5 :Right5 :Central5 :Left6 :Right6 :Central6 :Left7 :Right7 :Central7 :Left8 :Right8 :Central8 :Left9 :Right9 :Central9:issync];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(dataBase);
        }
        return NO;
    }
}

-(BOOL) UPDATEAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSNumber*) Left:(NSNumber*) Right:(NSNumber*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync
{
    
    NSLog(@"UPDATEAssessmentEntry called");
    
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTENTRY SET  Clientcode='%@',Modulecode='%@' ,Assessmentcode='%@' ,Assessmenttestcode='%@' ,Assessmenttesttypecode='%@' ,Assessmenttesttypescreencode='%@' ,Version ='%@',Assessor ='%@',Playercode='%@' ,Assessmententrydate='%@' ,Left='%@' ,Right='%@' ,Central='%@' ,Value='%@' ,Remarks='%@' ,Inference='%@' ,Units='%@' ,Description='%@' ,Recordstatus='%@' ,Createdby='%@' ,Createddate='%@' ,Modifiedby='%@' ,Modifieddate='%@' ,Ignored='%@' ,Left1='%@' ,Right1='%@' ,Central1='%@' ,Left2='%@' ,Right2='%@' ,Central2='%@' ,Left3='%@' ,Right3='%@' ,Central3='%@' ,Left4='%@' ,Right4='%@' ,Central4='%@' ,Left5='%@' ,Right5='%@' ,Central5='%@' ,Left6='%@' ,Right6='%@' ,Central6='%@' ,Left7='%@' ,Right7='%@' ,Central7='%@' ,Left8='%@' ,Right8='%@' ,Central8='%@' ,Left9='%@' ,Right9='%@' ,Central9='%@',issync='%@'",Clientcode ,Assessmententrycode ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9,issync];
            
            
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

-(BOOL) INSERTAssessmentEntry:(NSString*) Clientcode:(NSString*) Assessmententrycode:(NSString*) Modulecode:(NSString*) Assessmentcode:(NSString*) Assessmenttestcode:(NSString*)Assessmenttesttypecode:(NSString*)Assessmenttesttypescreencode :(NSString*) Version: (NSString*)Assessor :(NSString*) Playercode:(NSString*) Assessmententrydate:(NSNumber*) Left:(NSNumber*) Right:(NSNumber*) Central:(NSString*)Value:(NSString*)Remarks :(NSString*) Inference: (NSString*)Units  :(NSString*) Description:(NSString*) Recordstatus:(NSString*) Createdby:(NSString*) Createddate:(NSString*) Modifiedby:(NSString*)Modifieddate:(NSString*)isIgnored :(NSNumber*) Left1: (NSNumber*)Right1 :(NSNumber*) Central1:(NSNumber*) Left2:(NSNumber*) Right2:(NSNumber*) Central2:(NSNumber*) Left3:(NSNumber*)Right3:(NSNumber*)Central3 :(NSNumber*) Left4: (NSNumber*)Right4 :(NSNumber*) Central4:(NSNumber*) Left5:(NSNumber*) Right5:(NSNumber*) Central5:(NSNumber*) Left6:(NSNumber*)Right6:(NSNumber*)Central6 :(NSNumber*) Left7: (NSNumber*)Right7 :(NSNumber*) Central7:(NSNumber*) Left8:(NSNumber*) Right8:(NSNumber*) Central8:(NSNumber*) Left9:(NSNumber*)Right9:(NSNumber*)Central9 : (NSString*)issync {
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
           // NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO ASSESSMENTENTRY(Clientcode ,Assessmententrycode ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,Ignored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",Clientcode ,Assessmententrycode ,Modulecode ,Assessmentcode ,Assessmenttestcode ,Assessmenttesttypecode ,Assessmenttesttypescreencode ,Version ,Assessor ,Playercode ,Assessmententrydate ,Left ,Right ,Central ,Value ,Remarks ,Inference ,Units ,Description ,Recordstatus ,Createdby ,Createddate ,Modifiedby ,Modifieddate ,isIgnored ,Left1 ,Right1 ,Central1 ,Left2 ,Right2 ,Central2 ,Left3 ,Right3 ,Central3 ,Left4 ,Right4 ,Central4 ,Left5 ,Right5 ,Central5 ,Left6 ,Right6 ,Central6 ,Left7 ,Right7 ,Central7 ,Left8 ,Right8 ,Central8 ,Left9 ,Right9 ,Central9];
            

            
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




-(NSMutableDictionary *)AssessmentEntrySyncBackground
{
    @synchronized ([AppCommon syncId]) {
        
        //BOOL result = NO;
        
        NSMutableDictionary *RootDic= [[NSMutableDictionary alloc]init];
        NSMutableArray *listAssessmentArray = [[NSMutableArray alloc]init];
        
        NSString *dbPath = [self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        
        if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
        {
           
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ASSESSMENTENTRY WHERE ISSYNC = 0"];
            stmt=[query UTF8String];
            if(sqlite3_prepare_v2(dataBase, stmt,-1, &statement, NULL)==SQLITE_OK)
            {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                    
                   // result = YES;
                    
                    NSMutableDictionary *tabledataDic= [[NSMutableDictionary alloc]init];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"Clientcode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"Assessmententrycode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"Modulecode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"Assessmentcode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"Assessmenttestcode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"Assessmenttesttypecode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"Assessmenttesttypescreencode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"Version"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"Assessor"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"Playercode"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"Assessmententrydate"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"Left"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"Right"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"Central"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"Left1"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"Right1"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)] forKey:@"Central1"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)] forKey:@"Left2"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)] forKey:@"Right2"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)] forKey:@"Central2"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)] forKey:@"Left3"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)] forKey:@"Right3"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)] forKey:@"Central3"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)] forKey:@"Left4"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)] forKey:@"Right4"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)] forKey:@"Central4"];
                    
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)] forKey:@"Left5"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)] forKey:@"Right5"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)] forKey:@"Central5"];
                    
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)] forKey:@"Left6"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)] forKey:@"Right6"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)] forKey:@"Central6"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)] forKey:@"Left7"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)] forKey:@"Right7"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)] forKey:@"Central7"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)] forKey:@"Left8"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)] forKey:@"Right8"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)] forKey:@"Central8"];
                    
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)] forKey:@"Left9"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)] forKey:@"Right9"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)] forKey:@"Central9"];
                    
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)] forKey:@"Value"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)] forKey:@"Remarks"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)] forKey:@"Inference"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)] forKey:@"Units"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)] forKey:@"Description"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)] forKey:@"Recordstatus"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)] forKey:@"Createdby"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)] forKey:@"Createddate"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)] forKey:@"Modifiedby"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)] forKey:@"Modifieddate"];
                    [tabledataDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)] forKey:@"isIgnored"];
                        
                        [listAssessmentArray addObject:tabledataDic];
                    }
                   
                    [RootDic setObject:listAssessmentArray forKey:@"LstAssessmententry"];
                    
//                }else{
//                    NSLog(@"Sync Update failed Stat: %s.", sqlite3_errmsg(dataBase));
//                    NSLog(@"Sync Update failed %@",SEQNO);
//                    result = NO;
//                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            
            
            sqlite3_close(dataBase);
        }
        return RootDic;
        
    }
}


-(BOOL) UPDATESyncStatus:(NSMutableArray*) entryDetailsList
{
    @synchronized ([AppCommon syncId])  {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [DBPath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString * assementEntryCode = [entryDetailsList valueForKey:@"Assessmententrycode"];
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE ASSESSMENTENTRY SET issync = 1 WHERE Assessmententrycode = %@ ",assementEntryCode];
            
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
@end
