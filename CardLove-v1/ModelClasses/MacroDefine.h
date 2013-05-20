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

#define kNewProject     @"NewTemplate1234567890acbdefghijklmnoprstuvwxyz"
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

#define kBounds         @"bounds"
#define kCenter         @"center"
#define kTransfrom      @"transform"
#define kPhoto          @"photo"
#define kImgURL         @"imageURL"
#define kBorderWidth    @"borderWidth"
#define kBorderColor    @"borderColor"
#define kBorderOpacity  @"borderOpacity"
#define kBorderRadius   @"borderRadius"
#define kShadowOffset   @"shadowOffset"
#define kShadowColor    @"shadowColor"
#define kShadowOpacity  @"shadowOpacity"
#define kShadowRadius   @"shadowRadius"

#define kNoEff @"no-eff"

#define kNotificationGifSelected        @"NotificationGifSelected"
#define kNotificationGiftConfig         @"NotificationGiftConfig"
#define kNotificationChatWithPerson     @"NotificationChatWithPerson"
#define kNotificationAddPersonToGroup           @"NotificationAddPersonToGroup"
#define kNotificationRemovePersonFromGroup      @"NotificationRemovePersonFromGroup"
#define kNotificationSendGiftToFriend           @"NotificationSendGiftToFriend"
#define kNotificationSignUpSuccessful           @"NotificaionSignUpSuccessful" 

#define kNotificationSendFriendRequest      @"NotificationSendFriendRequest"
#define kNotificationCancelFriendRequest    @"NotificationCancelFriendRequest"
#define kNotificationAccpetFriendRequest    @"NotificationAccpetFriendRequest"
#define kNotificationDenyFriendRequest      @"NotificationDenyFriendRequest"
#define kNotificationReloadFriendsList      @"NotificationReloadFriendsList"

#define kNotificationSendGiftFromChoice @"NotificationSendGiftFromChoice"

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

#define kSpecialDayTitle    @"sdTitle"
#define kSpecialDayDate     @"sdDay"

#define kFriendStatus @"rsStatus"

#define tagSelected 100
#define cellHeight 120
#define cellWidth 150
#define textLabelHeight 18
#define cellAAcitve 1.0
#define cellADeactive 0.3
#define cellAHidden 0.0
#define defaultFontSize 10.0

typedef void (^ActionGiftBlock)(void);

typedef enum {
    NavigationBarModeEdit,
    NavigationBarModeView
}NavigationBarMode;

typedef enum {
    FriendRequest = 1,
    FriendSuccessful,
    Rejected
}FriendType;

typedef enum {
    MessageText,
    MessageEmoticon,
    MessageImage
} MessageType;



