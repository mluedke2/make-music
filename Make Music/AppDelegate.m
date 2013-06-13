//
//  AppDelegate.m
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MapViewController.h"
#import "GAI.h"

@implementation AppDelegate
@synthesize locationList, venueList, currentLocation, currentVenue, genreFilter, performanceList, artistList, nibAddOn, relevantPerformanceList, searchFilter;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // begin GoogleA.
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41658101-2"];
    // end GoogleA.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self initializeVariables];
    
    ViewController *baseViewController = [[ViewController alloc] initWithNibName:[NSString stringWithFormat:@"ViewController%@", self.nibAddOn] bundle:nil];

    UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:baseViewController];
    
    self.window.rootViewController = navigator;
    
    NSLog(@"venues count: %i", self.venueList.count);
    

    [self.window makeKeyAndVisible];
    return YES;
}


- (void)initializeVariables {
    
    self.locationList = [NSArray array];
    self.venueList = [NSArray array];
    self.performanceList = [NSArray array];
    self.artistList = [NSArray array];
    
    self.currentVenue = [NSDictionary dictionary];
    self.currentLocation = [NSDictionary dictionary];
    self.genreFilter = @"All";
    self.searchFilter = @"";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 568)
        {
            // iPhone 5
            nibAddOn = @"";
        }
        else {
            // not iPhone 5
            nibAddOn = @"_35";
            
        }
    }
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
