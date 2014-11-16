//
//  HKUser.h
//  HKFacebook
//
//  Created by Roel Castano on 11/13/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface HKUser : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) FBProfilePictureView *profilePicture;

@end
