//
//  OpenCVWrapper.m
//  Coins
//
//  Created by Allen on 2019/3/28.
//  Copyright © 2019年 Allen. All rights reserved.
//


#import <OpenCV/opencv2/opencv.hpp>
#include <OpenCV/opencv2/highgui.hpp>
#import "OpenCVWrapper.h"
@implementation OpenCVWrapper
using namespace std;

+(NSString *)opencvversionstring{
    return [NSString stringWithFormat:@"OpenCV Version %s",CV_VERSION];
}

+(void*)createWindow{
    cv::Mat shoes = cv::imread("shoes.jpg");
    cv::namedWindow("shoes");
    cv::imshow("shoes", shoes);
    return 0 ; 
}

+(NSMutableArray* ) backgroundsubtraction:(UIImage*)coins{
    cv:: Mat coinpic,backgroundpic,diffpic,newpic,newpic2,newpic3,newpic4;
    int *arr;
    cv::cvtColor([self cvMatFromUIImage:coins], coinpic, cv::COLOR_BGR2GRAY);
    cv::Size_<int> sizes2 = cv::Size(5,5);
    cv::GaussianBlur(coinpic , coinpic, sizes2, cv::BORDER_DEFAULT);
    cv::threshold(coinpic, newpic, 0, 255, cv::THRESH_BINARY_INV+cv::THRESH_OTSU);
    //cv::adaptiveThreshold(coinpic, newpic, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY_INV, 11, 1);
    cv::Mat kernel = cv::Mat::ones(3,3, CV_8UC1);
    cv::morphologyEx(newpic, newpic, cv::MORPH_CLOSE, kernel);
    //cv::dilate(newpic, newpic2, kernel);
    cv::erode(newpic, newpic2, kernel);
    cv::medianBlur(newpic2, newpic2,11);
    
    vector<vector<cv::Point>>contours;
    vector<cv::Vec4i> hierarchy;
    
    NSMutableArray *imagesArray = [NSMutableArray array];
    cv::findContours(newpic2, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);
    newpic4 = [self cvMatFromUIImage:coins];
    
    cv::Mat mask = cv::Mat::zeros(newpic4.rows, newpic4.cols, CV_8UC1);
    
    for (int i = 0 ; i<contours.size(); i++) {
        int area = cv::contourArea(contours[i]);
        //cout<<"it is "<<hierarchy[i][3]<<endl;
        
        if(area>20000 && hierarchy[i][3] == -1){
            cv::drawContours(newpic4, contours, i, cv::Scalar(255,100,0),13);
            cout<<"area is "<<area<<endl;
            cv::Rect rects = boundingRect(contours[i]);
            
            UIImage* newimage = [self UIImageFromCVMat:newpic4 ];
            
            cv::Mat croppedimage = newpic4(rects);
            
            croppedimage.copyTo(mask);
            
            UIImage* newimage2 = [self UIImageFromCVMat:mask ];
            [imagesArray addObject:newimage2];
        }
    }
    [imagesArray addObject:[self UIImageFromCVMat:newpic4]];
    return imagesArray;
}

+(UIImage*) TestContour:(UIImage*) coins{
    cv:: Mat coinpic,backgroundpic,diffpic,newpic,newpic2,newpic3,newpic4;
    int *arr;
    cv::cvtColor([self cvMatFromUIImage:coins], coinpic, cv::COLOR_BGR2GRAY);
    cv::Size_<int> sizes2 = cv::Size(7,7);
    //cv::GaussianBlur(coinpic , coinpic, sizes2, 0);
    cv::medianBlur(coinpic, coinpic, 11);
    cv::threshold(coinpic, newpic, 0, 255, cv::THRESH_BINARY_INV+cv::THRESH_OTSU);
    
    cv::Mat kernel = cv::Mat::ones(8,8, CV_8UC1);
    cv::morphologyEx(newpic, newpic, cv::MORPH_CLOSE, kernel);
    cv::dilate(newpic, newpic2, kernel);
    cv::medianBlur(newpic2, newpic2,11);
    
    vector<vector<cv::Point>>contours;
    vector<cv::Vec4i> hierarchy;

    NSMutableArray *imagesArray = [NSMutableArray array];
    cv::findContours(newpic2, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);
    newpic4 = [self cvMatFromUIImage:coins];

    for (int i = 0 ; i<contours.size(); i++) {
        int area = cv::contourArea(contours[i]);
        //cout<<"it is "<<hierarchy[i][3]<<endl;
        if(area>20000 && hierarchy[i][3] == -1){
            cv::drawContours(newpic4, contours, i, cv::Scalar(255,100,0),13);
        }
    }
    return [self UIImageFromCVMat:newpic4];
}

+(UIImage*)getGaussianImage:(UIImage *)image{
    cv::Mat src,src_gray,newimage,mask;
    src = [self cvMatFromUIImage:image];
    cv::cvtColor(src, src_gray, CV_BGR2GRAY);
    cv::Size_<int> sizes2 = cv::Size(7,7);
    cv::GaussianBlur(src_gray, src_gray, sizes2, 0);
    cv::threshold(src_gray, src_gray, 120, 255, cv::THRESH_BINARY);
    //cv::floodFill(src_gray, cv::Point(0,0), cv::Scalar(0));
    cv::Size_<int> sizes3 = cv::Size(10,10);
    cv::Mat kernel = cv::Mat::ones(10,10, CV_8UC1);
    cv::morphologyEx(src_gray, src_gray, cv::MORPH_CLOSE, kernel);
    cv::dilate(src_gray, src_gray, kernel);
     vector<cv::Vec3f> circles;
    cv::HoughCircles(src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows/5);
    cout<<"size is "<<circles.size()<<endl;
    return [self UIImageFromCVMat:src_gray];
}


+(NSMutableArray*)getCircles:(UIImage*)image{
    cv::Mat src,src_gray,newimage,mask;
    src = [self cvMatFromUIImage:image];
    cv::cvtColor(src, src_gray, CV_RGB2GRAY);
    cv::Size_<int> sizes2 = cv::Size(7,7);
    cv::GaussianBlur(src_gray, src_gray, sizes2, 0);
    cv::medianBlur(src_gray, src_gray, 5);
    vector<cv::Vec3f> circles;
    cv::Mat kernel = cv::Mat::ones(5,5, CV_8UC1);
    NSMutableArray *imagesArray = [NSMutableArray array];
    //cv::medianBlur(src_gray, src_gray, 51);
    cv::HoughCircles(src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows/6);
    mask = cv::Mat::zeros(src.rows, src.cols, CV_8UC1);
    //NSMutableArray *imagesArray = [NSMutableArray array];
    for (int i = 0 ; i<circles.size(); i++) {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
       
        //cv::Rect newrect = cv::boundingRect(newarray);
        
        int radius = cvRound(circles[i][2]);
        
        cout<<"radius is "<<radius<<endl;
        if(radius <= 400){
                cv::circle(src, center, radius, cv::Scalar(255,100,3),10);
                cv::rectangle(src, cvPoint((center.x)-(radius+10),(center.y)-(radius+10)), cvPoint((center.x)+(radius+10),(center.y)+(radius+10)), cv::Scalar(255,100,3),5);
                cv::Rect rrect(cvPoint((center.x)-(radius+10),(center.y)-(radius+10)), cvPoint((center.x)+(radius+10),(center.y)+(radius+10)));
                cv::Mat croppedimage = src(rrect);
            
                croppedimage.copyTo(mask);
                UIImage* newimage2 = [self UIImageFromCVMat:mask ];
                [imagesArray addObject:newimage2];
        }

    }
    [imagesArray addObject:[self UIImageFromCVMat:src]];
    
    return imagesArray;
}


+ (UIImage *)grayscaleFromImage:(UIImage*)image{
    cv::Mat matrix = [self cvMatFromUIImage:image];
    
    cv::Mat resultMatrix;
    
    /*
     * Add OpenCV method calls for processing/filtering
     */
    cv::cvtColor(matrix, resultMatrix, CV_BGR2GRAY, 4);
    
    
    // convert modified matrix back to UIImage
    return [self UIImageFromCVMat:resultMatrix];
}

+(cv::Mat)cvMatFromUIImage:(UIImage*)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,     // Pointer to data
                                                    cols,           // Width of bitmap
                                                    rows,           // Height of bitmap
                                                    8,              // Bits per component
                                                    cvMat.step[0],  // Bytes per row
                                                    colorSpace,     // Color space
                                                    kCGImageAlphaNoneSkipLast
                                                    | kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    
    CGColorSpaceRef colorspace;
    
    if (cvMat.elemSize() == 1) {
        colorspace = CGColorSpaceCreateDeviceGray();
    }else{
        colorspace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Create CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorspace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    // get uiimage from cgimage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorspace);
    return finalImage;
}

@end
