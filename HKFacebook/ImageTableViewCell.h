//
//  ImageTableViewCell.h
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end
