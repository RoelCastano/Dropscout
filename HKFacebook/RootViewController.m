//
//  RootViewController.m
//  HKFacebook
//
//  Created by Roel Castano on 11/13/14.
//  Copyright (c) 2014 Roel Castano. All rights reserved.
//

#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Firebase/Firebase.h>
#import <CoreLocation/CoreLocation.h>
#import "HKEvent.h"
#import "HKCustomButton.h"
#import "HKEventViewController.h"
#import "HKCreateEventViewController.h"
#import "HKCustomPointAnnotation.h"
#import "HKComment.h"
#import "HKCreateEventViewController.h"
#import <MapKit/MapKit.h>
#import <HexColors/HexColor.h>

#define kEavesdrop @"https://eavesdrop.firebaseio.com/events"



@interface RootViewController () <MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation, HKCreateEventViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Firebase *eavesdropFirebase;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;
@property (strong, nonatomic) NSDictionary *tempEvents;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (assign) BOOL firstTime;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // MAP CONFIGURATION
    [self.mapView setDelegate:self];
    self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude), MKCoordinateSpanMake(.05f, .05f));
    [self.mapView setRegion:region animated:NO];

    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    //FIREBASE EVENTS CONFIG
    self.events = [[NSMutableArray alloc] init];
    self.tempEvents = [[NSDictionary alloc] init];
    self.eavesdropFirebase = [[Firebase alloc] initWithUrl:kEavesdrop];
    __block BOOL initialAdds = YES;

    self.firstTime = YES;
    
    [self.eavesdropFirebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"------------------CHILD ADDED------------------");
        NSDictionary *dict = snapshot.value;
        HKEvent *event = [[HKEvent alloc] initWithDictionary:dict];
        event.path = snapshot.key;
        [event makePath];
        [self.events addObject:event];
        initialAdds = NO;
        HKCustomPointAnnotation *point = [[HKCustomPointAnnotation alloc] init];
        point.title = event.name;
        point.event = event;
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([event.latitude doubleValue], [event.longitude doubleValue]);
        [point setCoordinate:coordinates];
        [self.mapView addAnnotation:point];
        [self.mapAnnotations addObject:point];

    }];
    
    for (UIButton *button in self.buttons) {
        [button setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"AE0000"] forState:UIControlStateSelected];
    }
    

}
//
//- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
//{
//    MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
//    newAnnotation. = MKPinAnnotationColorGreen;
//    newAnnotation.animatesDrop = YES;
////    newAnnotation.canShowCallout = YES;
////    [newAnnotation setSelected:YES animated:YES];
//    return newAnnotation;
//}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[HKCustomPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"schools_maps"];
            HKCustomButton* rightButton = [HKCustomButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.event = ((HKCustomPointAnnotation*)annotation).event;
            [rightButton addTarget:self action:@selector(eventButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            // Add an image to the left callout.
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}

- (IBAction)createButtonPressed:(id)sender {
    UIImage* imageOfUnderlyingView = [self.view convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                 saturationDeltaFactor:1.3
                                                             maskImage:nil];
    HKCreateEventViewController *createEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"createVC"];
    createEventVC.backgroundImage = imageOfUnderlyingView;
    createEventVC.delegate = self;
    createEventVC.location = self.locationManager.location;
    
    [self presentViewController:createEventVC animated:YES completion:nil];
}

// Implement the delegate methods for ChildViewControllerDelegate

- (void)childViewController:(HKCreateEventViewController*)viewController didAddEvent:(HKEvent*)event{

    // Do something with value...
    NSLog(@"ADD EVENT: %@", event);
    [[self.eavesdropFirebase childByAutoId] setValue:@{@"name" : event.name, @"latitude": event.latitude, @"longitude": event.longitude}];

    // ...then dismiss the child view controller
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)eventButtonPressed:(id)sender{
    UIImage* imageOfUnderlyingView = [self.view convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                 saturationDeltaFactor:1.3
                                                             maskImage:nil];
    HKEventViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventVC"];
    eventVC.backgroundImage = imageOfUnderlyingView;
    eventVC.event = ((HKCustomButton*)sender).event;
    
    [self presentViewController:eventVC animated:YES completion:nil];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    view.canShowCallout = YES;
//    NSLog(@"ljnjhkb jkhb j,v jgvjg,h bj,hmb");
//    [mapView deselectAnnotation:view.annotation animated:NO];
//    
//    ILPopoverViewController *popOverCallout = [[ILPopoverViewController alloc]initWithDem:[self.demsForAnnotations objectForKey:[view.annotation title]]];
//    popOverCallout.delegate = self;
//    
//    UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:popOverCallout];
//    
//    self.annotationPopoverController = popOver;
//    
//    popOver.popoverContentSize = CGSizeMake(329, 228);
//    
//    [popOver presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

//- (IBAction)buttonPressed:(id)sender {
//    CLLocation* fromLocation = ((ILDirectionButton*)sender).mapItem.placemark.location;
//    NSLog(@"%@", ((ILDirectionButton*)sender).mapItem.placemark.location);
//    // Create a region centered on the starting point with a 10km span
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
//    
//    // Open the item in Maps, specifying the map region to display.
//    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:((ILDirectionButton*)sender).mapItem]
//                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
//                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
//                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
//}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.firstTime) {
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude), MKCoordinateSpanMake(.009f, .009f));
        [self.mapView setRegion:region animated:NO];
        self.firstTime = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self dismissViewControllerAnimated:NO completion:nil];
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
