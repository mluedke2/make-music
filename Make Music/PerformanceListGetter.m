//
//  PerformanceListGetter.m
//  Make Music
//
//  Created by Matt Luedke on 5/14/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "PerformanceListGetter.h"
#import "AppDelegate.h"
#import "SBJson.h"

@implementation PerformanceListGetter

- (void)getPerformanceList:(NSString *)location {
    
    
    NSLog(@"is starting to get data");
	
	// first initialize the data that we'll be getting back, and start the request string with the baseURL
	responseData = [NSMutableData data];
    
	NSString *requestString = location;
	
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", requestString);
    
    // make the URL request with the string that has been put together...
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // the actual data is received in the connectionDidFinishLoading function
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	SBJsonParser *json = [SBJsonParser new];
	
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    // the data is in the form of an array
	
    if (responseString.length ==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userdata_fail" object:nil];
        return;
    }
    
    appDelegate.venueList = [[json objectWithString:responseString] objectForKey:@"venues"];
    appDelegate.performanceList = [[json objectWithString:responseString] objectForKey:@"performances"];
    appDelegate.artistList = [[json objectWithString:responseString] objectForKey:@"artists"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"perf_progress_done" object:nil];
    
    // also save these!
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:appDelegate.venueList] forKey:@"venueList"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:appDelegate.performanceList] forKey:@"performanceList"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:appDelegate.artistList] forKey:@"artistList"];
    
    if ([NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"venueList"]]) {
        NSLog(@"there are venues saved: %i", appDelegate.venueList.count);
        NSLog(@"there are venues saved: %i", [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"venueList"]] count]);
    }
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"perf_progress_sizer" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:response.expectedContentLength] forKey:@"numberToReach"]];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"perf_progress_continuer" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:data.length] forKey:@"numberToAdd"]];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userdata_fail" object:nil];
}


@end
