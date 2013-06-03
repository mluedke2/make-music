//
//  ViewController.m
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PerformanceListGetter.h"
#import "DataGetter.h"
#import "MapViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locationTableView;
@synthesize progressHolder, progressShower, progressSize, progressLabel;
@synthesize locationManager, shouldAcceptThisLocation;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
    progressHolder.hidden = YES;
    [progressShower setProgress:0.0 animated:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // clear out whatever's on the stack already
    self.navigationController.viewControllers = [NSArray arrayWithObject:self];
    
    // if there is already a default location set, just move on to the navigation controller
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
   
        
    if (appDelegate.locationList.count > 0) {
            
            // use the list of locations as-is
            
        } else {
            
            // get the list of locations!
            DataGetter *dataGetter = [[DataGetter alloc] init];
            [dataGetter getTheAppData];
            
            progressHolder.hidden = NO;
            [progressShower setProgress:0.0 animated:NO];
            progressLabel.text = @"Finding festivals...";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sizeProgress:) name:@"progress_sizer" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgressAndReload) name:@"fest_progress_done" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"progress_continuer" object:nil];
            
        }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationTableView.separatorColor = [UIColor darkGrayColor];
    progressLabel.font = [UIFont fontWithName:@"Font-Family:kalingab" size:18];
    progressHolder.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
    progressShower.progressTintColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
    UIImage *image = [UIImage imageNamed:@"BlankHeader.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    UILabel *mapTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    mapTitle.font = [UIFont fontWithName:@"Font-Family:kalingab" size:20];
    mapTitle.textColor = [UIColor whiteColor];
    mapTitle.backgroundColor = [UIColor clearColor];
    mapTitle.textAlignment = UITextAlignmentCenter;
    mapTitle.text = @"Select a City";
    self.navigationItem.titleView = mapTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.locationList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"topCategory"];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCategory"];
    
    cell.frame = CGRectZero;
    
    cell.selectedBackgroundView = [[UIImageView alloc] init];
  //  ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"gray_all_day.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:[[appDelegate.locationList objectAtIndex:indexPath.row] objectForKey:@"logo"], @"image_url", cell, @"cell", nil];
    
    [self performSelectorInBackground:@selector(loadCityImage:) withObject:imageData];
    
    cell.textLabel.hidden = YES;
    UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(130, 44, 170, 20)];
    cityName.textAlignment = UITextAlignmentLeft;
    cityName.backgroundColor = [UIColor clearColor];
    cityName.text = [[appDelegate.locationList objectAtIndex:indexPath.row] objectForKey:@"name"];
    //cityName.center = [cell.superview convertPoint:cell.center toView:cell];
    cityName.font = [UIFont fontWithName: @"Arial-BoldMT" size:20.0];
    cityName.textColor = [UIColor darkGrayColor];
   // cell.detailTextLabel.text = @"details";
    
    [cell addSubview:cityName];
	return cell;
}

- (void)loadCityImage:(NSDictionary *)imageData {
    
    UIImageView* cityLogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:[imageData objectForKey:@"image_url"]]];
    
    [cityLogo setImage:[UIImage imageWithData: data]];
    [(UITableViewCell *)[imageData objectForKey:@"cell"] addSubview:cityLogo];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
}

- (void) tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self handleSelectionOfLocation:indexPath.row];
    
    	
	// make the blue selection bar fade
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)handleSelectionOfLocation:(int)location_index {
    
    // go to the punchScreen
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.currentLocation = [appDelegate.locationList objectAtIndex:location_index];
    
    PerformanceListGetter *performanceListGetter = [[PerformanceListGetter alloc] init];
    [performanceListGetter getPerformanceList:[appDelegate.currentLocation objectForKey:@"performances"]];
    
    progressHolder.hidden = NO;
    [progressShower setProgress:0.0 animated:NO];
    progressLabel.text = @"Finding performances...";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sizeProgress:) name:@"progress_sizer" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgress) name:@"perf_progress_done" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"progress_continuer" object:nil];
  
    
    
}

#pragma mark loading methods

- (void)sizeProgress:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progress_sizer" object:nil];
    
    self.progressSize = [[notification.userInfo objectForKey:@"numberToReach"] floatValue];
    self.progressSize = self.progressSize * 1.03;
    
  //  NSLog(@"size: %.2f", progressSize);
    
}


- (void)updateProgress:(NSNotification *)notification {
    
    float progress_ratio = progressShower.progress + ([[notification.userInfo objectForKey:@"numberToAdd"] floatValue]/self.progressSize);
 
   [progressShower setProgress:progress_ratio animated:YES];
    
 //   NSLog(@"progress: %.2f", progress_ratio);
    
}

- (void)hideProgress {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progress_continuer" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"perf_progress_done" object:nil];
    
    progressHolder.hidden = YES;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:[NSString stringWithFormat:@"MapViewController%@", appDelegate.nibAddOn] bundle:nil];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
    
}

- (void)hideProgressAndReload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progress_continuer" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fest_progress_done" object:nil];
    
    progressHolder.hidden = YES;
    
    [locationTableView reloadData];
    
    NSLog(@"should find the user");
    
    [self findWhereUserIs];
    
}

# pragma mark location methods

- (void)findWhereUserIs {
    
    NSLog(@"finding where user is");
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.shouldAcceptThisLocation = YES;
    
    // Note that the desired accuracy can be changed and there are more precise options
    // it is a trade-off between speed/power vs. precision.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"got another location!");
    
    if (newLocation != nil) {
        if (self.shouldAcceptThisLocation) {
            self.shouldAcceptThisLocation = NO;
       [manager stopUpdatingLocation];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        // find shortest distance
        
        int magic_index = 0;
        int best_dist = 999999999;
        
        for (int i = 0; i < appDelegate.locationList.count; i++) {
        
        CLLocation *festLocation = [[CLLocation alloc] initWithLatitude:[[[appDelegate.locationList objectAtIndex:i] objectForKey:@"lat"] doubleValue] longitude:[[[appDelegate.locationList objectAtIndex:i] objectForKey:@"lng"] doubleValue]];
                 
            NSLog(@"distance is %f",[newLocation distanceFromLocation:festLocation]);
            
            if ([newLocation distanceFromLocation:festLocation] < best_dist) {
                magic_index = i;
                best_dist = [newLocation distanceFromLocation:festLocation];
            }
            
        }
        
        NSLog(@"asking if they are in a certain place");
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Is this your city?"
                              message:[[appDelegate.locationList objectAtIndex:magic_index] objectForKey:@"name"]
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes",nil];
        
        alert.tag = magic_index;
        [alert show];

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"error getting location");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error Finding Your Location"
                          message:@"We can't verify your location. Please make sure you are allowing location services, and try again!"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alertView.title isEqualToString:@"Is this your city?"]) {
        
        switch (buttonIndex) {
			case 0:{
				// do nothing.
                
                break;
			}
			case 1:{
				// they are in that city.
               
                [self handleSelectionOfLocation:alertView.tag];
                
				break;
			}
			default:{
				break;
			}
        }
	}
}



@end
