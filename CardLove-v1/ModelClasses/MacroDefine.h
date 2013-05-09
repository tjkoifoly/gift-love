//
//  MacroDefine.h
//  CardLove-v1
//
//  Created by FOLY on 4/6/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+GIF.h"
#import "OLImage.h"
#import "OLImageView.h"

#define kNewProject     @"NewTemplate"
#define kProjects       @"Projects"
#define kGift           @"Gifts"
#define kCards          @"Cards"
#define kPackages       @"Packages"
#define kDowndloads     @"Downloads"

#define kIndex          @"index.tjkoifoly"
#define kMusic          @"music.tjkoifoly"
#define kAnimation      @"animation.tjkoifoly"
#define kElements       @"elements.tjkoifoly"
#define kConfig         @"gift-config.tjkoifoly"

#define kBounds     @"bounds"
#define kCenter     @"center"
#define kTransfrom  @"transform"
#define kPhoto      @"photo"
#define kImgURL     @"imageURL"
#define kBorderWidth @"borderWidth"
#define kBorderColor @"borderColor"
#define kBorderOpacity @"borderOpacity"
#define kBorderRadius @"borderRadius"
#define kShadowOffset @"shadowOffset"
#define kShadowColor @"shadowColor"
#define kShadowOpacity @"shadowOpacity"
#define kShadowRadius @"shadowRadius"

#define kNoEff @"no-eff"

#define kNotificationGifSelected        @"NotificationGifSelected"
#define kNotificationGiftConfig         @"NotificationGiftConfig"
#define kNotificationChatWithPerson     @"NotificationChatWithPerson"
#define kNotificationAddPersonToGroup           @"NotificationAddPersonToGroup"
#define kNotificationRemovePersonFromGroup      @"NotificationRemovePersonFromGroup"
#define kNotificationSendGiftToFriend   @"NotificationSendGiftToFriend"
#define kNotificationSignUpSuccessful @"NotificaionSignUpSuccessful" 

#define kGiftPaper      @"gift-paper"
#define kGiftBG         @"gift-bg"
#define kGiftFrame      @"gift-frame"
#define kGiftMessage    @"gift-message"

#define kAccID          @"accID"
#define kAccDisplayName @"accDisplayName"
#define kAccName        @"accName"
#define kAccPassword    @"accPassword"
#define kAccGender      @"accGender"
#define kAccEmail       @"accEmail"
#define kAccBirthday    @"accBirthday"
#define kAccPhone       @"accPhone"
#define kaccAvata       @"accImageAvata"

typedef enum {
    NavigationBarModeEdit,
    NavigationBarModeView
}NavigationBarMode;

typedef enum {
    FriendRequest,
    FriendSuccessful,
    Rejected
}FriendType;

