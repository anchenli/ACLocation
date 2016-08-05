//
//  ACBmobObject.m
//  UnlimitedBackStage
//
//  Created by anchen on 16/8/4.
//  Copyright © 2016年 anchen. All rights reserved.
//
#import <BmobSDK/Bmob.h>

#import "ACBmobObject.h"

@implementation ACBmobObject

+ (void)saveLon:(NSString *)lon lat:(NSString *)lat address:(NSString *)address{

    BmobObject *gameScore = [BmobObject objectWithClassName:@"location"];
    [gameScore setObject:lat forKey:@"lat"];
    [gameScore setObject:address forKey:@"address"];
    [gameScore setObject:lon forKey:@"lon"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
    }];
}

@end
