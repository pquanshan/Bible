//
//  ChristShareMenu.h
//  Bible
//
//  Created by yons on 14-6-17.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

//新浪微博
#define JJH_SHARE_PLATFORM_SINAWEIBO         @"sinaweibo"
//QQ空间
#define JJH_SHARE_PLATFORM_QQ                @"qqdenglu"
//人人网
#define JJH_SHARE_PLATFORM_RENREN            @"renren"
//开心网
#define JJH_SHARE_PLATFORM_KAIXIN            @"kaixin"
//腾讯微博
#define JJH_SHARE_PLATFORM_QQWEIBO           @"qqweibo"
//QQ好友
#define JJH_SHARE_PLATFORM_QQFRIEND          @"qqfriend"
//微信好友
#define JJH_SHARE_PLATFORM_WEIXIN_SESSION    @"weixin_session"
//微信朋友圈
#define JJH_SHARE_PLATFORM_WEIXIN_TIMELINE   @"weixin_timeline"
//邮件
#define JJH_SHARE_PLATFORM_EMAIL             @"email"
//短信
#define JJH_SHARE_PLATFORM_SMS               @"sms"


//#define     KShareMenuHeight           (250)
#define     KShareMenuLeftOff          (10)
#define     KShareMenuRightOff         (10)

#define     KShareMenuTitileHeight          (50)
#define     KShareCancelBtnViewHeight       (50)
#define     KShareMenuBtnHeight             (80)

#define     KShareMenuBtnTag(a)             (1000 + (a))
#define     KShareMenuBtnParsTag(a)         ((a) - 1000)


#import <UIKit/UIKit.h>


@protocol JJHShareMenuClick <NSObject>
- (void)shareMenuCancelBtnClickEvery:(id)sender;
@end


@interface ChristShareMenu : UIView

@property (nonatomic,strong) NSArray* shareMenuArr;
@property (nonatomic,strong) UIView* shareView;

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImage *isShareImagToAppImage;
@property (nonatomic) BOOL blShareImageToApp;

@property (nonatomic, strong) id <JJHShareMenuClick> delegateClick;

@end
