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

@implementation AppDelegate
@synthesize locationList, venueList, currentLocation, currentVenue, genreFilter, performanceList, artistList, nibAddOn, relevantPerformanceList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self initializeVariables];
    
    ViewController *baseViewController = [[ViewController alloc] initWithNibName:[NSString stringWithFormat:@"ViewController%@", self.nibAddOn] bundle:nil];

    UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:baseViewController];
    
    self.window.rootViewController = navigator;
    
    NSLog(@"venues count: %i", self.venueList.count);
    
    /*
    if (self.venueList.count > 0) {
        // move on to the navigation controller
        
        MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:[NSString stringWithFormat:@"MapViewController%@", self.nibAddOn] bundle:nil];
        
        [navigator pushViewController:mapViewController animated:NO];
        
    }
     */

    [self.window makeKeyAndVisible];
    return YES;
}


- (void)initializeVariables {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.locationList = [NSArray array];
    self.venueList = [NSArray array];
    self.performanceList = [NSArray array];
    self.artistList = [NSArray array];
    
    self.currentVenue = [NSDictionary dictionary];
    self.currentLocation = [NSDictionary dictionary];
    self.genreFilter = @"All";
    
    if ([defaults objectForKey:@"locationList"]) {
        self.locationList = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"locationList"]];
    }
    
    if ([defaults objectForKey:@"currentLocation"]) {
        self.currentLocation = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"currentLocation"]];
    }
    
    if ([defaults objectForKey:@"performanceList"]) {
        self.performanceList = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"performanceList"]];
    }
    
    NSLog(@"about to test for venues");
    if ([NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"venueList"]]) {
        NSLog(@"there are venues saved");
        self.venueList = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"venueList"]];
        NSLog(@"there are venues saved: %i", self.venueList.count);
        NSLog(@"there are venues saved: %i", [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"venueList"]] count]);
    }
    
    if ([defaults objectForKey:@"artistList"]) {
        self.artistList = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"artistList"]];
    }
    
    
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
