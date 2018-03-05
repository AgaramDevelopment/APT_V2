//
//  Config.h
//  AlphaProTracker
//
//  Created by Mac on 21/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

#define screen_width                    [[UIScreen mainScreen] bounds].size.width
//#define  IS_IPAD_DEVICE (([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)?NO:YES)

#define IS_IPHONE_DEVICE                (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?NO:YES)

#define IS_IPHONE4                      (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)

#define IS_IPHONE5                      (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE6                      (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE6_Plus                 (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

//#define IS_IPAD                         (([[UIScreen mainScreen] bounds].size.height-768)?NO:YES)
#define IS_IPAD ( [[[UIDevice currentDevice] model] isEqualToString:@"iPad"])


// OS Versions
#define IS_GREATER_IOS7                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)

#define IS_GREATER_IOS8                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO)

#define IS_GREATER_IOS9                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)?YES:NO)

//SIZE
#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

//Image
#define IMAGE(_name)                    [UIImage imageNamed:_name]
#define IMAGETOCOLOR(_name)             [UIColor colorWithPatternImage:IMAGE(_name)]

#pragma mark - FONTS

#define FontAwesome(_size)              [UIFont fontWithName:@"fontawesome-webfont.ttf" size:_size]

#define FutworaPro_Regular(_size)       [UIFont fontWithName:@"FutworaPro-Regular.otf" size:_size]

#define Patron_Black(_size)             [UIFont fontWithName:@"Patron-Black.ttf" size:_size]

#define Patron_BlackItalic(_size)       [UIFont fontWithName:@"Patron-BlackItalic.ttf" size:_size]

#define Patron_Bold(_size)              [UIFont fontWithName:@"Patron-Bold.ttf" size:_size]

#define Patron_BoldItalic(_size)        [UIFont fontWithName:@"Patron-BoldItalic.ttf" size:_size]

#define Patron_ExtraLight(_size)        [UIFont fontWithName:@"Patron-ExtraLight.ttf" size:_size]

#define Patron_ExtraLightItalic(_size)  [UIFont fontWithName:@"Patron-ExtraLightItalic.ttf" size:_size]

#define Patron_Italic(_size)            [UIFont fontWithName:@"Patron-Italic.ttf" size:_size]

#define Patron_Medium(_size)            [UIFont fontWithName:@"Patron-Medium.ttf" size:_size]

#define Patron_MediumItalic(_size)      [UIFont fontWithName:@"Patron-MediumItalic.ttf" size:_size]

#define Patron_Regular(_size)           [UIFont fontWithName:@"Patron-Regular.ttf" size:_size]

#define Patron_Thin(_size)              [UIFont fontWithName:@"Patron-Thin.ttf" size:_size]

#define Patron_ThinItalic(_size)        [UIFont fontWithName:@"Patron-ThinItalic.ttf" size:_size]

#define PATRON_BOLD(Value)              [UIFont fontWithName:@"Patron-Bold" size:Value]

#define PATRON_REG(Value)               [UIFont fontWithName:@"Patron-Regular" size:Value]

#define appDel  ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define Nag_BG_Image                   [UIImage imageNamed:@"bgImg"]

#define DEFAULT_COLOR_BLUE [UIColor colorWithRed:(28/255.0f) green:(25/255.0f) blue:(64/255.0f) alpha:1.0]

#define DEFAULT_BG_IMG_COLOR  [UIColor colorWithRed:(28/255.0f) green:(70/255.0f) blue:(126/255.0f) alpha:1.0]

#define URL_FOR_AssessmentPlayer           @"http://192.168.1.84:8045"

#define LoginKey                          @"UserLoginAuthentication"

#define PlannerEventKey                   @"InitPlanner"

#define AssementKey                       @"FETCH_MODULE_ASSESSMENT"

#define playerListKey                     @"FETCHASSESSMENTENTRY"

#define questionaryKey                    @"FETCHQUESTIONNAIRE"

#define DatequestionaryKey                @"READQUESTIONNAIRE"

#define SavequestionaryKey                @"QUESTIONNAIRE"

#define profileKey                        @"CoachDashboard"

#define playerDetailsKey                  @"DASHBORDPLAYERLISTCHANGE"

#define EventDateFetch                    @"FetchEventDetails"

# define FetchParticipantType             @"FetchEventTemplateParticipants"

#define FetchParticipantPlayerDetail      @"FetchEventTemplatePlayerDetails"

#define PlannerInsert                     @"InsertEventDetails"

#define DeletePlanner                     @"DeleteEventDetails"

#define UpdatePlanner                     @"UPDATEEVENTDETAILS"

#define FetchEditPlanner                  @"FetchEventDetailsBasedOnEventCode"

#define FetchFooddetails                  @"FETCHFOODDETAILS"

#define FetchInitfoodDiary                @"FETCH_INIT_FOOD_DIARY"

#define metasubKey                        @"FETCH_WLM_WELLNESS_DETAILS"

#define foodDairyUpdate                   @"UPDATE_FOOD_DIARY"

#define FooddiaryDelete                   @"DELETE_FOOD_DIARY"

#define FoodDiaryInsert                   @"INSERT_FOOD_DIARY"

#define dateValidation                    @"FETCH_WORKLOAD_WELLNESS_BYPLAYERNAME"

#define recordInsert                      @"MOBILE_INSERT_WORKLOAD_WELLNESS_RATING"

#define FetchrecordWellness                     @"MOBILE_FETCH_WORKLOAD_WELLNESS"

#define updateRecord                      @"MOBILE_UPDATE_WORKLOAD_WELLNESS_RATING"

#define removeRecord                      @"DELETE_WORKLOAD_WELLNESS_RATING"

//#define FetchInjuryList                   @"FETCH_INJURY"

#define FetchInjuryList                   @"FETCHLOADINJURYWEB"

#define TRDetailsKey                      @"GET_TRAININGLOAD_DETAILS"

#define FetchMetadata                     @"FETCH_INJURY_METADATA"

#define FetchGameTeam                     @"FETCH_GAME_TEAM_PLAYER"

#define injuryDelete                      @"DELETE_INJURY_DETAILS"

#define injuryInsert                      @"INSERT_INJURY_DETAILS"

#define injuryUpdate                      @"UPDATE_INJURY_DETAILS"

#define fetchillness                      @"FETCH_ILLNESS"

#define inesertIllness                    @"INSERT_ILLNESS_DETAILS"

#define UpdateIllness                     @"UPDATE_ILLNESS_DETAILS"

#define deleteIllness                     @"DELETE_ILLNESS_DETAILS"

#define illnessFetchload                  @"FETCH_ILLNESS_METADATA"

#define TRDetailsKey                      @"GET_TRAININGLOAD_DETAILS"

#define RemoveKey                         @"DELETE_TRAININGLOAD_DETAILS"

#define dateTrLKey                        @"GET_TRAININGLOAD"

#define addActivityKey                    @"INSERT_TRAININGLOAD_DETAILS"

#define GraphsKey                         @"GET_WORK_LOAD_CHART_REPORT"

#define FilterKey                         @"GET_WORKLOADWELLNESS_DETAILS"

#define FilterKey2                        @"FETCH_GAME_TEAM_PLAYER"

#define UpdateRecord                      @"MULTIPLE_UPDATE_TRAINING_LOAD_DETAILS"

#define synData                           @"FETCH_ASSESSMENTTESTBASIS_MASTERADATA"

#define programKey                        @"FETCHPROGRAM"

#define ProgarmSaveKey                    @"INSERTPROGRAM"

#define ProgarmEditKey                    @"EDITPROGRAM"

#define ProgarmDeleteKey                  @"DELETEPROGRAM"

#define ProgarmUpadteKey                  @"UPDATEPROGRAM"

#define programAssignKey                  @"FETCHPROGRAMPLAYER"

#define programAssignSaveKey              @"INSERTPROGRAMPLAYER"

#define playerAssignKey                   @"FETCH_GAME_TEAM_PLAYER"

#define EditAssignKey                     @"EDITPROGRAMPLAYER"

#define UpdateAssignKey                   @"UPDATEPROGRAMPLAYER"

#define DeleteAssignKey                   @"DELETEPROGRAMPLAYER"

#define FetchModuleKey                    @"FETCHASSESSMENTENTRY"

#define MultiInjuryAddeKey                    @"MULTIINJURYINSERT"

#define deleteRowKey                    @"DELETEROW"

#define OPENPLAYEREXERCISEDETAILS                    @"OPENPLAYEREXERCISEDETAILS"

#define MultiInjuryUpdateKey                    @"MULTIINJURYUPDATE"

#define AllPlayerProgramKey               @"GETALLPLAYERPROGRAMS"

#define fetchMultiInjuryKey               @"UPDATEGRID"

#define pushServiceKey               @"FETCH_ASSESSMENTTESTBASIS_ASSESSMENTINSERT"

#define FetchSinglePlayerKey                @"FETCHSINGLEPLAYERCHART"

#define FetchSinglePlayerChartKey                @"SINGLEPLAYERCHART"

#define FetchMultiPlayerKey                @"FETCHMULTIPLAYERCHART"

#define FetchMultiPlayerChartKey                @"MULTIPLAYERCHART"

#define GroupChatKey                        @"CREATENEWGROUP"

#define FetchAllMessageKey                @"SHOWALLMESSAGES"

#define SendMessageKey                @"SENDREPLYMESSAGES_ANDROID"

#define SendBroadCastMessageKey                @"SENDNEWMESSAGES_ANDROID"

#define ScheduleKey                @"GETEVENTSSCHEDULE"

#define playerMyStatsBatting               @"MOBILE_GETMYSTATSBATTING"

#define playerMyStatsBowling               @"MOBILE_GETMYSTATSBOWLING"
//Gallery Video

#define  GalleryVideo              @"MOBILE_VIDEOGALLERY"
#define FetchVideoUpload           @"FETCHVIDEOUPLOAD"
#define VideoUpload                @"MOBILE_VIDEOUPLOADSAVE"

//Wagon Wheel And Pitch Map
#define ScorecardWagonKey           @"GETSCORECARDBATTINGSPIDERWAGONWHEEL"

#define ScorecardPitchmapKey                           @"FETCH_SCORECARD_PITCHMAP"

#define  TraingLoadDropKey              @"MOBILE_GETTRAININGLOAD"


#define  trainingSaveKey              @"MOBILE_INSERT_TRAININGLOAD_DETAILS"

#define  trainingUpdateKey              @"MOBILE_UPDATE_TRAININGLOAD_DETAILS"

#define  fetchTrainingLoadKey              @"MOBILE_GETTRAININGLOADDETAILS"

#define  fetchTrainingLoadDateKey              @"MOBILE_GETTRAININGLOAD"

#define  BowlingLoadKey              @"MOBILE_BOWLINGLOADCHART"

#define  TeamsKey              @"MOBILE_FETCHTEAM"

#define  playersKey              @"MOBILE_FETCHTEAMPlayer"

#define foodDiaryFetch         @"MOBILE_FETCHFOODDETAILS"

#define foodDiaryInsert        @"MOBILE_INSERT_FOOD_DIARY"

#define foodDiaryUpdate        @"MOBILE_UPDATE_FOOD_DIARY"

#define  dropdownActivityKey              @"MOBILE_GETTRAININGLOADGRAPH"

#define  RecentplayerDetailsKey       @"MOBILE_RECENTDETAILS"

#define  coachWellnessKey              @"MOBILE_FETCH_WORKLOAD_WELLNESSCHART"

#define  coachTrainingKey              @"MOBILE_GETTRAININGLOADCHART"

#define  RecentplayerFitnessKey       @"MOBILE_RECENTDETAILSFITNESS"

#define ScorecardKey                               @"FETCHSCORECARD"

#define ScorecardWagonKey                             @"GETSCORECARDBATTINGSPIDERWAGONWHEEL"

#define ScorecardPitchmapKey                           @"FETCH_SCORECARD_PITCHMAP"
#define ScorecardPitchbowlmapKey                           @"FETCH_SCORECARD_PITCHMAP_BOWLING"

#define GetVideoFilePath       @"GETSCORECARDVIDEOSFILEPATH"

#define LoadFieldSummary       @"LOADFIELDSUMMARY"

#define MatchTypeKey                             @"LOADSESSIONSUMMARY"
#define SingledayKey                             @"LOADSESSIONSUMMARYSINGLEDAYDETAILS"

#define SessionKey                             @"LOADSESSIONSUMMARYDETAILS"

#define fetchLoadInjury         @"FETCHLOADINJURYWEB"

#define fetchLoadIllness         @"FETCHLOADILLNESSWEB"

#define recentFitnessKey         @"MOBILE_RECENTDETAILSFITNESSCHART"

#define HTHPageLoad         @"APT_HTHPAGELOAD"
#define HTHResults         @"APT_HTHRESULTS"

#define StandingsKey         @"APT_TEAMRESULTS"

#define teamBattingKey         @"APT_TEAMBATTING"

#define OverviewKey         @"APT_TEAMOVERVIEW"
