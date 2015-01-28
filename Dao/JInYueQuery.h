//
//  JInYueQuery.h
//  TaiJin
//
//  Created by n22  on 12-12-17.
//
//

#import <Foundation/Foundation.h>

@interface JInYueQuery : NSObject{

    NSInteger  i_id ;
    NSString *gender ;
    NSString *age;
    NSString *ppp ;
    double gp ;
    
     double count_65 ;
     double total_65 ;
     double retire_65 ;
     double share_65 ;
    
     double total_88 ;
     double high_66 ;
     double mid_66 ;
     double low_66 ;
    
     double high_77 ;
     double mid_77 ;
     double low_77 ;
     double high_88 ;
     double mid_88 ;
     double low_88 ;
}


@property(nonatomic,assign)NSInteger i_id ;


@property(nonatomic,retain)NSString  *gender ;
@property(nonatomic,retain)NSString  *age ;
@property(nonatomic,retain)NSString  *ppp ;
@property(nonatomic,assign) double  gp ;
@property(nonatomic,assign) double count_65 ;

@property(nonatomic,assign) double total_65 ;
@property(nonatomic,assign) double retire_65 ;
@property(nonatomic,assign) double share_65 ;

@property(nonatomic,assign) double total_88 ;

@property(nonatomic,assign) double high_66 ;
@property(nonatomic,assign) double mid_66 ;
@property(nonatomic,assign) double low_66 ;

@property(nonatomic,assign) double high_77 ;
@property(nonatomic,assign) double mid_77 ;
@property(nonatomic,assign) double low_77 ;

@property(nonatomic,assign) double high_88 ;
@property(nonatomic,assign) double mid_88 ;
@property(nonatomic,assign) double low_88 ;


@end
