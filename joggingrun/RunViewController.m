//
//  RunViewController.m
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/20/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

#import "RunViewController.h"

@interface RunViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fDistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *fSpeedValue;
@property (strong, nonatomic) UIImageView *fRunner;

@end

@implementation RunViewController

@synthesize fDistanceValue;
@synthesize fSpeedValue;
@synthesize fRunner;

const int kRunnerWidth = 100;
const int kRunnerHeight = 100;
bool isRunning = false;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		NSLog(@"initWithCoder");
		
		UIImage *run1Image = [UIImage imageNamed:@"run1.png"];
		UIImage *run2Image = [UIImage imageNamed:@"run2.png"];
		
		NSArray *imgListArray = @[run1Image, run2Image];
		
		fRunner = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, kRunnerWidth, kRunnerHeight)];
		fRunner.animationImages = imgListArray;
		fRunner.animationDuration = 1.0;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview: fRunner];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)runAction:(id)sender {
	if ( fRunner && !isRunning ) {
		[fRunner startAnimating];
		isRunning = true;
	}
}

- (IBAction)stopAction:(id)sender {
	if ( fRunner && isRunning ) {
		[fRunner stopAnimating];
		isRunning = false;
	}
	
	
}

@end
