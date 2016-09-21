//
//  MathUtil.h
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/20/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

#ifndef MathUtil_h
#define MathUtil_h

@interface MathUtil : NSObject

+ (void)toggleMetric;
+ (NSString *)stringifyDistance:(double)meters;
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *)stringifyAvgPaceFromDist:(double)meters overTime:(int)seconds;
+ (NSString *)stringifyAvgSpeed:(double)speed;

@end

#endif /* MathUtil_h */
