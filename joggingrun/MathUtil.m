//
//  MathUtil.m
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/20/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathUtil.h"

@interface MathUtil ()

@end

@implementation MathUtil

static bool fIsMetric = YES;
static double const fMetersInKM = 1000;
static double const fMetersInMile = 1609.344;

+ (void)toggleMetric {
	if (fIsMetric==YES) {
		fIsMetric=NO;
	}
	else {
		fIsMetric=YES;
	}
}

+ (NSString *)stringifyDistance:(double)meters
{
	
	double unitDivider;
	NSString *unitName;
 
	// metric
	if (fIsMetric) {
		unitName = @"km";
		// to get from meters to kilometers divide by this
		unitDivider = fMetersInKM;
		// U.S.
	} else {
		unitName = @"mile";
		// to get from meters to miles divide by this
		unitDivider = fMetersInMile;
	}
 
	return [NSString stringWithFormat:@"%.3f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat
{
	int remainingSeconds = seconds;
	int hours = remainingSeconds / 3600;
	remainingSeconds = remainingSeconds - hours * 3600;
	int minutes = remainingSeconds / 60;
	remainingSeconds = remainingSeconds - minutes * 60;
 
	if (longFormat) {
		if (hours > 0) {
			return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
		} else if (minutes > 0) {
			return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
		} else {
			return [NSString stringWithFormat:@"%isec", remainingSeconds];
		}
	} else {
		if (hours > 0) {
			return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
		} else if (minutes > 0) {
			return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
		} else {
			return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
		}
	}
}

+ (NSString *)stringifyAvgPaceFromDist:(double)meters overTime:(int)seconds
{
	if (seconds == 0 || meters == 0) {
		return @"0";
	}
 
	double avgPaceSecMeters = seconds / meters;
 
	double unitMultiplier;
	NSString *unitName;
 
	// metric
	if (fIsMetric) {
		unitName = @"min/km";
		unitMultiplier = fMetersInKM;
		// U.S.
	} else {
		unitName = @"min/mile";
		unitMultiplier = fMetersInMile;
	}
 
	int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
	int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
 
	return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

+ (NSString *)stringifyAvgSpeed:(double)speed
{
	double unitDivider;
	NSString *unitName;
 
	// metric
	if (fIsMetric) {
		unitName = @"km/h";
		unitDivider = fMetersInKM;
		// U.S.
	} else {
		unitName = @"mile/h";
		unitDivider = fMetersInMile;
	}
 
	if (speed <= 0) {
		speed = 0;
	}
 
	return [NSString stringWithFormat:@"%.3f %@", (speed / unitDivider) * 60*60, unitName];
}

@end
