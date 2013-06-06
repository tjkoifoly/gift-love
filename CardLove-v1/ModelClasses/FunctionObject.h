//
//  FunctionObject.h
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
#import "UIView+Badge.h"

@interface FunctionObject : NSObject

+(id)sharedInstance;

- (NSDate *)dateFromString:(NSString *)string;
-(NSString *) dataFilePath: (NSString *) comp;
-(BOOL)fileHasBeenCreatedAtPath:(NSString *)path;
-(void)createNewFolder: (NSString *)foleder;
-(NSString *)stringFromDateTime: (NSDate *) date;
-(NSDate *)dateFromStringDateTime: (NSString *) dateString;
-(NSString *)stringFromDate: (NSDate *) date;

-(void) uploadGift:(NSData *) data withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error, NSString *urlUpload))completionBlock;
-(void) dowloadFromURL: (NSString *) urlString toPath:(NSString *) pathSave  withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;

-(void) sendGift: (NSString *)urlGift withParams:(NSDictionary *)params  completion:(void (^)(BOOL success, NSError *error))completionBlock;

-(void) openGift:(NSString *)giftID completion:(void (^)(BOOL success, NSError *error))completionBlock;

-(void) loadNotificationsbyUser: (NSString*)userID completion:(void (^)(BOOL success, NSError *error, id result))completionBlock;

-(void) responeRequestWithUser:(NSString *)userID person:(NSString *)friendID  preRelationship:(NSString *)rsID andState:(NSString *)rsStatus completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)sendPhoto: (NSData *) imgData WithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error, NSString *urlUpload))completionBlock ;
-(void) updatePhotoMessage:(NSString *)msID withLink:(NSString *)urlString andType:(NSString *)type completion:(void (^)(BOOL success, NSError *error)) completionBlock;

-(NSMutableArray *) filterGift:(NSArray *)list bySender:(NSString *) senderID;
-(NSMutableArray *) filterGift:(NSArray *)list byReciver:(NSString *) reciverID;

-(void) readMessagesOfPerson:(NSString *) senderID completion:(void (^)(BOOL success, NSError *error))completionBlock;

//ZIP
-(void) unzipFileAtPath:(NSString *)pathFile toPath:(NSString *)unzipPath withCompetionBlock:(void(^)(NSString *pathToOpen))completionBlock;
-(void ) saveAsZipFromPath:(NSString *)fromPath toPath:(NSString *)toPath withCompletionBlock:(void(^)(NSString *pathResult))completionBlock;

-(void) setNewBadgeWithValue: (NSInteger) badge forView:(UIView *) viewBadge;

 @end
