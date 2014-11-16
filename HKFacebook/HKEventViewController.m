//
//  HKEventViewController.m
//  HKFacebook
//
//  Created by Roel Castano on 11/14/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import "HKEventViewController.h"
#import "HKComment.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MessageTableViewCell.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import "UIImage+ImageEffects.h"
#import "ImageTableViewCell.h"
#import <HexColors/HexColor.h>

@interface HKEventViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) Firebase *commentsFirebase;
@property (strong, nonatomic) Firebase *firebase;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyboardAvoidingView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@end

@implementation HKEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
//    self.tableView.estimatedRowHeight = 67.0;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.eventName.text = self.event.name;
    self.messagesArray = [[NSMutableArray alloc] init];
    
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = self.backgroundImage;
    [self.view insertSubview:backView belowSubview:self.keyboardAvoidingView];

//    [self.event subscribeToComments];
    NSLog(@"%@", self.event.path);
    self.firebase = [[Firebase alloc] initWithUrl: [self.event.wholePath stringByAppendingString:@"/users"]];
    
    self.commentsFirebase = [[Firebase alloc] initWithUrl:self.event.path];
    __block BOOL initialAdds = YES;

    [self.commentsFirebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        NSLog(@"INPUT INPUT INPUT");
        [self.messagesArray addObject:snapshot.value];
        NSLog(@"%@", snapshot.value);
        // Reload the table view so the new message will show up.
                if (!initialAdds) {
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messagesArray count]-1 inSection:0]
                                       atScrollPosition:UITableViewScrollPositionBottom
                                               animated:YES];
//                    NSIndexPath *myIP = [NSIndexPath indexPathForRow:[self.chat count]-1 inSection:0];
//        
//                    [self.tableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
                }
    }];
    
    [self.commentsFirebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];

    // Do any additional setup after loading the view.
    [self.eventName setTextColor:[UIColor colorWithHexString:@"AE0000"]];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateSelected];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateNormal];
}

-(void)loadView
{
    [super loadView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Determine which reuse identifier should be used for the cell at this index path.
//    NSString *reuseIdentifier = @"messageCell";
//    
//    // Use a dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
//    // it in the dictionary if one hasn't already been added for the reuse identifier.
//    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
//    // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
//    MessageTableViewCell *cell = [[MessageTableViewCell alloc] init];
//    
//    
//    // Configure the cell with content for the given indexPath, for example:
//    // cell.textLabel.text = someTextForThisCell;
//    // ...
//    
//    // Make sure the constraints have been set up for this cell, since it may have just been created from scratch.
//    // Use the following lines, assuming you are setting up constraints from within the cell's updateConstraints method:
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    
//    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
//    // correct cell height for different table view widths if the cell's height depends on its width (due to
//    // multi-line UILabels word wrapping, etc). We don't need to do this above in -[tableView:cellForRowAtIndexPath]
//    // because it happens automatically when the cell is used in the table view.
//    // Also note, the final width of the cell may not be the width of the table view in some cases, for example when a
//    // section index is displayed along the right side of the table view. You must account for the reduced cell width.
//    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//    
//    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
//    // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews] method
//    // of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
//    
//    // Get the actual height required for the cell's contentView
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    // Add an extra point to the height to account for the cell separator, which is added between the bottom
//    // of the cell's contentView and the bottom of the table view cell.
//    height += 1.0f;
//    
//    return height;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *comment = [self.messagesArray objectAtIndex:indexPath.row];
//    if (![comment objectForKey:@"image"]) {
//        return 85;
//    } else {
//        return 190;
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSDictionary *comment = [self.messagesArray objectAtIndex:indexPath.row];
    
    if (![comment objectForKey:@"image"]) {
        NSLog(@"MESSAGE!!!");
        static NSString *cellIdentifier = @"messageCell";
        MessageTableViewCell *cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        if (!cell) {
            cell = [[MessageTableViewCell alloc] init];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userName.text = comment[@"name"];
        cell.messageLabel.text = comment[@"message"];
        cell.profilePicture.profileID = [NSString stringWithFormat:@"%@", comment[@"user_id"]];
        return cell;

    } else {
        NSLog(@"IMAGE!!!");
        static NSString *cellIdentifier2 = @"imageCell";
        ImageTableViewCell *cell = (ImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        
        
        if (!cell) {
            cell = [[ImageTableViewCell alloc] init];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userName.text = comment[@"name"];
        NSString *string = [NSString stringWithFormat:@"http://104.131.34.221%@", comment[@"image"]];
        NSURL *imageURL = [NSURL URLWithString:string];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        [cell.imageView setClipsToBounds:YES];
        cell.imageView.image = image;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.profilePicture.profileID = [NSString stringWithFormat:@"%@", comment[@"user_id"]];
        return cell;

    }
    
    
    

}

- (IBAction)sendButtonPressed:(id)sender {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"USER LOGGED IN");
        [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             NSLog(@"%@", user);
             self.firstName = [NSString stringWithFormat:@"%@", user.first_name];
//             self.lastName = user.last_name;
             //                 NSString *facebookId = user.id;
             //                 NSString *email = [user objectForKey:@"email"];
             //                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];

             if (!error) {
             }
         }];
    }

    if(![self.messageTextField.text isEqual:@""]){
        [[self.commentsFirebase childByAutoId] setValue:@{@"name" : @"Roel Castano", @"message": self.messageTextField.text, @"user_id": @"10205436162046327"}];
        [[self.firebase childByAutoId] setValue: @"10205436162046327"];
        
        
        self.messageTextField.text = @"";
        //        NSIndexPath *myIP = [NSIndexPath indexPathForRow:[self.chat count]-1 inSection:0];
        //
        //
        //        [self.chatTableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }
    [self.messageTextField resignFirstResponder];
    
}

- (IBAction)mapButtonPressed:(id)sender {
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
