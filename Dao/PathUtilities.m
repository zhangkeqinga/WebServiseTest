//
//  PathUtilities.m
//  TaiPing
//
//  Created by bbdtek on 11-8-31.
//  Copyright 2011 bbdtek. All rights reserved.
//

#import "PathUtilities.h"


@implementation PathUtilities

+ (NSString *)documentFilePathWithFileName:(NSString*)fileName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	return filePath;
}

+ (NSString *)libraryFilePathWithFileName:(NSString*)fileName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	return filePath;
}



+ (void) copyDatabaseIfNeededWithFileName:(NSString*)fileName  SearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory{
    //Using NSFileManager we can perform file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    //find file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:fileName];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}


+ (NSString *)openXMLWithFileName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",fileName] ofType:nil];
    NSData *reader = [NSData dataWithContentsOfFile:path]; 
    NSString *planText=[[[NSString alloc]initWithData:reader encoding:NSUTF8StringEncoding]autorelease];
    return planText;    
}


+ (BOOL)createDirectoryIfNotExistsAtPath:(NSString *)path{
	BOOL result = NO;
	NSFileManager *fileManger = [NSFileManager defaultManager];
	BOOL exists = [fileManger fileExistsAtPath:path];
	if (!exists) {
		result = [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}else {
		result = YES;
	}
	
	return result;
}


+ (NSString *)writeToFile:(NSData *)data withFileName:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
        NSLog(@"file not exist,create it...");
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSLog(@"file exist!!!");
    }
    
    [data writeToFile:filePath atomically:YES];

    return filePath;
    
}


//imgUrl 
+(BOOL)downloadFileAndSaveWithURL:(NSString*)imgUrl withDocument:(NSString*)folderName renFileName:(NSString*)fileName
{
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    if (!([urlData length] > 0)) {
        return NO;
    }
    
    //创建文件管理器 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    //获取路径 
    //参数NSDocumentDirectory要获取那种路径 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //去处需要的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    
    //创建一个目录
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
    
    //更改到待操作的目录下 
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]]; 
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil 
    //获取文件路径 
    [fileManager removeItemAtPath:fileName error:nil]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",folderName,fileName]];//@"/myFolder/username"]; 
    
    
    
    if([PathUtilities createDirectoryIfNotExistsAtPath:path]){
        
        path =[path stringByAppendingString:@".temp"];
    }
    
    [urlData writeToFile:path atomically:NO];
    
    
    
    
    
    return YES;
    
    
}

+ (void)deteleFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:filePath error:nil];
    
//      NSArray *fileList = [[NSArray alloc] init];  //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组         
//      fileList = [defaultManager contentsOfDirectoryAtPath:documentsDirectory error:nil];  
//     for (NSString *file in fileList) {                 
//         NSString *path = [documentsDirectory stringByAppendingPathComponent:file]; 
//         [defaultManager removeItemAtPath:path error:nil];
//     }
//
//    [fileList release];
}



+(void)updateFilesWithDocument:(NSString*)documents
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:documents];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
    
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dataPath  error:nil];
    
    DLog(@"files array %@", filePathsArray);
    for (int i = 0; i < [filePathsArray count]; i++) {
        //＊.temp
        NSString *filePath = [dataPath stringByAppendingPathComponent:[filePathsArray objectAtIndex:i]];
        DLog(@"----- %@", filePath);
        
        
        
        
        
        if([filePath hasSuffix:@".temp"]){   //(filePath 匹配带.temp的文件)
            
            //删除旧的文件
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager changeCurrentDirectoryPath:[dataPath stringByExpandingTildeInPath]];
            [fileManager removeItemAtPath:filePath error:nil];
            
           DLog(@"%@",[fileManager contentsOfDirectoryAtPath:dataPath error:nil]);
            
            
            
            NSString *notTempFilePath = [filePath substringToIndex:[filePath length]-5];
            
            //重命名  
            NSString *filePath2= [documentsDirectory
                                  stringByAppendingPathComponent:notTempFilePath]; 
            
            
            if ([fileManager moveItemAtPath:filePath toPath:filePath2 error:nil] != YES){
                
                DLog(@"NotSuccessed!");
            }
            
            NSLog(@"Documentsdirectory: %@",
                  [fileManager contentsOfDirectoryAtPath:dataPath error:nil]);
            
            
            //重名完毕
        }
        
        
        
    }
    
}



+(void)unzipFile:(NSString*)fileName  toUnzipPath:(NSString*) unzipFile_ {
 
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *downloadPath = [path stringByAppendingPathComponent:fileName];
    
    NSString *unzipPath;
    unzipPath = [[path stringByAppendingPathComponent:@"Unzip"] retain];
    
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:downloadPath]) {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        if (result) {
            DLog(@"解压成功！");
        }
        else {
            DLog(@"解压失败1");
        }
        [unzip UnzipCloseFile];
    }
    else {
        DLog(@"解压失败2");
    }
    [unzip release];
}


+(void)unzipFile:(NSString*)fileName  SearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory toUnzipPath:(NSString*) unzipFile_ 
{
    
    
    //========
    
    //Using NSFileManager we can perform file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
    //find file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory , NSUserDomainMask, YES);
   
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *path = [documentsDir stringByAppendingPathComponent:fileName];
    
    BOOL success = [fileManager fileExistsAtPath:path];
    
    if(!success) {
        
        
        //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //    
        //    NSString *downloadPath = [path stringByAppendingPathComponent:@"1.zip"];
        
        NSString *downloadPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        
        
        

        
        NSString *unzipPath;
        
        unzipPath = [[path stringByAppendingPathComponent:@"Unzip"] retain];
        
        ZipArchive *unzip = [[ZipArchive alloc] init];
        
        
        if ([unzip UnzipOpenFile:downloadPath]) {
            
            BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
            
            if (result) {
                
                DLog(@"解压成功！");
                
            }
            
            else {
                
                DLog(@"解压失败");
            }
            
            [unzip UnzipCloseFile];
        }
        
        else {
            
            DLog(@"解压失败2");
        }
        [unzip release];
        

    }
    
    //e==========

    

}


@end
