//
//  NSBezierPathCodeBuilder.m
//  BezierBuilder
//
//  Created by Dave DeLong on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSBezierPathCodeBuilder.h"
#import "BezierPoint.h"

@implementation NSBezierPathCodeBuilder

- (NSString *) codeForBezierPoints {
	NSArray *points = [self effectiveBezierPoints];
	
	NSMutableArray *lines = [NSMutableArray array];
	
    if([points count] != 0)
    {
        BezierPoint *point = [points objectAtIndex:0];
        [lines addObject:[NSString stringWithFormat:@"portal1 = ccp(%0.1f,%0.1f);",
                          [point mainPoint].x, [point mainPoint].y]];
        point = [points objectAtIndex:[points count]-1];
        [lines addObject:[NSString stringWithFormat:@"portal2 = ccp(%0.1f,%0.1f);",
                          [point mainPoint].x, [point mainPoint].y]];
        [lines addObject:@""];
        
    }
    if([points count]!=0)
    for (NSUInteger i = 1; i < [points count]-1;++i)
    {
        BezierPoint *point = [points objectAtIndex:i];
        [lines addObject:[NSString stringWithFormat:@"case %ld:",i-1]];
        [lines addObject:[NSString stringWithFormat:@"    result = ccp(%0.1f,%0.1f);",
                          [point mainPoint].x, [point mainPoint].y]];
        [lines addObject:@"    break;"];
    }
    [lines addObject:@""];
    if([points count]!=0)
	for (NSUInteger i = 1; i < [points count]-1; ++i) {
		BezierPoint *point = [points objectAtIndex:i];
		if (i == 1){
		} else {
            [lines addObject:[NSString stringWithFormat:@"case %ld:",i-1]];
            [lines addObject:[NSString stringWithFormat:@"    result.controlPoint_1 = ccp(%0.1f, %0.1f);",[point controlPoint1].x, [point controlPoint1].y]];
            [lines addObject:[NSString stringWithFormat:@"    result.controlPoint_2 = ccp(%0.1f, %0.1f);",[point controlPoint2].x, [point controlPoint2].y]];
            [lines addObject:@"    break;"];
		}
	}
    
	return [lines componentsJoinedByString:@"\n"];
}

- (id) objectForBezierPoints {
	NSArray *points = [self effectiveBezierPoints];
	NSBezierPath *bp = [[NSBezierPath alloc] init];
	for (NSUInteger i = 0; i < [points count]; ++i) {
		BezierPoint *point = [points objectAtIndex:i];
		if (i == 0) {
			[bp moveToPoint:NSMakePoint([point mainPoint].x, [point mainPoint].y)];
		} else {
			[bp curveToPoint:NSMakePoint([point mainPoint].x, [point mainPoint].y) 
			   controlPoint1:NSMakePoint([point controlPoint1].x, [point controlPoint1].y) 
			   controlPoint2:NSMakePoint([point controlPoint2].x, [point controlPoint2].y)];
		}
	}
	
	return [bp autorelease];
}

@end
