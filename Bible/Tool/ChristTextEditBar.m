//
//  ChristTextEditBar.m
//  Bible
//
//  Created by yons on 14-5-29.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#define KExtensionViewHeight1       (50)
#define KExtensionViewHeight2       (50)

#define KFontSizeMin                (10)
#define KFontSizeMax                (30)

#define KExtensionViewOff           (45)

#define KCTextEditBarBtnTag(i)      ((1000) + (i))
#define KCTextEditBarBtn(i)         ((i) - (1000))

#import "ChristUtils.h"
#import "ChristModel.h"
#import "ChristConfig.h"
#import "ChristTextEditBar.h"

@interface ChristTextEditBar(){
    float fixedOriginY;
    float fixedHeight;
    int lastType;//控制扩展视图显示隐藏
    UIView* extensionView1;
    UIView* extensionView2;
    
    UISlider *slider1;
    UILabel* sizeText;
    int fontSize;
    
    UIButton* dayModel;
    UIButton* nightModel;
}

@end

@implementation ChristTextEditBar
@synthesize btnArr = _btnArr;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        fixedOriginY = self.frame.origin.y;
        fixedHeight = self.frame.size.height;
        fontSize = [[ChristUtils getDataByKey:KUserFontSize] intValue];
        fontSize = fontSize == 0 ? 15 : fontSize;
        lastType = 0;
        _delegate = SysDelegate.viewHome;
        [self addBtnView];
        //添加无效手势，禁用home页响应
        [ChristUtils disableGestures:self];
    }
    return self;
}

#pragma mark - init
-(void)initExtensionView1{
    [extensionView1 removeFromSuperview];
    extensionView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, KExtensionViewHeight1)];
    [extensionView1 setBackgroundColor:RGBCOLOR(120, 190, 160)];
    [self addSubview:extensionView1];
    slider1 = [[UISlider alloc]initWithFrame:CGRectMake(2*KExtensionViewOff,0, self.frame.size.width - 3 * KExtensionViewOff, KExtensionViewHeight1)];
    slider1.minimumValue = KFontSizeMin;
    slider1.maximumValue = KFontSizeMax;
    slider1.value = fontSize;
    [slider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [extensionView1 addSubview:slider1];
    
    UIButton* subBtn = [ChristUtils buttonWithImg:@"A" off:0 image:nil imagesec:nil target:self action:@selector(subBtnClick:)];
    subBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:KFontSizeMin];
    [subBtn setFrame:CGRectMake(KExtensionViewOff, 0, KExtensionViewOff, KExtensionViewHeight1)];
    [extensionView1 addSubview:subBtn];

    UIButton* addBtn = [ChristUtils buttonWithImg:@"A" off:0 image:nil imagesec:nil target:self action:@selector(addBtnClick:)];
    addBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:KFontSizeMax];
    [addBtn setFrame:CGRectMake(self.frame.size.width - KExtensionViewOff, 0, KExtensionViewOff, KExtensionViewHeight1)];
    [extensionView1 addSubview:addBtn];
    
    sizeText =  [ChristUtils labelWithTxt:[ChristUtils getStringByInt:fontSize]
                                    frame:CGRectMake(0, 0, KExtensionViewOff, KExtensionViewHeight1)
                                     font:[[ChristModel shareModel] getBodyTextFont]
                                    color:[UIColor greenColor]];
    [extensionView1 addSubview:sizeText];
}

-(void)initExtensionView2{
    [extensionView2 removeFromSuperview];
    extensionView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, KExtensionViewHeight2)];
    [extensionView2 setBackgroundColor:RGBCOLOR(120, 190, 160)];
    [self addSubview:extensionView2];
    
    dayModel = [ChristUtils buttonWithImg:@"白天模式" off:0 image:nil imagesec:nil target:self action:@selector(dayModelBtnClick:)];
    [dayModel setFrame:CGRectMake(0, 0, self.frame.size.width/2, KExtensionViewHeight1)];
    [dayModel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dayModel setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [extensionView2 addSubview:dayModel];
    
    nightModel = [ChristUtils buttonWithImg:@"黑夜模式" off:0 image:nil imagesec:nil target:self action:@selector(nightModelBtnClick:)];
    [nightModel setFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, KExtensionViewHeight1)];
    [nightModel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nightModel setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [extensionView2 addSubview:nightModel];
    
    NSString *model = [ChristUtils getDataByKey:KUserViewMode];
    if (model) {
        [self setSelectModel:[model intValue]];
    }else{
        [self setSelectModel:0];
    }
}

#pragma mark - internal function
-(void)setBtnArr:(NSArray *)btnArr{
    //移除所有视图
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    _btnArr = btnArr;
    [self addBtnView];
}

-(void)addBtnView{
    if (_btnArr) {
        float width = self.frame.size.width / _btnArr.count;
        for (int i = 0; i < _btnArr.count; ++i) {
            UIButton* btn = [ChristUtils buttonWithImg:[[_btnArr objectAtIndex:i] objectForKey:KPQuickSetMenuTitle]off:0 image:nil imagesec:nil target:self action:@selector(btnClicked:)];
            btn.tag = KCTextEditBarBtnTag(i);
            btn.frame = CGRectMake(i*width, self.frame.size.height - fixedHeight, width, fixedHeight);
            [self addSubview:btn];
        }
    }
}

-(void)setSelectModel:(ChristViewModeType)modeType{
    if (modeType == ChristViewDaytimeMode) {//白天模式
        dayModel.selected = YES;
        nightModel.selected = NO;
    }else if(modeType == ChristViewNightMode){//黑夜模式
        dayModel.selected = NO;
        nightModel.selected = YES;
    }else{
        dayModel.selected = YES;
        nightModel.selected = NO;
    }
}

//以下和plist设置的type值对应
-(void)setExtension:(id)sender type:(int)type{
    [extensionView1 removeFromSuperview];
    [extensionView2 removeFromSuperview];
    
    BOOL bl = NO;
    
    if (lastType  == type) {
        //移除扩展视图
        lastType = 0;
        self.frame = CGRectMake(0, fixedOriginY, self.frame.size.width, fixedHeight);
    }else{
        switch (type) {
            case 1:
            {
                self.frame = CGRectMake(0, fixedOriginY - KExtensionViewHeight1, self.frame.size.width, fixedHeight + KExtensionViewHeight1);
                [self initExtensionView1];
                bl = YES;
            }
                break;
            case 2:
            {
                self.frame = CGRectMake(0, fixedOriginY - KExtensionViewHeight2, self.frame.size.width, fixedHeight + KExtensionViewHeight2);
                [self initExtensionView2];
                bl = YES;
            }
                break;
            case 100:
            {
                [self setHidden:YES];
            }
                break;
            default:
            {
                self.frame = CGRectMake(0, fixedOriginY, self.frame.size.width, fixedHeight);
            }
                break;
        }
        lastType = type;
    }
    
    //btn 位置 调整
    if (_btnArr) {
        for (int i = 0; i < _btnArr.count; ++i) {
            UIButton* btn = (UIButton*)[self viewWithTag:KCTextEditBarBtnTag(i)];
            if (btn) {
                btn.center = CGPointMake(btn.center.x, self.frame.size.height - btn.frame.size.height/2);
                [btn setBackgroundColor:[UIColor grayColor]];
            }
        }
        if (type == 1 || type == 2) {
            [(UIButton*)sender setBackgroundColor:RGBCOLOR(120, 190, 160)];
        }
    }
}

//发送消息类型
-(void)setMessageType:(id)sender type:(int)type{
    [_delegate editBarMessage:self megtype:type];
}

#pragma mark - interface function
-(void)restoreHidden{
    //移除扩展视图
    [extensionView1 removeFromSuperview];
    [extensionView2 removeFromSuperview];
    lastType = 0;
    self.frame = CGRectMake(0, fixedOriginY, self.frame.size.width, fixedHeight);
    if (_btnArr) {
        for (int i = 0; i < _btnArr.count; ++i) {
            UIButton* btn = (UIButton*)[self viewWithTag:KCTextEditBarBtnTag(i)];
            if (btn) {
                btn.center = CGPointMake(btn.center.x, self.frame.size.height - btn.frame.size.height/2);
                [btn setBackgroundColor:[UIColor grayColor]];
            }
        }
    }
    [self setHidden:YES];
}

#pragma mark - UIButton Click
-(void)btnClicked:(id)sender{
    //页面是否需要扩展,是否要把消息抛出去
    if (!SysDelegate.viewHome.isMenuOpening ){
        UIButton* btn =  (UIButton*)sender;
        int type = [[[_btnArr objectAtIndex:KCTextEditBarBtn(btn.tag)] objectForKey:KPQuickSetMenuType] intValue];
        [self setExtension:(id)sender type:(int)type];
        [self setMessageType:(id)sender type:(int)type];
    }
}

-(void)subBtnClick:(id)sender{
    slider1.value = slider1.value - 1;
    fontSize = slider1.value;
    [self setFontSize];
}

-(void)addBtnClick:(id)sender{
    slider1.value = slider1.value + 1;
    fontSize = slider1.value;
    [self setFontSize];
}

-(void)dayModelBtnClick:(id)sender{
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:ChristViewDaytimeMode] forkey:KUserViewMode];
    [self setSelectModel:ChristViewDaytimeMode];
    [self setMessageType:self type:2];
}

-(void)nightModelBtnClick:(id)sender{
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:ChristViewNightMode] forkey:KUserViewMode];
    [self setSelectModel:ChristViewNightMode];
    [self setMessageType:self type:2];
}


-(void)setFontSize{
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:fontSize] forkey:KUserFontSize];
    sizeText.text = [ChristUtils getStringByInt:fontSize];
    sizeText.font = [[ChristModel shareModel] getBodyTextFont];
    [_delegate editBarMessage:self megtype:1];
}

-(void)sliderValueChanged:(id)sender{
    UISlider* slider = (UISlider *)sender;
    if (fontSize != slider.value) {
        fontSize = slider.value;
        [self setFontSize];
    }
}


@end
