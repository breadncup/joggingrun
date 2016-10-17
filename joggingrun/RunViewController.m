//
//  RunViewController.m
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/20/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RunViewController.h"
#import "MathUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RunViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fDistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *fSpeedValue;
@property (strong, nonatomic) UIImageView *fRunner;
@property (strong, nonatomic) CLLocationManager *fLocationManager;
@property (strong, nonatomic) CLLocation *fPreviousLocationInfo;
@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer;

@end

@implementation RunViewController

@synthesize fDistanceValue;
@synthesize fSpeedValue;
@synthesize fRunner;
@synthesize fLocationManager;
@synthesize fPreviousLocationInfo;
@synthesize myAudioPlayer;

const int kRunnerWidth = 100;
const int kRunnerHeight = 100;

bool isRunning = false;
CLLocationDistance fPreviousLocation;
CLLocationDistance fTotalDistance;
CFTimeInterval fStartTime = 0;
CFTimeInterval fTotalSeconds = 0;
CLLocationSpeed fSpeed = 0;
NSTimer *fTimer = nil;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		NSLog(@"initWithCoder");
		
		UIImage *run1Image = [UIImage imageNamed:@"run1.png"];
		UIImage *run2Image = [UIImage imageNamed:@"run2.png"];
		
		NSArray *imgListArray = @[run1Image, run2Image];
		
		fRunner = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, kRunnerWidth, kRunnerHeight)];
		if (fRunner) {
			fRunner.animationImages = imgListArray;
			fRunner.animationDuration = 1.0;
		}
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview: fRunner];
	
	fLocationManager = [[CLLocationManager alloc]init]; // initializing locationManager

	if (fLocationManager) {
		fLocationManager.delegate = self; // we set the delegate of locationManager to self.
		fLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // setting the accuracy}
		fLocationManager.activityType = CLActivityTypeFitness;
		fLocationManager.distanceFilter = 5;
		fLocationManager.allowsBackgroundLocationUpdates = true;
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
			[fLocationManager requestAlwaysAuthorization];
	}
	
	[self initInternal];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) initInternal {
	fDistanceValue.text = @"0";
	fSpeedValue.text = @"0";
	fTotalDistance = 0;
	fPreviousLocationInfo = NULL;
	fStartTime = 0;
	fTotalSeconds = 0;
}

- (void) targetMethod {
	// Every 2.0 seconds, this is called.
}

- (IBAction)runAction:(id)sender {
	if ( fRunner && !isRunning ) {
		[fRunner startAnimating];
		isRunning = true;
		[self initInternal];
		[fLocationManager startUpdatingLocation];
		
		//start a background sound
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"p1" ofType: @"mp3"];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
		myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
		myAudioPlayer.numberOfLoops = -1; //infinite loop
		[myAudioPlayer play];
		
		
		fTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
										 target:self
									   selector:@selector(targetMethod)
									   userInfo:nil
										repeats:YES];
	}
}

- (IBAction)stopAction:(id)sender {
	if ( fRunner && isRunning ) {
		[fRunner stopAnimating];
		[fLocationManager stopUpdatingLocation];
		isRunning = false;
		[self initInternal];
		if ( fTimer )
			[fTimer invalidate];
	}
}

- (IBAction)metricAction:(id)sender {
	[MathUtil toggleMetric];
	if (fRunner && isRunning) {
		[self displayDistanceAndSpeed];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusRestricted:
			NSLog(@"Restricted Access to location");
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"User denied access to location");
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"Status not determined");
			break;
		case kCLAuthorizationStatusAuthorizedAlways:
			NSLog(@"Authorized Always");
			break;
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			NSLog(@"Authorized When In Use");
			break;
		default:
			NSLog(@"Allowed to location Access");
			break;
	}
}

- (void)displayDistanceAndSpeed {
	fDistanceValue.text = [MathUtil stringifyDistance:fTotalDistance];
	fSpeedValue.text = [MathUtil stringifyAvgSpeed:fSpeed];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	// for Geographic, please, refer to
	// http://stackoverflow.com/questions/4152003/how-can-i-get-current-location-from-user-in-ios

	for (CLLocation *newLocation in locations) {
		if (newLocation.horizontalAccuracy < 6) {
			// update distance
			if (fPreviousLocationInfo) {
				NSLog(@"total distance: %f", fTotalDistance);
				fTotalDistance += [newLocation distanceFromLocation:fPreviousLocationInfo];
				fSpeed = newLocation.speed;
				NSLog(@"after total distance: %f", fTotalDistance);
				[self displayDistanceAndSpeed];
			}
			
			fPreviousLocationInfo = newLocation;
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Error");
}

@end
