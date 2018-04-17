//
//  WebService.m
//  UPCA
//
//  Created by Mac on 11/05/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "WebService.h"


static const NSString *ServicePost   = @"POST";
static const NSString *ServiceGet    = @"GET";
static const NSString *ServicePut    = @"PUT";
static const NSString *ServiceDelete = @"DELETE";

static const NSString *ServiceContentJSON = @"application/json";
static const NSString *ServiceContentFORM = @"application/x-www-form-urlencoded; charset=UTF-8";
static NSString       *ServiceMimeType    = @"image/jpeg";


@interface WebService ()
{
    NSString *urlString;
}
@end

@implementation WebService

- (id)init {
    self = [super init];
    if (self) {
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"text/javascript", @"text/plain", @"application/json",@"image/png",nil];
    }
    return self;
}

+ (WebService *)service {
    return [[WebService alloc] init];
}

-(void)getLogin :(NSString *) loginValue:(NSString *)userName :(NSString *)password success:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",loginValue,userName,password]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)getAssesmentlist :(NSString *)asmtlist :(NSString *)clientCode :(NSString *)moduleCode :(NSString *)createdby success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",asmtlist,clientCode,moduleCode,createdby]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)getmetacodelist :(NSString *)codelist :(NSString *)clientCode :(NSString *)rcCode success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",codelist,clientCode,rcCode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getdatelist :(NSString *)codelist :(NSString *)playercode :(NSString *)date success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",codelist,playercode,date]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}


-(void)submit :(NSString *)codelist :(NSString *)clientCode :(NSString *)usercode :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 :(NSString *)bodyWeight :(NSString *)sleephr :(NSString *)fat :(NSString *)restinghr :(NSString *)restingbpMax :(NSString *)restingbpMin :(NSString *)urinecolor success:(WebserviceRequestSuccessHandler)success
       failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",codelist,clientCode,usercode,date,playercode,code1,code2,code3,code4,bodyWeight,sleephr,fat,restinghr,restingbpMax,restingbpMin,urinecolor]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}



-(void)UpdateWellness :(NSString *)codelist :(NSString *)clientCode :(NSString *)usercode :(NSString *)workLoadCode :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 :(NSString *)bodyWeight :(NSString *)sleephr :(NSString *)fat :(NSString *)restinghr :(NSString *)restingbpMax :(NSString *)restingbpMin :(NSString *)urinecolor success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",codelist,clientCode,usercode,workLoadCode,date,playercode,code1,code2,code3,code4,bodyWeight,sleephr,fat,restinghr,restingbpMax,restingbpMin,urinecolor]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)fetchWellness :(NSString *)codelist :(NSString *)playercode :(NSString *)date  success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",codelist,playercode,date]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getupdate :(NSString *)updatelist :(NSString *)usercode :(NSString *)workload :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@",updatelist,usercode,workload,date,playercode,code1,code2,code3,code4]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)getremove :(NSString *)removelist :(NSString *)usercode :(NSString *)workload success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",removelist,usercode,workload]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
#pragma FetchInjury
-(void)getFetchinjuryList:(NSString *)fetchInjury:(NSString*)usercode success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",fetchInjury,usercode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getTRLDetails :(NSString *)list :(NSString *)usercode  success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",list,usercode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getFetchMetadataList:(NSString *)fetchmetadata success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",fetchmetadata]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getFetchGameandTeam :(NSString *)fetchgameandTeam :(NSString *)cliendcode success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",fetchgameandTeam,cliendcode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)getinjuryDelete :(NSString *)deleteInjury :(NSString *)selectinjurycode :(NSString *)usercode success:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",deleteInjury,selectinjurycode,usercode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)RemoveDtls :(NSString *)list :(NSString *)usercode :(NSString *)playercode:(NSString *)Workcode:(NSString *)dd:(NSString *)metaCode success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",list,usercode,playercode,Workcode,dd,metaCode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)dateTrl :(NSString *)list :(NSString *)date :(NSString *)plycode success:(WebserviceRequestSuccessHandler)success
        failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",list,date,plycode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)AddActivityDetails :(NSString *)list :(NSString *)usercode :(NSString *)date :(NSString *)plycode :(NSString *)code1  :(NSString *)code2 :(NSString *)time :(NSString *)balls success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@",list,usercode,date,plycode,code1,code2,time,balls]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)FilterReport :(NSString *)list :(NSString *)value1 :(NSString *)usercode :(NSString *)value2  success:(WebserviceRequestSuccessHandler)success
             failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",list,value1,usercode,value2]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)SecFilterReport :(NSString *)list :(NSString *)usercode  success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",list,usercode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getGraphsDetails :(NSString *)list :(NSString *)clientcode :(NSString *)strDate :(NSString *)enddate :(NSString *)playerCode :(NSString *)Axcode1 :(NSString *)Axcode2  success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",list,clientcode,strDate,enddate,playerCode,Axcode1,Axcode2]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)GetPlayers:(NSString *)list :(NSString *)clientcode   success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",list,clientcode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)trainingLoadDropDown :(NSString *)codelist :(NSString *)playercode :(NSString *)date  success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",codelist,playercode,date]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)fetchTrainingLoad :(NSString *)codelist :(NSString *)playercode  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",codelist,playercode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)fetchTrainingLoadDate :(NSString *)codelist :(NSString *)playercode :(NSString *)date  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",codelist,playercode,date]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)BowlingLoad :(NSString *)codelist :(NSString *)clientcode :(NSString *)playercode  :(NSString *)date :(NSString *)type  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",codelist,clientcode,playercode,date,type]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)trainingGraphFilter :(NSString *)codelist :(NSString *)clientcode  :(NSString *)playercode :(NSString *)barvalue :(NSString *)linevalue :(NSString *)workdate :(NSString *)type  success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",codelist,clientcode,playercode,barvalue,linevalue,workdate,type]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)CoachWellnessGraph :(NSString *)codelist :(NSString *)playercode  :(NSString *)date :(NSString *)charttype   success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",codelist,playercode,date,charttype]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)CoachTrainingGraph :(NSString *)codelist :(NSString *)clientcode :(NSString *)playercode  :(NSString *)date :(NSString *)charttype   success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",codelist,clientcode,playercode,date,charttype]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)Battingpitchmap :(NSString *)list :(NSString *)playercode :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",list,playercode,matchcode,innno]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)BattingWagonWheel :(NSString *)list :(NSString *)playercode :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",list,playercode,matchcode,innno]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)GetVideoPathFile :(NSString *)list : (NSString *) batsmanCode : (NSString *) matchCode: (NSString *) inns: (NSString *) value: (NSString *) batOrBowl success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure{
    
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",list,batsmanCode,matchCode,inns,value,batOrBowl]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
    
}
-(void)LoadFieldingSummaryByInnins :(NSString *)list :(NSString *)matchStatus  :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                            failure:(WebserviceRequestFailureHandler)failure{
    
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@",list,matchcode,matchStatus,innno]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
    
}

-(void)matchtypesummary :(NSString *)list :(NSString *)matchcode :(NSString *)matchstatus success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",list,matchcode,matchstatus]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)SingledaySession :(NSString *)list :(NSString *)matchcode :(NSString *)matchtype :(NSString *)sessionNo :(NSString *)innNo success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",list,matchcode,matchtype,sessionNo,innNo]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)sessionsummary :(NSString *)list :(NSString *)matchcode :(NSString *)matchstatus:(NSString *)dayno:(NSString *)sessionno:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",list,matchcode,matchstatus,dayno,sessionno,innno]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}


-(void)TeamStandings :(NSString *)list :(NSString *)Competitioncode  success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@",list,Competitioncode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)Overview :(NSString *)list :(NSString *)Competitioncode :(NSString *)teamcode  success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",list,Competitioncode,teamcode]];
    NSLog(@"urlString = %@",urlString);
    
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}



#pragma mark - Helpers

- (void)sendRequestWithURLString:(NSString *)url
                   andParameters:(NSDictionary *)parameters
                          method:(const NSString *)method
         completionSucessHandler:(WebserviceRequestSuccessHandler)sucesshandler
        completionFailureHandler:(WebserviceRequestFailureHandler)failurehandler
{
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (method == ServiceGet)
    {
        [self GET:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseDict)
         {
             if (sucesshandler){
                 //if([responseDict objectForKey:@"error"]){
                 // }
                 sucesshandler(operation,responseDict);
             }
         }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler){
                 NSLog(@"response ");
                 failurehandler(operation, error);
             }
         }];
    }
    else
    {
        [self POST:url parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseDict)
         {
             if (sucesshandler){
                 //if([responseDict objectForKey:@"error"]){
                 //}
                 sucesshandler(operation,responseDict);
             }
         }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler) failurehandler(operation,error);
         }];
    }
}

-(void)cancelRequest
{
    [self.operationQueue cancelAllOperations];
}

-(void)getIPLTeamCodessuccess:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure
{
    NSString* URL = URL_FOR_RESOURCE(@"FETCH_IPLTEAMS");
    
        //    NSString* URL = URL_FOR_RESOURCE(@"FETCH_IPLTEAMSTEMP");
    [self GET:URL parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseDict)
     {
     if (success){
         success(operation,responseDict);
     }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     if (failure){
         NSLog(@"response");
         failure(operation, error);
     }
     }];
    
}
@end

