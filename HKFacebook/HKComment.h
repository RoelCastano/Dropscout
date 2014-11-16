//
//  HKComment.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKComment : NSObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *userId;


@end
