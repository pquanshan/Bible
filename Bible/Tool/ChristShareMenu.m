//
//  ChristShareMenu.m
//  Bible
//
//  Created by yons on 14-6-17.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristModel.h"
#import "ChristUtils.h"
#import "ChristShareMenu.h"
//#import <Frontia/Frontia.h>

@implementation ChristShareMenu

@synthesize shareMenuArr = _shareMenuArr;
@synthesize shareView = _shareView;
@synthesize delegateClick = _delegateClick;

@synthesize url = _url;
@synthesize description = _description;
@synthesize title = _title;
@synthesize image = _image;
@synthesize isShareImagToAppImage = _isShareImagToAppImage;
@synthesize imageurl = _imageurl;
@synthesize isShareImagToAppImageurl = _isShareImagToAppImageurl;
@synthesize blShareImageToApp = _blShareImageToApp;

- (id)init
{
    self = [super init];
    if (self) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.opaque = NO;
        [self setBackgroundColor: [UIColor colorWithWhite: 0 alpha: 0.5]];
        _shareMenuArr = [[NSArray alloc] initWithObjects:JJH_SHARE_PLATFORM_SINAWEIBO,JJH_SHARE_PLATFORM_WEIXIN_SESSION,JJH_SHARE_PLATFORM_WEIXIN_TIMELINE,
                         JJH_SHARE_PLATFORM_QQFRIEND,JJH_SHARE_PLATFORM_QQ,nil];
//        _url = KShareURL1;
//        _title = MyLocal(@"share_title");
//        _description = MyLocal(@"share_description1");
//        //        _image = [UIImage imageNamed:@"share_default_big.png"];
//        //        _isShareImagToAppImage = [UIImage imageNamed:@"share_default_small.png"];
//        _imageurl = KShareWxImg;
//        _isShareImagToAppImageurl = KShareLogoImg;
//        _blShareImageToApp = NO;
//
//        float shareViewHeight = KShareMenuTitileHeight + KShareCancelBtnViewHeight + KShareMenuBtnHeight * (1 + (_shareMenuArr.count - 1)/3);
//        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, shareViewHeight)];
//        [_shareView setBackgroundColor:[[JJHModel shareModel] getColorByType:JJHBgColorPage default:YES]];
//        _shareView.alpha = 1.0;
//        [self addSubview:_shareView];
//        [self initShowView];
//        //添加动画
//        [self shareViewAnimation:YES];
    }
    return self;
}

-(void)setShareMenuArr:(NSArray *)shareMenuArr{
    if (shareMenuArr) {
        _shareMenuArr = shareMenuArr;
    }
    [_shareView removeFromSuperview];
    [self initShowView];
}

- (void) initShowView{
//    UILabel* label = [ChristUtils labelWithTxt:@"分享到" frame:CGRectMake(KShareMenuLeftOff, 0, self.frame.size.width - KShareMenuLeftOff,  KShareMenuTitileHeight)
//                                       font:[[JJHModel shareModel] getLaberFontSize:KLabelFontArial size:KLabelFontSize16]
//                                      color:[[JJHModel shareModel] getColorByType:JJHDefColorTextBlack default:YES]];
//    label.textAlignment = UITextAlignmentLeft;
//    [_shareView addSubview:label];
//    
//    UIImageView* imglineview = [[UIImageView alloc]initWithImage:[[JJHModel shareModel] getBgImageByType:JJHImageBgCellImgBackLine default:YES]];
//    imglineview.frame = CGRectMake(0, KShareMenuTitileHeight - 2 * imglineview.frame.size.height, self.frame.size.width, imglineview.frame.size.height);
//    [_shareView addSubview:imglineview];
//    
//    //分享按钮图标
//    for (int i = 0; i < _shareMenuArr.count; ++i) {
//        NSString* imgNameStr = [[NSString alloc] initWithFormat:@"icon_share_0%d.png", i+1];
//        UIButton* button = [JJHUtils buttonWithImg:nil
//                                               off:0
//                                             image:[UIImage imageNamed:imgNameStr]
//                                          imagesec:[UIImage imageNamed:imgNameStr]
//                                            target:self action:@selector(sharbtnClicked:)];
//        button.tag = KShareMenuBtnTag(i);
//        button.center = CGPointMake((i%3)*self.frame.size.width/3+ self.frame.size.width/6, KShareMenuTitileHeight + KShareMenuBtnHeight/2 +  (i/3) * KShareMenuBtnHeight);
//        [_shareView addSubview:button];
//    }
//    
//    UIButton* cancelBtn = [JJHUtils buttonWithImg:nil
//                                              off:0
//                                            image:[UIImage imageNamed:@"lbtn_orange.png"]
//                                         imagesec:[UIImage imageNamed:@"lbtn_orange_on.png"]
//                                           target:self
//                                           action:@selector(cancelBtnClicked:)];
//    cancelBtn.titleLabel.font = [[JJHModel shareModel] getLaberFontSize:KLabelFontBold size:KLabelFontSize18];
//    cancelBtn.center = CGPointMake(_shareView.center.x, _shareView.frame.size.height - KShareCancelBtnViewHeight/2);
//    [cancelBtn setTitle:MyLocal(@"cancel") forState:UIControlStateNormal];
//    [_shareView addSubview:cancelBtn];
}

- (void)cancelBtnClicked:(id)sender{
    //添加动画
    [self shareViewAnimation:NO];
}

- (void)sharbtnClicked:(id)sender{
    UIButton* btn = (UIButton*)sender;
    int pars = KShareMenuBtnParsTag(btn.tag);
    NSString* sharStr = nil;
    if (_shareMenuArr && _shareMenuArr.count > pars) {
        sharStr = [_shareMenuArr objectAtIndex:pars];
        [self onSingleShare:sharStr];
    }
}

-(void)shareViewAnimation:(BOOL)showHidden{
    if (showHidden) {//显示
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _shareView.frame = CGRectMake(0, self.frame.size.height - _shareView.frame.size.height, self.frame.size.width, _shareView.frame.size.height);
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                             }
                         }];
        
    }else{
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _shareView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _shareView.frame.size.height);
            
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [self removeFromSuperview];
                             }
                         }];
        
    }
}

- (void)onSingleShare:(NSString*)keyStr{
////    if (JJHTypeNetNotReachable == [[JJHModel shareModel] getCurrentNetStatus]) {
////        [JJHUtils showStatusViewWithMessage:MyLocal(@"net_not_reachable") duration:2 type:JJHImageStatusType1];
////    }else{
//        FrontiaShare *share = [Frontia getShare];
//        [share registerQQAppId:@"101069973" enableSSO:NO];
//        [share registerWeixinAppId:@"wxfb4a418e2fa9a10c"];
//        //        [share registerSinaweiboAppId:@"3631059297"];//微博不支持第三方登入（如此做有问题）
//        
//        //授权取消回调函数
//        FrontiaShareCancelCallback onCancel = ^(){
//            NSLog(@"OnCancel: share is cancelled");
//            if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_SINAWEIBO]) {
//                [[JJHUtils shareUtils] hideProgressHUD:self];
//            }
//            [self removeFromSuperview];
//        };
//        //授权失败回调函数
//        FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
//            if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_SINAWEIBO]) {
//                [[JJHUtils shareUtils] hideProgressHUD:self];
//            }
//            [JJHUtils showStatusViewWithMessage:errorMessage duration:2 type:JJHImageStatusType1];
//            
//        };
//        //授权成功回调函数
//        FrontiaSingleShareResultCallback onResult = ^(){
//            if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_SINAWEIBO]) {
//                [[JJHUtils shareUtils] hideProgressHUD:self];
//                [JJHUtils showStatusViewWithMessage:@"已分享到新浪微博" duration:2 type:JJHImageStatusType2];
//            }
//            [self removeFromSuperview];
//        };
//        
//        FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
//        content.url = _url;
//        content.title =  _title;
//        content.description = _description;
//        if (_image) {
//            content.imageObj = _image;
//        }else{
//            content.imageObj = _imageurl;
//        }
//        
//        content.isShareImageToApp = _blShareImageToApp;
//        if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_SINAWEIBO]) {
//            content.isShareImageToApp = NO;
//            [[JJHUtils shareUtils] showProgressHUD:self text:nil timeout:0 default:YES object:nil action:nil];
//        }else if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_WEIXIN_SESSION]){
//            if (_isShareImagToAppImage) {
//                content.imageObj = _isShareImagToAppImage;
//            }else{
//                content.imageObj = _isShareImagToAppImageurl;
//            }
//        }else if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_WEIXIN_TIMELINE]){
//            if (_isShareImagToAppImage) {
//                content.imageObj = _isShareImagToAppImage;
//            }else{
//                content.imageObj = _isShareImagToAppImageurl;
//            }
//        }else if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_QQFRIEND]){
//            if (_isShareImagToAppImage) {
//                content.imageObj = _isShareImagToAppImage;
//            }else{
//                content.imageObj = _isShareImagToAppImageurl;
//            }
//        }else if ([keyStr isEqualToString:JJH_SHARE_PLATFORM_QQ]){
//            content.isShareImageToApp = NO;
//            content.imageObj = KShareLogoImg;
//        }else{
//        }
//        
//        [share shareWithPlatform:keyStr content:content supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO
//                  cancelListener:onCancel failureListener:onFailure resultListener:onResult];
////    }
}

@end
