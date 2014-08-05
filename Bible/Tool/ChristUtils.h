//
//  ChristUtils.h
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChristUtils : NSObject
-(void)showWeakRemind:(NSString *)message time:(NSTimeInterval)time;

//-(MBProgressHUD*)showProgressHUD:(UIView*)view text:(NSString*)text object:(id)object action:(SEL)action;

-(void)hideProgressHUD:(UIView*)view;

+(ChristUtils*)shareUtils;

//获取设备的mac地址
+(NSString *)getMacAddress;

+(void)showAlertView:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+(UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action;

+(UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color;

+(UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text;

+(UINavigationBar*)navigationWithImg:(UIImage*)image;

+(const CGFloat*)getRGBAFromColor:(UIColor*)color;

+(void)showRemindMessage:(NSString*)message;

+(NSString*)getStringByStdString:(const char*)string;
+(NSString*)getStringByInt:(int)number;
+(NSNumber*)getNumberByInt:(int)number;
+(NSString*)getStringByFloat:(float)number decimal:(int)decimal;
+(NSString*)remPreString:(NSString*)tempString preStr:(NSString*)preStr;
+(NSString*)remSufString:(NSString*)tempString sufStr:(NSString*)sufStr;
+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+(void)openUrl:(NSString*)url;

+(NSString*)getAppVersion;
+(NSString*)getAppName;

+(void)callPhoneNumber:(NSString*)number view:(UIView*)view;

+(NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second;
+(NSDate*)getDateFromString:(NSString*)time format:(NSString*)format;
+(NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format;
+(NSDateComponents*)getComponentsFromDate:(NSDate*)date;
+(NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to;
+(NSString*)getFilePathInDocument:(NSString*)fileName;

//给一个view添加无效手势，以达到其他手势无法响应的目的
+ (void)disableGestures:(UIView*)view;
+ (void)ShowShareMenu:(UIView*)view dic:(NSDictionary*)dic;

#pragma mark - user default
+(void)setDataByKey:(id)object forkey:(NSString *)key;
+(void)removeDataByKey:(NSString*)key;
+(id)getDataByKey:(NSString*)key;

@end



@interface JJHSelectorObject : NSObject

@property (nonatomic, weak) NSObject* object;
@property (nonatomic, assign) SEL methodSelecter;//这里声明为属性方便在于外部传

-(id)initSelector:(NSObject*)object action:(SEL)action;
@end

