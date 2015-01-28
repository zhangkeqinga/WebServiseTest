//
//  MainRootViewController.m
//  WebServiseTest
//
//  Created by YTO on 14-4-8.
//  Copyright (c) 2014年 jhonyzhang. All rights reserved.
//

#import "MainRootViewController.h"

#import "SBJson.h"
#import "RMMapper.h"
#import "User.h"


#import "FMDatabase.h"
#import "FMResultSet.h"

#import "TaijinDBManager.h"
#import "Citys.h"

@interface MainRootViewController ()

@end

@implementation MainRootViewController
//zkq add new
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize sJson;
@synthesize sMessage;


@synthesize rooms;

@synthesize json;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// 开始查询
- (IBAction)searchAction:(id)sender {
    NSString *jhon = sJson.text;
//    NSString *message = sMessage.text;
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    matchingElement = @"sMessage";  //结果的包含标签
    
    jhon = @"{\"ComplaintProblemInfo\":"
                   "{\"WaybillNo\"           :\"1231238761\","
                    "\"ComplaintSourceId\"   :80,"
                    "\"ComplaintSourceName\" :\"圆通速递\","
                    "\"CustomerName\"        :\"李乐军 \","
                    "\"CustomerTel\"         :\"13482896723 \","
                    "\"SendAddress\"         :\"33 \","
                    "\"ReceiveAddress\"      :\"上海 \","
                    "\"ComplaintContent\"    :\"allinfo \","
                    "\"Remark\"              :\"remarksetting \""
    
              "}}";

    NSString *soapMsg = [NSString stringWithFormat:
                @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                "<soap12:Body>"
                "<WebChatComplaintProblemInfo xmlns=\"http://tempuri.org/\">"
                "<sJson>%@</sJson>"
                "<Key>%@</Key>"
                "<sMessage>%@</sMessage>"
                "</WebChatComplaintProblemInfo>"
                "</soap12:Body>"
                "</soap12:Envelope>",jhon,@"",@""];
    
    
    
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: @"http://192.168.8.31:8080/Common/WebChatComplaintProblemInfoService.asmx?"];

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
//    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
    
//    NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//    NSMutableString *result=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"获得结果是==%@",result);

}


#pragma mark -
#pragma mark URL Connection Data Delegate Methods

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    
    [webData appendData:data];
    
     NSLog(@"获得结果是==%@",data);

}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
    
    NSLog(@"error");

}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
   
    
    NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
                                                length:[webData length]
                                              encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}


#pragma mark -
#pragma mark XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    
    NSLog(@"elementName==%@",elementName);
    if ([elementName isEqualToString:matchingElement]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
        [soapResults appendString: string];
    }
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if ([elementName isEqualToString:matchingElement]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取的请求数据 :"
                                                        message:[NSString stringWithFormat:@"%@", soapResults]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        elementFound = FALSE;
        // 强制放弃解析
        [xmlParser abortParsing];
    }
    
    NSLog(@"soapResults==%@",soapResults);

}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (soapResults) {
        soapResults = nil;
    }
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
}


#define kGlobalQueue    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define kDoubanUrl      @"http://douban.fm/j/mine/playlist?type=n&h=&channel=0&from=mainsite&r=4941e23d79"

-(void) loadJsonData:(NSURL *)url
{
    dispatch_async(kGlobalQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(parseJsonData:) withObject:data waitUntilDone:NO];
    });
}
-(void) parseJsonData:(NSData *)data
{
    
    
    // IOS 5  之后的数据解析方法：NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSError *error;
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json1 == nil) {
        NSLog(@"json parse failed \r\n");
        return;
    }
    
//    NSArray *songArray = [json1 objectForKey:@"song"];
    NSDictionary *songArray = [json1 objectForKey:@"weatherinfo"];
    NSLog(@"song collection: %@\r\n",songArray);
    NSLog(@"song info: %@\t\n",[songArray objectForKey:@"city"]);
}


- (void)searDBaction:(NSString *)cityname{

}




- (IBAction)jsonAction:(id)sender{
    
    Citys * city=[TaijinDBManager quryCityNumberWithCityName:@"北京"];
    
    NSLog(@"city====%@",city.city_num);
    
//    
//    //根据城市ID  获取城市的JSON网络数据借口
//    NSString * string1 = @"http://m.weather.com.cn/data/";
//    NSString * string3 = @".html";
//    NSString * string2 = @"101010400";
//
//
//    
//    NSString * weatherString = [NSString stringWithFormat:@"%@%@%@",string1,string2,string3];
//    
////    NSURL *url=[NSURL URLWithString:kDoubanUrl];
////    NSURL *url = [NSURL URLWithString:@"http://m.weather.com.cn/data/101180701.html"];
//    NSURL *url = [NSURL URLWithString:weatherString];
////    NSError *error = nil;
////    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//
//    [self loadJsonData:url];
    
    
//    SBJsonParser *parser = [[SBJsonParser alloc] init];
//    NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
//    NSDictionary *weatherInfo = [rootDic objectForKey:@"weatherinfo"];

    
//    NSString *string = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
//   NSLog(@"天气《==》%@",string);
    
}
- (IBAction)jsonretaion:(id)sender {
    
    NSDictionary *song = [NSDictionary dictionaryWithObjectsAndKeys:@"i can fly",@"title",@"4012",@"length",@"Tom",@"Singer", nil];
    if ([NSJSONSerialization isValidJSONObject:song])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:song options:NSJSONWritingPrettyPrinted error:&error];
        json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"json data:%@",json);
    
    }
}
@end
