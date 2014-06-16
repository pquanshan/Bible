//
//  ChristEpub.h
//  Bible
//
//  Created by yons on 14-6-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "TouchXML.h"
#import <Foundation/Foundation.h>

@interface ChristEpub : NSObject{
    NSString* epubFilePath;
}

@property(nonatomic,strong)NSArray* spineArray;
- (id) initWithEPubPath:(NSString*)path;

@end
