//
//  MessageTableViewCell.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end
