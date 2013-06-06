//
//  FunctionObject.m
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "FunctionObject.h"
#import "AFNetworking.h"
#import "NKApiClient.h"
#import "JSONKit.h"
#import "UserManager.h"

@implementation FunctionObject

+(id) sharedInstance
{
    static FunctionObject *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[FunctionObject alloc] init];
    });
    
     return __instance;
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat dateFromString:string];
}

-(NSString *)stringFromDate: (NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSString *)stringFromDateTime: (NSDate *) date
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];

    NSString *dateOput = [df_local stringFromDate:date];
    return dateOput;
}

-(NSDate *)dateFromStringDateTime: (NSString *) dateString
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
    
    NSDate *dateOput = [df_local dateFromString:dateString];
    return dateOput;
}

-(NSString *) dataFilePath: (NSString *) comp
{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return  [docsDir stringByAppendingPathComponent:comp];
}

-(BOOL)fileHasBeenCreatedAtPath:(NSString *)path
{
    BOOL result = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:path])
    {
        result = YES;
    }
    
    return result;
}

-(void)createNewFolder: (NSString *)foleder
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    newDir = [docsDir stringByAppendingPathComponent:foleder];
    
    BOOL isDir;
    if([filemgr fileExistsAtPath:newDir isDirectory:&isDir])
    {
        if (!isDir) {
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
                NSLog(@" Failed to create directory");
            }
        }
    }else if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
        NSLog(@" Failed to create directory");
    }
}

-(void) uploadGift:(NSData *) data withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error, NSString *urlUpload))completionBlock
{
    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    NSDictionary *params = @{
                             @"gift-love[location]" : @"VN",
                             @"gift-love[submitted_by]" : @"foly",
                             @"gift-love[comments]" : @"No"
                             };
    
    NSURLRequest *postRequest = [[NKApiClient shareInstace] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"upload_gift.php"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id formData) {
                                                                     [formData appendPartWithFileData:data
                                                                                                 name:@"avatar"
                                                                                             fileName:[NSString stringWithFormat:@"gift.zip"]
                                                                                             mimeType:@"application/zip"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CODE = %i", operation.response.statusCode);
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"GIFT UPLOAD = %@", responseObject);
            
            NSString *urlImage = [responseObject objectAtIndex:0];
            NSLog(@"URL = %@", urlImage);
            completionBlock(YES, nil, urlImage);
            
            
        } else {
            completionBlock(NO, nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error, nil);
        NSLog(@"ERROR %@", error);
    }];
    
    [[NKApiClient shareInstace] enqueueHTTPRequestOperation:operation];
}

-(void) readMessagesOfPerson:(NSString *) senderID completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[UserManager sharedInstance] accID],@"recieverID",
                                senderID,@"senderID",
                                nil];
    
    [[NKApiClient shareInstace] postPath:@"read_message.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Add friend to group = %@", jsonObject);
        
        completionBlock (YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(void) dowloadFromURL: (NSString *) urlString toPath:(NSString *) pathSave withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progress = ((CGFloat)totalBytesRead) / totalBytesExpectedToRead;
        progressBlock(progress);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
        NSLog(@"ERROR %@", error);
    }];
     operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathSave append:NO];
    
    [[NKApiClient shareInstace] enqueueHTTPRequestOperation:operation];
}



-(void) sendGift: (NSString *)urlGift withParams:(NSDictionary *)params  completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [dictParams setValue:urlGift forKey:@"gfResources"];
    
    [[NKApiClient shareInstace] postPath:@"send_gift.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result = %@", jsonObject);
        
        completionBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
    
}

-(void) loadNotificationsbyUser: (NSString*)userID completion:(void (^)(BOOL success, NSError *error, id result))completionBlock{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID", nil];
    [[NKApiClient shareInstace] postPath:@"get_notifications.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON NOTIFICATIONS = %@", jsonObject);
        
        completionBlock (YES, nil, jsonObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil, nil);
    }];
}


-(void) responeRequestWithUser:(NSString *)userID person:(NSString *)friendID  preRelationship:(NSString *)rsID andState:(NSString *)rsStatus completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID, @"sourceID",
                                friendID, @"friendID",
                                rsID, @"rsID",
                                rsStatus, @"rsStatus",
                                 nil];
    
    [[NKApiClient shareInstace] postPath:@"respone_friend_request.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result = %@", jsonObject);
        
        completionBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

- (void)sendPhoto: (NSData *) imgData WithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error, NSString *urlUpload))completionBlock {
    
    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    NSDictionary *params = @{
                             @"gift-love[location]" : @"VN",
                             @"gift-love[submitted_by]" : @"foly",
                             @"gift-love[comments]" : @"No"
                             };
    
    NSURLRequest *postRequest = [[NKApiClient shareInstace] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"upload_image.php"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id formData) {
                                                                     [formData appendPartWithFileData:imgData
                                                                                                 name:@"avatar"
                                                                                             fileName:@"photo.png"
                                                                                             mimeType:@"image/png"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CODE = %i", operation.response.statusCode);
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"OBJECT = %@", responseObject);
            
            NSString *urlImage = [responseObject objectAtIndex:0];
            NSLog(@"URL = %@", urlImage);
            completionBlock(YES, nil, urlImage);
            
            
        } else {
            completionBlock(NO, nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error, nil);
        NSLog(@"ERROR %@", error);
    }];
    
    [[NKApiClient shareInstace] enqueueHTTPRequestOperation:operation];
};

-(void) updatePhotoMessage:(NSString *)msID withLink:(NSString *)urlString andType:(NSString *)type completion:(void (^)(BOOL success, NSError *error)) completionBlock
{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                msID, @"msID",
                                urlString, @"msLink",
                                type, @"type"
                                , nil];
    
    [[NKApiClient shareInstace] postPath:@"update_sent_photo.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result = %@", jsonObject);

        completionBlock(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
        NSLog(@"ERROR %@", error);
    }];
}

-(void) openGift:(NSString *)giftID completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:giftID,@"gfID", nil];
    
    [[NKApiClient shareInstace] postPath:@"open_gift.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject= [[JSONDecoder decoder] objectWithData:responseObject];
        NSLog(@"JSON Result = %@", jsonObject);
        
        completionBlock(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP ERROR = %@", error);
        completionBlock(NO, nil);
    }];
}

-(NSMutableArray *) filterGift:(NSArray *)list bySender:(NSString *) senderID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"gfSenderID" , senderID];
    NSMutableArray *result = [NSMutableArray arrayWithArray:list];
    
    [result filterUsingPredicate:predicate];
    
    return result;
}

-(NSMutableArray *) filterGift:(NSArray *)list byReciver:(NSString *) reciverID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"gfRecieverID" , reciverID];
    NSMutableArray *result = [NSMutableArray arrayWithArray:list];
    
    [result filterUsingPredicate:predicate];
    
    return result;
}

-(void) unzipFileAtPath:(NSString *)pathFile toPath:(NSString *)unzipPath withCompetionBlock:(void(^)(NSString *pathToOpen))completionBlock
{
    
    NSFileManager *fmgr = [[NSFileManager alloc] init] ;
    
    [fmgr createDirectoryAtPath:unzipPath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    if ([fmgr fileExistsAtPath:unzipPath]) {
        ZipArchive *za = [[ZipArchive alloc] init];
        if ([za UnzipOpenFile:pathFile]) {
            BOOL ret = [za UnzipFileTo:unzipPath overWrite:YES];
            if (NO == ret){}
            [za UnzipCloseFile];
        }
    }

    completionBlock(unzipPath);
}

-(void ) saveAsZipFromPath:(NSString *)fromPath toPath:(NSString *)toPath withCompletionBlock:(void(^)(NSString *pathResult))completionBlock
{
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:toPath];
    
    //[za addDirectoryToZip:projectPath];
    NSArray *filesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:NULL];
    NSMutableArray *mutFiles = [NSMutableArray arrayWithArray:filesInDirectory];
    
    for(id file in mutFiles)
    {
        NSLog(@"Adding file = %@ ...", file);
        [za addFileToZip:[fromPath stringByAppendingPathComponent:file] newname:file];
    }
    
    BOOL success = [za CloseZipFile2];
    
    if (success) {
        completionBlock(toPath);
    }else{
        completionBlock(nil);
    }

}


-(void) setNewBadgeWithValue: (NSInteger) badge forView:(UIView *) viewBadge
{
    viewBadge.badge.outlineWidth = 1;
    viewBadge.badge.badgeValue = badge;
    viewBadge.badge.badgeColor = [UIColor redColor];
}


@end
