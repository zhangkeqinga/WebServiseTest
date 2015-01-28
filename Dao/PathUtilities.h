//
//  PathUtilities.h
//  TaiPing
//
//  Created by bbdtek on 11-8-31.
//  Copyright 2011 bbdtek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZipArchive.h"

@interface PathUtilities : NSObject 

+ (NSString *)documentFilePathWithFileName:(NSString*)fileName;

+ (BOOL)createDirectoryIfNotExistsAtPath:(NSString *)path;

//Open  XML OR txt File
+ (NSString *)openXMLWithFileName:(NSString *)fileName;

+ (NSString *)libraryFilePathWithFileName:(NSString*)fileName;

//Copy File 
+ (void) copyDatabaseIfNeededWithFileName:(NSString*)fileName  SearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;


//Wirte File
+ (NSString *)writeToFile:(NSData *)data  withFileName:(NSString *) fileName;

//delete File
+ (void)deteleFile:(NSString*)fileName;

//imgUrl :  folderName:docunent   renFileName:文件重命名
+(BOOL)downloadFileAndSaveWithURL:(NSString*)imgUrl withDocument:(NSString*)folderName renFileName:(NSString*)fileName;


//update documents在appDelte中实现
//remove old file  move *.temp old name 
+(void)updateFilesWithDocument:(NSString*)documents;

//
////unzip File
//+(void)unzipFile:(NSString*)fileName  toUnzipPath:(NSString*) unzipFile_ ;
//
////解压到制定目录
//+(void)unzipFile:(NSString*)fileName  SearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory toUnzipPath:(NSString*) unzipFile_ ;
@end
