//
//  HKCreateEventViewController.m
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import "HKCreateEventViewController.h"
#import <HexColors/HexColor.h>

#define kEavesdrop @"https://eavesdrop.firebaseio.com/events"


@interface HKCreateEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *createEventLabel;
@property (weak, nonatomic) IBOutlet UIView *createView;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) Firebase *eventsFirebase;

@end

@implementation HKCreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.createView.layer setCornerRadius:8.0f];
    [self.createEventLabel setTextColor:[UIColor colorWithHexString:@"AE0000"]];
    
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = self.backgroundImage;
    [self.view insertSubview:backView belowSubview:self.createView];
    [self.createView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.5]];
    [self.createButton setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateNormal];
    
    self.eventsFirebase = [[Firebase alloc] initWithUrl:kEavesdrop];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createButtonPressed:(id)sender {
    if(![self.titleLabel.text isEqual:@""]){
        HKEvent *event = [[HKEvent alloc] init];
        event.name = self.titleLabel.text;
        event.latitude = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
        event.longitude = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
        
        
        id<HKCreateEventViewControllerDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(childViewController:didAddEvent:)]) {
            [strongDelegate childViewController:self didAddEvent:event];
        }

        [self dismissViewControllerAnimated:YES completion:nil];
        
        self.titleLabel.text = @"";
        //        NSIndexPath *myIP = [NSIndexPath indexPathForRow:[self.chat count]-1 inSection:0];
        //
        //
        //        [self.chatTableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }

}


- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
