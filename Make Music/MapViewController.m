//
//  MapViewController.m
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "LocationAnnotation.h"
#import "DetailsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize venueMapView, spinner, allOrCurrent, relevantVenues, genrePicker, genreFilterButton, chosenGenre, genreList, genrePickerDismisser, genreFilteredVenues, artistNameSearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // install filters button
	genreFilterButton = [[UIBarButtonItem alloc] initWithTitle:@"Genre" style:UIBarButtonItemStylePlain target:self action:@selector(genreFilter)];
	self.navigationItem.rightBarButtonItem = genreFilterButton;
    
    chosenGenre = @"All";
    
    [self putTogetherGenreList];
    
    NSLog(@"loading maps");
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    spinner.hidden = NO;
    [spinner startAnimating];
    
    allOrCurrent.tintColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
    
    artistNameSearchBar.placeholder = @"Search by Artist Name";
    artistNameSearchBar.tintColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
    artistNameSearchBar.delegate = self;
    for (UIView *view in artistNameSearchBar.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }
    
    [self centerMap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    UIImage *image = [UIImage imageNamed:@"BlankHeader.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    UILabel *mapTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    mapTitle.font = [UIFont fontWithName:@"Font-Family:kalingab" size:20];
    mapTitle.textColor = [UIColor whiteColor];
    mapTitle.backgroundColor = [UIColor clearColor];
    mapTitle.textAlignment = UITextAlignmentCenter;
    mapTitle.text = [appDelegate.currentLocation objectForKey:@"name"];
    self.navigationItem.titleView = mapTitle;
  //  [self performSelectorInBackground:@selector(makeAnnotations) withObject:nil];
    
    genreFilteredVenues = appDelegate.venueList;
    relevantVenues = genreFilteredVenues;
    
    for(UIView *v in artistNameSearchBar.subviews){
        
        if([v isKindOfClass:NSClassFromString( @"UISearchBarBackground" )]){
            [v setAlpha:0.0F];
        }
    }
    artistNameSearchBar.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
//    UIView *searchBackground = [[UIView alloc] initWithFrame:artistNameSearchBar.bounds];
//    searchBackground.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];
//    [self.view addSubview:searchBackground];

    
    allOrCurrent.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:204.0/255.0 blue:57.0/255.0 alpha:1];

    [self makeAnnotations];
   
}

- (void) putTogetherGenreList {
    
    genreList = [NSArray arrayWithObjects:@"All", @"Hip-Hop", @"Rock", @"World", nil];
    
}

- (void) genreFilter {
    
    // filter by genre.
    
    // display the selection wheel
    NSLog(@"filter by genre");
    
    genrePickerDismisser.hidden = NO;
    genrePicker.hidden = NO;
        
}

-(IBAction)dismissPicker:(id)sender {
    
    genrePicker.hidden = YES;
    genrePickerDismisser.hidden = YES;
    
    [self filterByGenre];
    
    [self checkAllOrCurrent];
       
    [venueMapView removeAnnotations:venueMapView.annotations];
    [self makeAnnotations];
    
}

-(void)filterByGenre {
    
    // filter out the relevant venues based on the chosen genre
    NSMutableArray *makingTheGenreFilteredVenueList = [NSMutableArray array];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    genreFilteredVenues = appDelegate.venueList;
    
    for (int i = 0; i < appDelegate.performanceList.count; i++) {
        
        NSString *artist_id = [[appDelegate.performanceList objectAtIndex:i] objectForKey:@"artist_id"];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", artist_id];
        
        NSDictionary *artistData = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
        
        NSArray *thisArtistsGenres = [[artistData objectForKey:@"genres"] componentsSeparatedByString:@","];
        
        if ([thisArtistsGenres containsObject:chosenGenre] || [chosenGenre isEqualToString:@"All"]) {
            
            // this performance is in genre!
            
            // now get the venue id
            NSString *venue_id = [[appDelegate.performanceList objectAtIndex:i] objectForKey:@"venue_id"];
            
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"id = %@", venue_id];
            
            if ([[appDelegate.venueList filteredArrayUsingPredicate:pred1] lastObject] != nil) {
                
                [makingTheGenreFilteredVenueList addObject:[[appDelegate.venueList filteredArrayUsingPredicate:pred1] lastObject]];
            } else {
                
                NSLog(@"this venue is not real: %@", venue_id);
                
            }
            

        }
        
    }
    
    // intersect the relevant with the correct genre
    NSMutableSet * set = [NSMutableSet setWithArray:genreFilteredVenues];
    [set intersectSet:[NSSet setWithArray:makingTheGenreFilteredVenueList]];
    genreFilteredVenues = [set allObjects];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeMode:(UISegmentedControl *)sender {
 
    [self filterByGenre];

    [self checkAllOrCurrent];
}

-(void)checkAllOrCurrent {
    
    if (allOrCurrent.selectedSegmentIndex == 0) {
        // all mode
        
        // remove all current annotations
        
        // construct list of annotations that should be shown
    //    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //    [relevantVenues removeAllObjects];
    //    [relevantVenues addObjectsFromArray:appDelegate.venueList];
        relevantVenues = genreFilteredVenues;
        
        // show those
        [self makeAnnotations];
        
        
    } else {
        // only current mode
        
        NSMutableArray *makingTheRelevantVenues = [NSMutableArray array];
        
        // remove all current annotations
        
        // construct list of annotations that should be shown
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        // find time
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit) fromDate:[NSDate date]];
        NSInteger hour = [components hour];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        for (int i = 0; i < appDelegate.performanceList.count; i++) {
            
            NSDate *startDateFromString = [[NSDate alloc] init];
            startDateFromString = [dateFormatter dateFromString:[[appDelegate.performanceList objectAtIndex:i] objectForKey:@"start_time"]];
            
            NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit) fromDate:startDateFromString];
            NSInteger startHour = [components1 hour];
            
            NSDate *endDateFromString = [[NSDate alloc] init];
            endDateFromString = [dateFormatter dateFromString:[[appDelegate.performanceList objectAtIndex:i] objectForKey:@"start_time"]];
            
            NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit) fromDate:endDateFromString];
            NSInteger endHour = [components2 hour];
            
            if (hour >= startHour && hour <= endHour) {
            
                // this performance is considered current!
                
                // now get the venue id
                NSString *venue_id = [[appDelegate.performanceList objectAtIndex:i] objectForKey:@"venue_id"];
                
                
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"id = %@", venue_id];
                
                if ([[genreFilteredVenues filteredArrayUsingPredicate:pred1] lastObject] != nil) {
                    
                    
                    [makingTheRelevantVenues addObject:[[genreFilteredVenues filteredArrayUsingPredicate:pred1] lastObject]];
                } else {
                    
                    NSLog(@"this venue is not real: %@", venue_id);
                }
                

            }
            
        }
        
        // show those
        relevantVenues = makingTheRelevantVenues;
        [self makeAnnotations];
        
    }
    
}

#pragma mark mkmapviewdelegate things

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
   
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    
    annView.rightCalloutAccessoryView = rightButton;
        
    return annView;
     
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{
    
    // here we illustrate how to detect which annotation type was clicked on for its callout
    
    LocationAnnotation *annotation = [view annotation];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
//    appDelegate.currentVenue = annotation.performanceData;
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"id = %@", annotation.venue_id];
    appDelegate.currentVenue = [[appDelegate.venueList filteredArrayUsingPredicate:pred1] lastObject];
    
    NSLog(@"venue id chosen: %@", annotation.venue_id);
    
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNibName:[NSString stringWithFormat:@"DetailsViewController%@", appDelegate.nibAddOn] bundle:nil];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
  //  [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}


- (void)centerMap
{
    // let's see what's going on here.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"centering map");
    
    CLLocationCoordinate2D coord = {.latitude =  [[appDelegate.currentLocation objectForKey:@"lat"] floatValue], .longitude =  [[appDelegate.currentLocation objectForKey:@"lng"] floatValue]};
    MKCoordinateSpan span = {.latitudeDelta =  0.5, .longitudeDelta =  0.5};
    MKCoordinateRegion region = {coord, span};
    
    [venueMapView setRegion:region];
    
}

- (void)makeAnnotations
{
  //  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
 NSLog(@"trying to be making annotations: %i", relevantVenues.count);
    [venueMapView removeAnnotations:venueMapView.annotations];
    [self resignFirstResponder];
    for (int i = 0; i < relevantVenues.count; i++) {
        
       
    
    CLLocationCoordinate2D location1;
        
        if ([[relevantVenues objectAtIndex:i] objectForKey:@"lat"] == NULL || [[[relevantVenues objectAtIndex:i] objectForKey:@"lat"] isKindOfClass:[NSNull class]]) {
            continue;
        }
        
    location1.latitude = [[[relevantVenues objectAtIndex:i] objectForKey:@"lat"] doubleValue];
    location1.longitude = [[[relevantVenues objectAtIndex:i] objectForKey:@"lng"] doubleValue];
     
    LocationAnnotation *latestAnnotation = [[LocationAnnotation alloc] initWithCoordinate:location1];
        
    latestAnnotation.name = [[relevantVenues objectAtIndex:i] objectForKey:@"name"];
        
    latestAnnotation.address = [[relevantVenues objectAtIndex:i] objectForKey:@"address"];
        
    latestAnnotation.venue_id = [[relevantVenues objectAtIndex:i] objectForKey:@"id"];
        
 //   latestAnnotation.performanceData = [appDelegate.performanceList objectAtIndex:i];
        
    [venueMapView addAnnotation:latestAnnotation];
    
    }
    
    [spinner stopAnimating];
    spinner.hidden = YES;

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    // if you want to track which pins are being clicked, you would do that here
    NSLog(@"view selected: %@", view.annotation.title);
    
}



-(IBAction)searchByName:(id)sender{
    if(artistNameSearchBar.text.length == 0){
        //do something saying you need more to search
    }
    else{
        NSMutableArray *searchFilteredVenues = [[NSMutableArray alloc] initWithCapacity:10];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < appDelegate.performanceList.count; i++) {
            
            NSString *artist_id = [[appDelegate.performanceList objectAtIndex:i] objectForKey:@"artist_id"];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", artist_id];
            
            NSDictionary *artistData = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
            
            NSString *thisArtistName = [artistData objectForKey:@"groupname"];
            
            if([thisArtistName rangeOfString:artistNameSearchBar.text options:NSCaseInsensitiveSearch].location == NSNotFound) {
                //the artist in this performance doesn't match
            }
            else {
                NSString *venue_id = [[appDelegate.performanceList objectAtIndex:i] objectForKey:@"venue_id"];
                
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"id = %@", venue_id];
                
                if ([[appDelegate.venueList filteredArrayUsingPredicate:pred1] lastObject] != nil) {
                    
                    [searchFilteredVenues addObject:[[appDelegate.venueList filteredArrayUsingPredicate:pred1] lastObject]];
                }
                else {
                    
                    NSLog(@"this venue is not real: %@", venue_id);
                }
            }
            
        }
        
        NSMutableSet * set = [NSMutableSet setWithArray:searchFilteredVenues];
        relevantVenues = [set allObjects];
//        [set intersectSet:[NSSet setWithArray:searchFilteredVenues]];
//        genreFilteredVenues = [set allObjects];
        [self makeAnnotations];
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarShouldEndEditing:searchBar];
    
    [self searchByName:self];
    [searchBar resignFirstResponder];
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:artistNameSearchBar];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self filterByGenre];
    [self checkAllOrCurrent];
    [searchBar resignFirstResponder];
    [self searchBarShouldEndEditing:searchBar];
}

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    NSString *text = localSearchBar.text;
//    NSMutableString *strippedString = [NSMutableString
//                                       stringWithCapacity:text.length];
//    NSScanner *scanner = [NSScanner scannerWithString:text];
//    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
//    while ([scanner isAtEnd] == NO) {
//        NSString *buffer;
//        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
//            [strippedString appendString:buffer];
//            
//        } else {
//            [scanner setScanLocation:([scanner scanLocation] + 1)];
//        }
//    }
//    localSearchBar.text = strippedString;
    return YES;
}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //[[CurrentUser sharedCurrentUser].search_results removeAllObjects];
    //[self refresh];
    
    return YES;
}

#pragma mark UIPicker

// the following functions are to implement the UIPickerDelegate methods.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
	
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return genreList.count;

}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
    return [genreList objectAtIndex:row];

}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    chosenGenre = [genreList objectAtIndex:row];
	
}

-(void)dismissKeyboard {
    [artistNameSearchBar resignFirstResponder];
}

@end
