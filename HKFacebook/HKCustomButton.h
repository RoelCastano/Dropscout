//
//  HKCustomButton.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKEvent.h"

@interface HKCustomButton : UIButton
@property (strong, nonatomic) HKEvent *event;
@end
