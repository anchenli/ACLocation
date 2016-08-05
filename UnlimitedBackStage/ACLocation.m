//
//  ACLocation.m
//  UnlimitedBackStage
//
//  Created by anchen on 16/8/4.
//  Copyright © 2016年 anchen. All rights reserved.
//

#import "ACLocation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "ACBmobObject.h"


const NSString *manKey = @"manKey";

@implementation ACLocation

+ (instancetype)shareInstance{

    static dispatch_once_t once;
    static ACLocation *_location;
    
    dispatch_once(&once, ^{
        _location = [[self alloc] init];
        [_location initLocationManager];
    });
    
    return _location;
}

- (void)initLocationManager{

    CLLocationManager *_manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager startMonitoringSignificantLocationChanges];
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = kCLDistanceFilterNone;
    _manager.pausesLocationUpdatesAutomatically = NO;
    [_manager requestWhenInUseAuthorization];
    /**
     设置定位数据的用途，跟踪车辆
     */
    _manager.activityType = CLActivityTypeAutomotiveNavigation;
    
    objc_setAssociatedObject(self, (__bridge const void *)(manKey), _manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
}

static CFAbsoluteTime upTime = 0;

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currLocation = [locations lastObject];
    
    CFAbsoluteTime nowTime = CFAbsoluteTimeGetCurrent();
    
    /**
     每两分钟提交一次服务器位置信息
     */
    if (nowTime - upTime  > 120) {
        upTime = nowTime;
        
        NSString *lon = [NSString stringWithFormat:@"%lf",currLocation.coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%lf",currLocation.coordinate.latitude];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
//                 NSLog(@"_____地址___%@",placemark.addressDictionary);
                 [ACBmobObject saveLon:lon lat:lat address:placemark.thoroughfare];
             }
         }
         ];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [[[ACLocation shareInstance] getLocationManager] requestAlwaysAuthorization];
        }
    }
}

- (void)beginUpdateLocation{

    CLLocationManager *_manager = [[ACLocation shareInstance] getLocationManager];
    [_manager startUpdatingLocation];
}

- (void)endUpdateLocation{

    CLLocationManager *_manager = [[ACLocation shareInstance] getLocationManager];
    [_manager stopUpdatingLocation];
}

- (CLLocationManager *)getLocationManager{

    return (CLLocationManager *)objc_getAssociatedObject(self, (__bridge const void *)(manKey));
}

@end
