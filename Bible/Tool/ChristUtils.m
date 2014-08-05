//
//  ChristUtils.m
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import <Frontia/Frontia.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation ChristUtils

static ChristUtils* _shareUtils = nil;

+(ChristUtils*)shareUtils{
	if (!_shareUtils) {
        _shareUtils = [[self alloc]init];
	}
    
	return _shareUtils;
};

#pragma mark MAC
+(NSString *)getMacAddress{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = (char*)malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

+(void)showAlertView:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
}


+(UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    if (buttonText != nil) {
        NSString* text = [NSString stringWithFormat:@"%@", buttonText];
        if (off > 0) {
            for (int i = 0; i < off; i++) {
                text = [NSString stringWithFormat:@" %@", text];
            }
        }
        [button setTitle:text forState:UIControlStateNormal];
        
        if (image == nil && imagesec == nil) {
            float width = [buttonText sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].width;
            float height = [buttonText sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].height;
            
            button.frame = CGRectMake(0.0, 0.0, width, height);
        }
    }
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (imagesec != nil) {
        [button setBackgroundImage:imagesec forState:UIControlStateHighlighted];
        [button setBackgroundImage:imagesec forState:UIControlStateSelected];
    }
    button.adjustsImageWhenHighlighted = NO;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = buttonText;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;   //first deprecated in IOS 6.0
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+(UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = color;
    textField.font = font;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = bgcolor;
    textField.placeholder = text;
    [textField setSecureTextEntry:secu];
    textField.returnKeyType = UIReturnKeyDone;
    
    return textField;
}

//+(UINavigationBar*)navigationWithImg:(UIImage*)image{
//    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320,
//                                                                                KNavigationHeight)];
//    
//    //设置导般栏背景
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:navBar.frame];
//    imageView.contentMode = UIViewContentModeLeft;
//    imageView.image = image;
//    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
//        [navBar insertSubview:imageView atIndex:0];
//    } else {
//        [navBar addSubview:imageView];
//    }
//    
//    return navBar;
//}

+(const CGFloat*)getRGBAFromColor:(UIColor *)color{
    CGColorRef colorRef = [color CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents >= 4){
        return CGColorGetComponents(colorRef);
    } else {
        return NULL;
    }
}

//+(void)showRemindMessage:(NSString *)message{
//    [[[UIAlertView alloc] initWithTitle:MyLocal(@"more_user_management_title")
//                                message:message
//                               delegate:nil
//                      cancelButtonTitle:nil
//                      otherButtonTitles:MyLocal(@"ok"), nil] show];
//}
//
//-(void)showWeakRemind:(NSString *)message time:(NSTimeInterval)time{
//    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"more_user_management_title")
//                                                          message:message
//                                                         delegate:self
//                                                cancelButtonTitle:nil
//                                                otherButtonTitles:nil];
//    if (time <= 0) {
//        time = 2.5;
//    }
//    
//    [NSTimer scheduledTimerWithTimeInterval:time
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:promptAlert
//                                    repeats:NO];
//    
//    promptAlert.tag = KShowWeakRemind;
//    
//    [promptAlert show];
//    
//}
//
//- (void)willPresentAlertView:(UIAlertView *)alertView{
//    if (alertView.tag != KShowWeakRemind) {
//        return;
//    }
//    for(UIView *subview in alertView.subviews){
//        if ([[subview class] isSubclassOfClass:[UIImageView class]]) {
//            UIImageView *view = (UIImageView*)subview;
//            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - KShowWeakBtnHeight);
//        }
//    }
//}
//
//- (void)timerFireMethod:(id)sender{
//    UIAlertView *promptAlert = (UIAlertView*)[sender userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
//}
//
//-(MBProgressHUD*)showProgressHUD:(UIView*)view text:(NSString*)text object:(id)object action:(SEL)action{
//    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:9999];
//    if (hud == nil) {
//        hud = [[MBProgressHUD alloc] initWithView:view];
//        [view addSubview:hud];
//        
//        hud.tag = 9999;
//        hud.labelText = text;
//        [hud show:YES];
//        
//        NSMutableDictionary* resDic = [[NSMutableDictionary alloc] init];
//        [resDic setObject:view forKey:KValue];
//        if (object && action) {
//            [resDic setObject:[[JJHSelectorObject alloc] initSelector:object action:action] forKey:KData];
//        }
//        [[JJHModel shareModel] subscribeTime:self action:@selector(netTimeMethod:) userInfo:resDic time:KNetRequestTimeout repeat:NO];
//    }
//    
//    return hud;
//}
//
//- (void)netTimeMethod:(id)sender{
//    NSDictionary* resdic = [sender userInfo];
//    UIView* view = (UIView*)[resdic objectForKey:KValue];
//    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:9999];
//    if (hud) {
//        [hud removeFromSuperview];
//        hud = nil;
//        
//        [JJHUtils showRemindMessage:MyLocal(@"net_wrong")];
//    }
//    
//    JJHSelectorObject* object = [resdic objectForKey:KData];
//    if (object) {
//        if ([object.object respondsToSelector:object.methodSelecter]) {
//            [object.object performSelector:object.methodSelecter withObject:nil];
//        }
//    }
//}
//
//-(void)hideProgressHUD:(UIView*)view{
//    [[JJHModel shareModel] unSubscribeTime:self];
//    
//    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:9999];
//    if (hud) {
//        [hud removeFromSuperview];
//        hud = nil;
//    }
//}

+(NSString*)getStringByStdString:(const char*)string{
    if (string) {
        return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+(NSString*)getStringByInt:(int)number{
    return [NSString stringWithFormat:@"%d", number];
}

+(NSNumber*)getNumberByInt:(int)number{
    return [NSNumber numberWithInt:number];
}

+(NSString*)getStringByFloat:(float)number decimal:(int)decimal{
    if (decimal == -1) {
        return [@"" stringByAppendingFormat:@"%f",number];
    }else {
        NSString *format=[@"%." stringByAppendingFormat:@"%df", decimal];
        return [@"" stringByAppendingFormat:format,number];
    }
}

+(NSString*)remPreString:(NSString*)tempString preStr:(NSString*)preStr{
    while ([tempString hasPrefix:preStr]){
        tempString = [tempString substringFromIndex:[preStr length]];
    }
    
    return tempString;
}

+(NSString*)remSufString:(NSString*)tempString sufStr:(NSString*)sufStr{
    while ([tempString hasSuffix:sufStr]){
        tempString = [tempString substringToIndex:[tempString length] - [sufStr length]];
    }
    
    return tempString;
}

+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)openUrl:(NSString*)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSString*)getAppVersion{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}

+(NSString*)getAppName{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+(void)callPhoneNumber:(NSString *)number view:(UIView*)view{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    UIWebView* phoneCallWebView = nil;
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [view addSubview:phoneCallWebView];
}

+(NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSDate* date = nil;
    if (second) {
        date = [NSDate dateWithTimeIntervalSince1970:time];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    }
    
    if (dateFormatter && date) {
        return [dateFormatter stringFromDate:date];
    } else {
        return nil;
    }
}

+(NSDate*)getDateFromString:(NSString*)time format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:time];
}

+(NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDateComponents*)getComponentsFromDate:(NSDate*)date{
    return [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit |
            NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit
                                           fromDate:date];
}

+(NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    return [cal components:unitFlags fromDate:from toDate:to options:0];
}

+(NSString*)getFilePathInDocument:(NSString*)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

+ (void)disableGestures:(UIView*)view{
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [view addGestureRecognizer:singleRecognizer];//给self.view添加一个手势监测；
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:nil];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:panRecognizer];
}

+ (void)ShowShareMenu:(UIView*)view dic:(NSDictionary*)dic{
    FrontiaShare *share = [Frontia getShare];
    
    [share registerQQAppId:@"100358052" enableSSO:NO];
    [share registerWeixinAppId:@"wx712df8473f2a1dbe"];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://developer.baidu.com/soc/share";
    content.title = @"社会化分享";
    content.description = @"百度社会化分享组件封装了新浪微博、人人网、开心网、腾讯微博、QQ空间和贴吧等平台的授权及分享功能，也支持本地QQ好友分享、微信分享、邮件和短信发送等，同时提供了API接口调用及本地操作界面支持。组件集成简便，风格定制灵活，可轻松实现多平台分享功能。";
    content.imageObj = @"http://apps.bdimg.com/developer/static/04171450/developer/images/icon/terminal_adapter.png";
    
    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS];
    
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:view cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

#pragma mark - user default
+(void)setDataByKey:(id)object forkey:(NSString *)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
}

+(void)removeDataByKey:(NSString*)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

+(id)getDataByKey:(NSString*)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


@end




#pragma mark - timer object
@interface JJHSelectorObject ()

@end

@implementation JJHSelectorObject

@synthesize object = _object;
@synthesize methodSelecter = _methodSelecter;

-(id)initSelector:(NSObject*)object action:(SEL)action{
    self = [super init];
    
	if (self) {
        _methodSelecter = action;
        _object = object;
    }
    
    return self;
}
@end
