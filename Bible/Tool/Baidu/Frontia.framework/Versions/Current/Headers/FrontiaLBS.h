/*!
 @header FrontiaLBS.h
 @abstract 提供对LBS的操作的模块。
 @discussion 提供地理位置信息的查询和POI信息查询已经附近用户信息的查询。
 @version 1.00 2013/09/30 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IModule.h"
#import "FrontiaLBSDelegate.h"

/*!
 @class FrontiaLocation
 @abstract 提供对LBS的操作的模块。
 */
@interface FrontiaLBS : NSObject <IModule>

/*!
 @method uploadLocation
 @abstract 上传当前位置信息（经纬度信息）。
 @param resultListener
     上传信息成功后的回调函数。
 @param failureListener
     上传信息失败后的回调函数。
 */
-(void)uploadLocation:(FrontiaLBSUploadLocationCallBack)resultListener
      failureListener:(FrontiaLBSFailureCallback)failureListener;

/*!
 @method getCurrentLocation
 @abstract 获取当前地理位置信息。
 @param resultListener
     获取信息成功后的回调函数。
 @param failureListener
     获取信息失败后的回调函数。
 */
-(void)getCurrentLocation:(FrontiaLBSCurrentLocationCallBack)resultListener
          failureListener:(FrontiaLBSFailureCallback)failureListener;

/*!
 @method getNearPOIs
 @abstract 获取附近的商圈信息。
 @param data
     指定文件
 @param resultListener
     附近商圈信息的回调函数。
 @param failureListener
     获取商圈信息失败后的回调函数。
 */
-(void)getNearPOIs:(FrontiaLBSNearPOIsCallback)resultListener
   failureListener:(FrontiaLBSFailureCallback)failureListener;

/*!
 @method getNearFrontiaUsers
 @abstract 获取附近的用户。
 @param resultListener
     获取附近用户的回调函数。
 @param failureListener
     获取附近用户失败后的回调函数。
 */
-(void)getNearFrontiaUsers:(FrontiaLBSNearUsersCallback)resultListener
           failureListener:(FrontiaLBSFailureCallback)failureListener;

@end