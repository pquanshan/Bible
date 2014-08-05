/*!
 @header FrontiaLBSDalegate.h
 @abstract 对LBS的操作涉及的数据结构。
 @version 1.00 2013/09/30 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 @class FrontiaLocation
 @abstract 记录LBS上的某个具体的地理位置信息的数据结构。
 */
@interface FrontiaLocation : NSObject

/*!
 @property country
 @abstract 国家。
 */
@property(strong, nonatomic) NSString *country;

/*!
 @property province
 @abstract 省份。
 */
@property(strong, nonatomic) NSString *province;

/*!
 @property district
 @abstract 区。
 */
@property(strong, nonatomic) NSString *district;

/*!
 @property city
 @abstract 城市。
 */
@property(strong, nonatomic) NSString *city;

/*!
 @property street
 @abstract 街道。
 */
@property(strong, nonatomic) NSString *street;

/*!
 @property cityCode
 @abstract 城市编号。
 */
@property(strong, nonatomic) NSString *cityCode;

/*!
 @property streetNumber
 @abstract 街道号码。
 */
@property(strong, nonatomic) NSString *streetNumber;


@end

/*!
 @class FrontiaPoint
 @abstract 某个位置的具体经纬度信息。
 */
@interface FrontiaPoint : NSObject
/*!
 @property lng
 @abstract 经度信息。
 */
@property(strong, nonatomic) NSString* lng;

/*!
 @property lat
 @abstract 纬度信息。
 */
@property(strong, nonatomic) NSString* lat;

@end

/*!
 @class FrontiaPOI
 @abstract 记录LBS上的某个POI的信息的数据结构。
 */
@interface FrontiaPOI : NSObject

/*!
 @property addr
 @abstract 地址。
 */
@property(strong, nonatomic) NSString *addr;

/*!
 @property cp
 @abstract 数据来源。
 */
@property(strong, nonatomic) NSString *cp;

/*!
 @property distance
 @abstract 与当前位置的距离。
 */
@property(strong, nonatomic) NSString *distance;

/*!
 @property name
 @abstract 名称。
 */
@property(strong, nonatomic) NSString *name;

/*!
 @property poiType
 @abstract 类型。
 */
@property(strong, nonatomic) NSString *poiType;

/*!
 @property point
 @abstract 当前经纬度信息。
 */
@property(strong, nonatomic) FrontiaPoint *point;

/*!
 @property tel
 @abstract 电话号码。
 */
@property(strong, nonatomic) NSString *tel;

/*!
 @property zip
 @abstract 区号。
 */
@property(strong, nonatomic) NSString *zip;

@end

/*!
 @class FrontiaNearUser
 @abstract 记录附近的用户的信息的数据结构。
 */
@interface FrontiaNearUser : NSObject

/*!
 @property location
 @abstract 地理位置信息。
 */
@property(strong, nonatomic) FrontiaLocation *location;

/*!
 @property point
 @abstract 当前经纬度信息。
 */
@property(strong, nonatomic) FrontiaPoint *point;

/*!
 @property accountId
 @abstract 用户account ID。
 */
@property(strong, nonatomic) NSString *accountId;

@end

/*!
 @abstract LBS相关接口操作失败的回调函数。
 @param errorCode
     错误码。
 @param errorMessage
     错误原因。
 @result
     无。
 */
typedef void(^FrontiaLBSFailureCallback)(int errorCode, NSString* errorMessage);


/*!
 @abstract 上传地理位置信息成功时的回调函数。
 @param
 无
 @result
 无。
 */
typedef void(^FrontiaLBSUploadLocationCallBack)();

/*!
 @abstract 获取当前地理位置信息成功时的回调函数。
 @param location
     获取的地理位置信息。
 @result
     无。
 */
typedef void(^FrontiaLBSCurrentLocationCallBack)(FrontiaLocation *location);

/*!
 @abstract 查询附近的商圈信息结果。
 @param pois
     查询结果，是FrontiaPOI对象的数组。
 @result
     无。
 */
typedef void(^FrontiaLBSNearPOIsCallback)(NSArray *pois);


/*!
 @abstract 查询附近的人信息结果。
 @param users
     查询结果，是FrontiaNearUser对象的数组。
 @result
     无。
 */
typedef void(^FrontiaLBSNearUsersCallback)(NSArray *users);



