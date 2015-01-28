//
//  MainRootViewController.h
//  WebServiseTest
//
//  Created by YTO on 14-4-8.
//  Copyright (c) 2014年 jhonyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JInYueQuery.h"

@interface MainRootViewController : UIViewController
<NSXMLParserDelegate,  NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (assign, nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;


@property (weak, nonatomic) IBOutlet UITextField *sJson;
@property (weak, nonatomic) IBOutlet UITextField *sMessage;
- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *JSonWeatherTest;
@property (weak, nonatomic) IBOutlet UIButton *weatherJsonAction;
- (IBAction)jsonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jsonre;
- (IBAction)jsonretaion:(id)sender;

@property (nonatomic, strong) NSMutableArray* rooms;
@property (nonatomic, strong) NSString *json;


@end
