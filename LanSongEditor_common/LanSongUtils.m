//
//  LanSongUtils.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "LanSongUtils.h"
#import <LanSongEditorFramework/LanSongEditor.h>

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "VideoPlayViewController.h"

@implementation LanSongUtils


+(void)showDialog:(NSString *)str
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
+(void) showHUDToast:(NSString *)strHint
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.mode=MBProgressHUDModeDeterminate;
    HUD.labelText=strHint;
    [HUD hide:YES afterDelay:1];
}

/**
 [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];

 @param nav
 @param dstPath <#dstPath description#>
 */
+(void)startVideoPlayerVC:(UINavigationController*)nav dstPath:(NSString *)dstPath
{
    if ([LSOFileUtil fileExist:dstPath]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstPath;
        [nav pushViewController:videoVC animated:YES];
    }else{
        NSString *str=[NSString stringWithFormat:@"文件不存在:%@",dstPath];
        [LanSongUtils showHUDToast:str];
    }
}

+ (void)setView:(UIView *)view toSizeWidth:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginX:(CGFloat)x
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOrigin:(CGPoint)origin
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

+ (BOOL)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            LSOLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFolderPathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    return path;
}



//--------------------
+ (CGImageRef)imageRefFromBGRABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 8,
                                                 imageSize.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}
+ (UIImage *)imageFromBRGABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    CGImageRef imageRef = [LanSongUtils imageRefFromBGRABytes:imageBytes imageSize:imageSize];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


/**
 设置当前viewController竖屏
 */
+(void)setViewControllerPortrait
{
    [LanSongUtils interfaceOrientation:UIInterfaceOrientationPortrait];
}

/**
 设置当前viewController横屏
 */
+(void)setViewControllerLandscape
{
    [LanSongUtils interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

/**
 在ViewController中调用, 设置当前屏幕的旋转角度.
 */
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    
    //[self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];  //横屏 home键在左边, 一般不用;
    //    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];  //横屏, home键在右侧, 常见横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
