//  UIImage+OIInCache.h
//  v 1.0
//
//  Created by JingXian He(Tommy) on 2015-05-20.
//  Copyright (c) 2015 H. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "UIImage+OIInCache.h"

@implementation UIImage (OIInCache)

+(NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}
// create directory in the caches directory
+ (bool)createDirInCache:(NSString *)dirName
{
    NSString *imageDir = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isCreated = false;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }else if(existed == YES){
        isCreated = true;
    }
    return isCreated;
}


// save Image to the caches directory
+(bool) saveImageToCacheDir:(NSString *)directoryPath image:(UIImage *)image imageName: (NSString *)imageName type: (NSString *)imageType
{
    directoryPath = [self pathInCacheDirectory:directoryPath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if (!existed) {
        if ([self createDirInCache:directoryPath]) {
            existed = YES;
            isDir = YES;
        }else{
            NSLog(@"Can't create directory, did you input a file name insead of a directory name?");
            return existed;
        }
    }
    
    bool isSaved = false;
    
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]]
                                                              atomically:YES];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    return isSaved;
}

// load Image from caches dir to imageview
+ (UIImage *) loadImageData:(NSString *)directoryPath imageName: (NSString *)imageName
{
    directoryPath = [self pathInCacheDirectory:directoryPath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *imagePath = [directoryPath stringByAppendingPathComponent:imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
        
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *img = [UIImage imageWithData:imageData];
        return img;
    }
    else
    {
        return NULL;
    }
}


@end
