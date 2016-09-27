//
//  RunViewController.m
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/20/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "RunViewController.h"
#import "MathUtil.h"
#import "FliteTTS.h"

@interface RunViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fDistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *fSpeedValue;
@property (strong, nonatomic) UIImageView *fRunner;
@property (strong, nonatomic) CLLocationManager *fLocationManager;
@property (strong, nonatomic) CLLocation *fPreviousLocationInfo;

@property (weak, nonatomic) IBOutlet UISlider *fPitchValue;
@property (weak, nonatomic) IBOutlet UISlider *fVarianceValue;
@property (weak, nonatomic) IBOutlet UISlider *fVSpeedValue;
@property (weak, nonatomic) IBOutlet UILabel *fPitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *fVarianceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fVSpeedLabel;


@end

@implementation RunViewController

@synthesize fDistanceValue;
@synthesize fSpeedValue;
@synthesize fRunner;
@synthesize fLocationManager;
@synthesize fPreviousLocationInfo;

@synthesize fPitchValue;
@synthesize fVarianceValue;
@synthesize fVSpeedValue;
@synthesize fPitchLabel;
@synthesize fVarianceLabel;
@synthesize fVSpeedLabel;

const int kRunnerWidth = 100;
const int kRunnerHeight = 100;

bool isRunning = false;
CLLocationDistance fPreviousLocation;
CLLocationDistance fTotalDistance;
CFTimeInterval fStartTime = 0;
CFTimeInterval fTotalSeconds = 0;
CLLocationSpeed fSpeed = 0;
FliteTTS *fFliteEngine;	// https://bitbucket.org/sfoster/iphone-tts/src
NSTimer *fTimer = nil;
//dispatch_queue_t fQueue = nil;

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
		
//		fPitchValue.value = 100.0;
//		fVarianceValue.value = 100.0;
//		fVSpeedValue.value = 0.8;
		
		fFliteEngine = [[FliteTTS alloc] init];
		if ( fFliteEngine ) {
//			[fFliteEngine setPitch:fPitchValue.value variance:fVarianceValue.value speed:fVSpeedValue.value];	// Change the voice properties
//			[fFliteEngine setVoice:@"usenglish"];
			
		}
//		fQueue = dispatch_queue_create( "joggingrun", nil );
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview: fRunner];
	
	fLocationManager = [[CLLocationManager alloc]init]; // initializing locationManager

	if (fLocationManager) {
		fLocationManager.delegate = self; // we set the delegate of locationManager to self.
		fLocationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy}
		fLocationManager.activityType = CLActivityTypeFitness;
		fLocationManager.distanceFilter = 10;
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

- (void)runScheduledTask {
	if ( fFliteEngine ) {
		[fFliteEngine setPitch:fPitchValue.value variance:fVarianceValue.value speed:fVSpeedValue.value];	// Change the voice properties
	}
	[fFliteEngine speakText:@"Hello everyone world championship competition race game. Junsung is the most strong candidate of gold medal. Has highest record than the rest of them. Average time 10 min with average speed 15 km/h"];
//	dispatch_sync(fQueue, ^{
//	});
//	dispatch_sync(fQueue, ^{
//		[fFliteEngine speakText:@"and Junsung is coming follow!"];
//	});
}

- (IBAction)runAction:(id)sender {
	if ( fRunner && !isRunning ) {
		[fRunner startAnimating];
		isRunning = true;
		[self initInternal];
		[fLocationManager startUpdatingLocation];
		
		fTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
										 target:self
									   selector:@selector(runScheduledTask)
									   userInfo:nil
										repeats:YES];
		[fFliteEngine speakText:@"Hello everyone world championship competition race game. Junsung is the most strong candidate of gold medal. Has highest record than the rest of them. Average time 10 min with average speed 15 kilometer per hour"];
//		[fFliteEngine speakText:@"Okay, now, Daniel is just starting to run!"];
		// Crowd Sound: https://www.youtube.com/watch?v=vYltefXSIHU
	}
}

- (IBAction)stopAction:(id)sender {
	if ( fRunner && isRunning ) {
		[fRunner stopAnimating];
		[fLocationManager stopUpdatingLocation];
		isRunning = false;
		[self initInternal];
		[fFliteEngine stopTalking];				// stop talking
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
		if (newLocation.horizontalAccuracy < 20) {
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

- (IBAction)pitchAction:(id)sender {
	fPitchLabel.text = [NSString stringWithFormat:@"%3.3f", fPitchValue.value];
}
- (IBAction)varianceAction:(id)sender {
	fVarianceLabel.text = [NSString stringWithFormat:@"%3.3f", fVarianceValue.value];
}

- (IBAction)vspeedAction:(id)sender {
	fVSpeedLabel.text = [NSString stringWithFormat:@"%3.3f", fVSpeedValue.value];
}

@end
