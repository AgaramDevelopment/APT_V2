//
//  WebService.h
//  UPCA
//
//  Created by Mac on 11/05/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

typedef void (^WebserviceRequestSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

typedef void (^WebserviceRequestFailureHandler)(AFHTTPRequestOperation  *operation, id error);

typedef void (^WebserviceRequestXMLSuccessHandler)(AFHTTPRequestOperation  *operation);
typedef void (^WebserviceRequestXMLFailureHandler)(AFHTTPRequestOperation  *operation, NSError *error);

#pragma Local URL
//#define BASE_URL  @"http://119.226.98.154:8002/FanZone/FanEngagement.svc/"     //@"http://www.dindiguldragons.com:8002/FanZone/FanEngagement.svc/"

#pragma Testing Url

    // LIVE
#define BASE_URL    @"http://13.126.151.253:9001/AGAPTService.svc/"

//Local Dev
//#define BASE_URL    @"http://192.168.0.151:8044/AGAPTService.svc/"
#define IMAGE_URL   @"http://192.168.0.151:8045/"
#define Video_URL   @"http://192.168.0.151:8044/"
#define BASE_Image_URL @"http://192.168.0.151:8045/bcciapp/"


//#define BASE_URL   @"http://192.168.0.151:8029/AGAPTService.svc/"
//#define IMAGE_URL   @"http://192.168.0.151:8030/"
//#define Video_URL   @"http://192.168.0.151:8029/"

//#define BASE_URL   @"http://192.168.1.84:8044/AGAPTService.svc/"
//#define IMAGE_URL   @"http://192.168.1.84:8045/"


//#define BASE_URL   @"http://192.168.1.84:8039/AGAPTService.svc/"

//#define BASE_URL  @"http://13.126.151.253:9001/AGAPTService.svc/"
//#define IMAGE_URL   @"http://13.126.151.253:9000/"

//#define BASE_URL  @"http://192.168.1.209:8005/AGAPTService.svc/"
//#define BASE_URL  @"http://13.126.151.253:9001/AGAPTService.svc/"


//#ifdef DEBUG
//#define push_type   @"dev"
//#else
//#define push_type   @"pro"
//#endif

#define URL_FOR_RESOURCE(RESOURCE) [NSString stringWithFormat:@"%@%@",BASE_URL,RESOURCE]




@interface WebService : AFHTTPRequestOperationManager

+ (WebService *)service;

//-(void)getCheckrequeststatus:(NSString *) checkrequest
//          requestsenduserid :(NSString *) requestsenduserid
//                   sessionID:(NSString *) sessionid
//                     success:(WebserviceRequestSuccessHandler)success
//                     failure:(WebserviceRequestFailureHandler)failure;

-(void)cancelRequest;



-(void)getLogin :(NSString *) loginValue :(NSString *) userName:(NSString *)password success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure;

-(void)getAssesmentlist :(NSString *)asmtlist :(NSString *)clientCode :(NSString *)moduleCode :(NSString *)createdby success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;
-(void)getmetacodelist :(NSString *)codelist :(NSString *)clientCode :(NSString *)rcCode success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure;
-(void)getdatelist :(NSString *)codelist :(NSString *)playercode :(NSString *)date success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure;

-(void)submit :(NSString *)codelist :(NSString *)clientCode :(NSString *)usercode :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 :(NSString *)bodyWeight :(NSString *)sleephr :(NSString *)fat :(NSString *)restinghr :(NSString *)restingbpMax :(NSString *)restingbpMin :(NSString *)urinecolor success:(WebserviceRequestSuccessHandler)success
       failure:(WebserviceRequestFailureHandler)failure;

-(void)getupdate :(NSString *)updatelist :(NSString *)usercode :(NSString *)wlcode :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;
-(void)getremove :(NSString *)removelist :(NSString *)usercode :(NSString *)workload success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

-(void)getFetchinjuryList:(NSString *)fetchInjury:(NSString*)usercode success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure;
-(void)getTRLDetails :(NSString *)list :(NSString *)usercode  success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure ;
-(void)getFetchMetadataList:(NSString *)fetchmetadata success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure;

-(void)getFetchGameandTeam :(NSString *)fetchgameandTeam :(NSString *)cliendcode success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure;

-(void)getinjuryDelete :(NSString *)deleteInjury :(NSString *)selectinjurycode :(NSString *)usercode success:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure;

-(void)RemoveDtls :(NSString *)list :(NSString *)usercode :(NSString *)playercode:(NSString *)Workcode:(NSString *)dd:(NSString *)metaCode success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure;

-(void)dateTrl :(NSString *)list :(NSString *)date :(NSString *)plycode success:(WebserviceRequestSuccessHandler)success
        failure:(WebserviceRequestFailureHandler)failure;

-(void)AddActivityDetails :(NSString *)list :(NSString *)usercode :(NSString *)date :(NSString *)plycode :(NSString *)code1  :(NSString *)code2 :(NSString *)time :(NSString *)balls success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure;

-(void)FilterReport :(NSString *)list :(NSString *)value1 :(NSString *)usercode :(NSString *)value2  success:(WebserviceRequestSuccessHandler)success
             failure:(WebserviceRequestFailureHandler)failure;

-(void)SecFilterReport :(NSString *)list :(NSString *)usercode  success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure;

-(void)getGraphsDetails :(NSString *)list :(NSString *)clientcode :(NSString *)strDate :(NSString *)enddate :(NSString *)playerCode :(NSString *)Axcode1 :(NSString *)Axcode2  success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;

-(void)GetPlayers:(NSString *)list :(NSString *)clientcode   success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure ;

-(void)fetchWellness :(NSString *)codelist :(NSString *)playercode :(NSString *)date success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;

-(void)trainingLoadDropDown :(NSString *)codelist :(NSString *)playercode :(NSString *)date  success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure;

-(void)fetchTrainingLoad :(NSString *)codelist :(NSString *)playercode  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure;
-(void)UpdateWellness :(NSString *)codelist :(NSString *)clientCode :(NSString *)usercode :(NSString *)workLoadCode :(NSString *)date :(NSString *)playercode :(NSString *)code1 :(NSString *)code2 :(NSString *)code3 :(NSString *)code4 :(NSString *)bodyWeight :(NSString *)sleephr :(NSString *)fat :(NSString *)restinghr :(NSString *)restingbpMax :(NSString *)restingbpMin :(NSString *)urinecolor success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure;

-(void)fetchTrainingLoadDate :(NSString *)codelist :(NSString *)playercode :(NSString *)date  success:(WebserviceRequestSuccessHandler)success
                      failure:(WebserviceRequestFailureHandler)failure;

-(void)BowlingLoad :(NSString *)codelist :(NSString *)clientcode :(NSString *)playercode  :(NSString *)date :(NSString *)type  success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure;

-(void)trainingGraphFilter :(NSString *)codelist :(NSString *)clientcode  :(NSString *)playercode :(NSString *)barvalue :(NSString *)linevalue :(NSString *)workdate :(NSString *)type  success:(WebserviceRequestSuccessHandler)success
                    failure:(WebserviceRequestFailureHandler)failure;

-(void)CoachWellnessGraph :(NSString *)codelist :(NSString *)playercode  :(NSString *)date :(NSString *)charttype   success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure;

-(void)CoachTrainingGraph :(NSString *)codelist :(NSString *)clientcode :(NSString *)playercode  :(NSString *)date :(NSString *)charttype   success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure;

-(void)Battingpitchmap :(NSString *)list :(NSString *)playercode :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                failure:(WebserviceRequestFailureHandler)failure;

-(void)BattingWagonWheel :(NSString *)list :(NSString *)playercode :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure;

-(void)GetVideoPathFile :(NSString *)list : (NSString *) batsmanCode : (NSString *) matchCode: (NSString *) inns: (NSString *) value: (NSString *) batOrBowl success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;
-(void)LoadFieldingSummaryByInnins :(NSString *)list :(NSString *)matchStatus  :(NSString *)matchcode:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
                            failure:(WebserviceRequestFailureHandler)failure;
-(void)matchtypesummary :(NSString *)list :(NSString *)matchcode :(NSString *)matchstatus success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;

-(void)SingledaySession :(NSString *)list :(NSString *)matchcode :(NSString *)matchtype :(NSString *)sessionNo :(NSString *)innNo success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;

-(void)sessionsummary :(NSString *)list :(NSString *)matchcode :(NSString *)matchstatus:(NSString *)dayno:(NSString *)sessionno:(NSString *)innno success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure;

-(void)TeamStandings :(NSString *)list :(NSString *)Competitioncode  success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;

-(void)Overview :(NSString *)list :(NSString *)Competitioncode :(NSString *)teamcode  success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure;



@end

