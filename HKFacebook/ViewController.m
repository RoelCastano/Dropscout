//
//  ViewController.m
//  HKFacebook
//
//  Created by Roel Castano on 11/13/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import <HexColors/HexColor.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.appNameLabel setFont:[UIFont fontWithName:@"Pacifico" size:47]];
    self.appNameLabel.numberOfLines = 1;
    self.appNameLabel.minimumFontSize = 8.;
    self.appNameLabel.adjustsFontSizeToFitWidth = YES;
//    [self.appNameLabel setTextColor:[UIColor colorWithHexString:@"AE0000"]];
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.delegate = self;
    self.loginView.hidden = NO;
    
    self.loginView.readPermissions = @[@"email",  @"user_birthday", @"user_location"];
    self.loginView.defaultAudience = FBSessionDefaultAudienceFriends;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    // if access token is expired close session
    RootViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootVC"];
    [self presentViewController:rootVC
                       animated:YES
                     completion:nil];
    //Show progress spinner
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
