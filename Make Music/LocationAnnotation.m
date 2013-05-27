//
//  LocationAnnotation.m
//  Make Music
//
//  Created by Matt Luedke on 5/14/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation
@synthesize coordinate;
@synthesize name, address;
//@synthesize performanceData;
@synthesize venue_id;

- (NSString *)subtitle{
    return address;
}

- (NSString *)title{
    return name;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate=c;
  //  NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}

@end
