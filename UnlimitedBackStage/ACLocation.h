//
//  ACLocation.h
//  UnlimitedBackStage
//
//  Created by anchen on 16/8/4.
//  Copyright © 2016年 anchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ACLocation : NSObject <CLLocationManagerDelegate>

+ (instancetype)shareInstance;

- (void)beginUpdateLocation;

- (void)endUpdateLocation;

@end
