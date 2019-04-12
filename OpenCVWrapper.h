//
//  OpenCVWrapper.h
//  Coins
//
//  Created by Allen on 2019/3/28.
//  Copyright © 2019年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OpenCVWrapper : NSObject
+(NSString*)opencvversionstring;
+ (UIImage *)grayscaleFromImage:(UIImage*)image;
+(UIImage *) thresholding:(UIImage*)image;
+(void *) createWindow;
+(UIImage*)cartoonizes:(UIImage*)image;
+(NSMutableArray* ) backgroundsubtraction:(UIImage*)coins;
+(NSMutableArray*) getCircles:(UIImage*)image;
+(UIImage*) TestContour:(UIImage*) coins;
+(UIImage*)getGaussianImage:(UIImage*)image;
@end


