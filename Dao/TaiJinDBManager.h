//
//  TaijinDBManager.h
//  TaiShou
//
//  Created by zhgz on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBAccess.h"


@interface TaijinDBManager : NSObject


+ (id)currentJinYueWithPPP:(NSString*)ppp_ age:(int)age_ sex:(NSString*)sex_ ;

+ (id)quryCityNumberWithCityName:(NSString*)cityName;


@end

