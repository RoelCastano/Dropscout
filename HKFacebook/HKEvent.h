//
//  HKEvent.h
//  HKFacebook
//
//  Created by Roel Castano on 11/13/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#define kEavesdropSecondary @"https://eavesdrop.firebaseio.com/events"


@interface HKEvent : NSObject

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *name;
@property (retain, nonatomic) NSMutableArray *comments;
@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *wholePath;
@property (strong, nonatomic) Firebase *commentsFirebase;


-(id) initWithDictionary:(NSDictionary*)dict;


-(void)makePath;
-(void)subscribeToComments;


@end
