//
//  TaijinDBManager.m
//  TaiShou
//
//  Created by zhgz on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaijinDBManager.h"

@implementation TaijinDBManager

//金悦索引数据表

+ (id)currentJinYueWithPPP:(NSString*)ppp_ age:(int)age_ sex:(NSString*)sex_ {
    
    
    //acc_pua_low double,
    //end_dvd_low double,
    
    
    NSString *sqlString = [NSString stringWithFormat:@"select gp,count_65,total_65,retire_65,share_65,total_88,high_66,mid_66,low_66,high_77,mid_77,low_77,high_88,mid_88,low_88 from jinyue_query where ppp='%@' and age='%i'  and gender='%@'  order by i_id ", ppp_,age_,sex_];
    
    
    
    DLog(@"SQL:%@",sqlString);
    
    
    return [[DBAccess sharedInstance] queryDataToObj:sqlString type:NSClassFromString(@"JInYueQuery")];
    
    
    
    
}


+ (id)quryCityNumberWithCityName:(NSString*)cityName{
    ;
    NSString *sqlString = [NSString stringWithFormat:@"select _id,province_id,name,city_num from citys where name='%@' order by _id", cityName];
    
    DLog(@"SQL:%@",sqlString);
    
    return [[DBAccess sharedInstance] queryDataToObj:sqlString type:NSClassFromString(@"Citys")];
    
    
}


@end
