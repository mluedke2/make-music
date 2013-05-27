//
//  LocationAnnotation.h
//  Make Music
//
//  Created by Matt Luedke on 5/14/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSString *address;
    
    NSString *venue_id;
    
//    NSDictionary *performanceData;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSString *venue_id;
//@property (nonatomic, retain) NSDictionary *performanceData;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;



@end
