//
//  HKCustomPointAnnotation.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HKEvent.h"

@interface HKCustomPointAnnotation : MKPointAnnotation

@property (strong, nonatomic) HKEvent *event;

@end
