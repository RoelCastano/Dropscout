//
//  HKEvent.m
//  HKFacebook
//
//  Created by Roel Castano on 11/13/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import "HKEvent.h"
#import "HKComment.h"


@implementation HKEvent

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if(self)
    {
        if (dict[@"name"]) {
            self.name = [NSString stringWithString:dict[@"name"]];
        }
        self.latitude = [NSNumber numberWithFloat:0.0];
        self.latitude = dict[@"latitude"];
        if (dict[@"latitude"]) {
            self.latitude = dict[@"latitude"];
        }
        self.longitude = [NSNumber numberWithFloat:0.0];
        if (dict[@"longitude"]) {
            self.longitude = dict[@"longitude"];
        }
        self.comments = [[NSMutableArray alloc] init];
        if (dict[@"comments"]) {
            
            NSDictionary *dictionary = dict[@"comments"];
            [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
                HKComment *comment = [[HKComment alloc] init];
                comment.name = value[@"name"];
                comment.time = value[@"time"];
                comment.message = value[@"message"];
                comment.userId = value[@"user_id"];
                [self.comments addObject:comment];
            }];
        }
    }
    
    return self;

}

-(void)makePath{
    self.path = [kEavesdropSecondary stringByAppendingString:[NSString stringWithFormat:@"/%@",self.path]];
    self.wholePath = self.path;
    self.path = [self.path stringByAppendingString:@"/comments"];
    NSLog(@"%@", self.path);

}

-(void)subscribeToComments{
    [self.commentsFirebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.comments addObject:snapshot.value];
        
        // Reload the table view so the new message will show up.
        //        if (!initialAdds) {
        //            [self.chatTableView reloadData];
        //            NSIndexPath *myIP = [NSIndexPath indexPathForRow:[self.chat count]-1 inSection:0];
        //
        //            [self.chatTableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //            
        //        }
    }];
    
}


@end
