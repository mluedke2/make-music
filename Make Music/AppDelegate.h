//
//  AppDelegate.h
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    NSArray *locationList;
    NSArray *venueList;
    NSArray *performanceList;
    NSArray *relevantPerformanceList;
    NSArray *artistList;
    
    NSDictionary *currentLocation;
    NSDictionary *currentVenue;
    
    NSString *genreFilter;
    
    NSString *nibAddOn;
    
}

@property (strong, nonatomic) NSArray *locationList;
@property (strong, nonatomic) NSArray *venueList;
@property (strong, nonatomic) NSArray *performanceList;
@property (strong, nonatomic) NSArray *relevantPerformanceList;
@property (strong, nonatomic) NSArray *artistList;

@property (strong, nonatomic) NSDictionary *currentLocation;
@property (strong, nonatomic) NSDictionary *currentVenue;

@property (strong, nonatomic) NSString *genreFilter;
@property (strong, nonatomic) NSString *nibAddOn;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
