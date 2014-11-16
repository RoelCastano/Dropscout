//
//  HKCreateEventViewController.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKEvent.h"
#import <CoreLocation/CoreLocation.h>

@protocol HKCreateEventViewControllerDelegate;

@interface HKCreateEventViewController : UIViewController
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, weak) id<HKCreateEventViewControllerDelegate> delegate;

@end

@protocol HKCreateEventViewControllerDelegate <NSObject>

- (void)childViewController:(HKCreateEventViewController*)viewController didAddEvent:(HKEvent*)event;

@end
