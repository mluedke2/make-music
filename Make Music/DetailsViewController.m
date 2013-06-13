//
//  DetailsViewController.m
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "PerformanceCell.h"
#import "GAI.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize venueNameLabel, venueAddressLabel, performanceTableView, performanceList, adImage, artistDescLabel, artistImageView, artistDetailNameLabel, artistDetailButton, artistDetailView, shadow, filterView, genreFilteredPerformances, relevantPerformance;

-(IBAction)hideArtistDetails:(id)sender {

    [UIView beginAnimations:@"fadeOutDetails" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    shadow.alpha = 0.0;
    artistDetailView.alpha = 0.0;
    artistDetailButton.alpha = 0.0;
    
    [UIView commitAnimations];
    
}

- (void)animationDidStop:(NSString *)animID finished:(BOOL)didFinish context:(void *)context
{
    if ( [animID isEqualToString:@"fadeOutDetails"] ) {
        artistDetailView.hidden = YES;
        artistDetailButton.hidden = YES;
        shadow.hidden = YES;
        
    }
}

- (void) showDetails {
    
    shadow.hidden = NO;
    artistDetailView.hidden = NO;
    artistDetailButton.hidden = NO;
    artistDetailView.alpha = 0.0;
    artistDetailButton.alpha = 0.0;
    shadow.alpha = 0.0;
    
    [UIView beginAnimations:@"fadeInDetails" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    artistDetailView.alpha = 1.0;
    artistDetailButton.alpha = 1.0;
    shadow.alpha = 1.0;
    
    [UIView commitAnimations];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // track!
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"ui_screen"
                        withAction:@"artist"
                         withLabel:@"ios"
                         withValue:[appDelegate.currentLocation objectForKey:@"id"]];
    
}

-(IBAction)email:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSArray *sendto = [NSArray arrayWithObject:[appDelegate.currentVenue objectForKey:@"email"]];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:sendto];
        [mailViewController setSubject:@"Message Using The App"];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
        
    }
    
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error: (NSError*)error {
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
            
		case MFMailComposeResultFailed:
			break;
			
		case MFMailComposeResultSent:{
			
           // track here if you want
            
		}		break;
	}
}

-(IBAction)phone:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Call?"
                          message:[appDelegate.currentVenue objectForKey:@"phone"]
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    
    [alert show];
    
}

-(IBAction)info:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:[appDelegate.currentVenue objectForKey:@"description"]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alertView.title isEqualToString:@"Call?"]) {
        
        switch (buttonIndex) {
			case 0:{
				// do nothing.
                
                break;
			}
			case 1:{
				// call.
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[[appDelegate.currentVenue objectForKey:@"phone"] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
				break;
			}
			default:{
				break;
			}
        }
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) removeFilter:(UIButton *)filterButton {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (filterButton.tag == 1) {
       appDelegate.genreFilter = @"All";
    }
    else if (filterButton.tag == 2) {
        appDelegate.searchFilter = @"";
    }
    
    [self renderAgainForFilters];
}

- (void) renderAgainForFilters {
    
    // determine if there's filtering going on
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // remove subviews
    [self.filterView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSLog(@"appDelegate.genreFilter: %@", appDelegate.genreFilter);
    NSLog(@"appDelegate.searchFilte: %@", appDelegate.searchFilter);
    
    if (![appDelegate.genreFilter isEqualToString:@"All"] || ![appDelegate.searchFilter isEqualToString:@""]) {
        
        NSLog(@"filtering");
        self.filterView.hidden = NO;
        
        // if so, create a label and button(s)
        UILabel *filteredByLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, 80.0, 20.0)];
        filteredByLabel.font = [UIFont fontWithName: @"ArialMT" size:14.0];
        filteredByLabel.text = @"Filtered By:";
        [self.view addSubview:filteredByLabel];
        [self.view sendSubviewToBack:filteredByLabel];
        
        UIButton *filterButton1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 44)];
        [filterButton1 setBackgroundImage:[UIImage imageNamed:@"filter_button"] forState:UIControlStateNormal];
        filterButton1.tag = 1;
        [filterButton1.titleLabel setFont:[UIFont fontWithName: @"ArialMT" size:14.0]];
        [filterButton1 addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
        
        if (![appDelegate.genreFilter isEqualToString:@"All"]) {
            
            [filterButton1 setTitle:appDelegate.genreFilter forState:UIControlStateNormal];
            
            if (![appDelegate.searchFilter isEqualToString:@""]) {
                
                UIButton *filterButton2 = [[UIButton alloc] initWithFrame:CGRectMake(210, 0, 100, 44)];
                [filterButton2 setBackgroundImage:[UIImage imageNamed:@"filter_button"] forState:UIControlStateNormal];
                filterButton2.tag = 2;
                [filterButton2.titleLabel setFont:[UIFont fontWithName: @"ArialMT" size:14.0]];
                [filterButton2 addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
                [filterButton2 setTitle:appDelegate.searchFilter forState:UIControlStateNormal];
                [self.view addSubview:filterButton2];
                [self.view sendSubviewToBack:filterButton2];
                
            }
            
        } else {
            
            filterButton1.tag = 2;
            [filterButton1 setTitle:appDelegate.searchFilter forState:UIControlStateNormal];
            
        }
        
        [self.view addSubview:filterButton1];
        [self.view sendSubviewToBack:filterButton1];
        
        // also, filter the table contents!
    } else {
        
       
        self.filterView.hidden = YES;
        
        // shift everything up by 44 points
        [self.venueNameLabel setFrame: CGRectMake(venueNameLabel.frame.origin.x, (venueNameLabel.frame.origin.y - 44), venueNameLabel.frame.size.width, venueNameLabel.frame.size.height)];
        [self.venueAddressLabel setFrame:CGRectMake(venueAddressLabel.frame.origin.x, (venueAddressLabel.frame.origin.y - 44), venueAddressLabel.frame.size.width, venueAddressLabel.frame.size.height)];
        [self.performanceTableView setFrame:CGRectMake(performanceTableView.frame.origin.x, (performanceTableView.frame.origin.y - 44), performanceTableView.frame.size.width, (performanceTableView.frame.size.height + 44))];
        
        
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // determine if there's filtering going on
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"appDelegate.genreFilter: %@", appDelegate.genreFilter);
    NSLog(@"appDelegate.searchFilte: %@", appDelegate.searchFilter);
    
    /*
    // remove subviews
    [self.filterView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if (![appDelegate.genreFilter isEqualToString:@"All"] || ![appDelegate.searchFilter isEqualToString:@""]) {
        
        NSLog(@"filtering");
        self.filterView.hidden = NO;
        filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.view addSubview:filterView];
        [self.view sendSubviewToBack:filterView];
        
        // if so, create a label and button(s)
        UILabel *filteredByLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, 80.0, 20.0)];
        filteredByLabel.font = [UIFont fontWithName: @"ArialMT" size:14.0];
        filteredByLabel.text = @"Filtered By:";
        [self.filterView addSubview:filteredByLabel];
        
        UIButton *filterButton1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 44)];
        [filterButton1 setBackgroundImage:[UIImage imageNamed:@"filter_button"] forState:UIControlStateNormal];
        filterButton1.tag = 1;
        [filterButton1.titleLabel setFont:[UIFont fontWithName: @"ArialMT" size:14.0]];
        [filterButton1 addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
        
        if (![appDelegate.genreFilter isEqualToString:@"All"]) {
            
            [filterButton1 setTitle:appDelegate.genreFilter forState:UIControlStateNormal];
            
            if (![appDelegate.searchFilter isEqualToString:@""]) {
                
                UIButton *filterButton2 = [[UIButton alloc] initWithFrame:CGRectMake(210, 0, 100, 44)];
                [filterButton2 setBackgroundImage:[UIImage imageNamed:@"filter_button"] forState:UIControlStateNormal];
                filterButton2.tag = 2;
                [filterButton2.titleLabel setFont:[UIFont fontWithName: @"ArialMT" size:14.0]];
                [filterButton2 addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
                [filterButton2 setTitle:appDelegate.searchFilter forState:UIControlStateNormal];
                [self.filterView addSubview:filterButton2];
                
            }
            
        } else {
            
            filterButton1.tag = 2;
            [filterButton1 setTitle:appDelegate.searchFilter forState:UIControlStateNormal];
            
        }
        
        [self.filterView addSubview:filterButton1];
        
        // shift everything down by 44 points
        [self.venueNameLabel setFrame: CGRectMake(venueNameLabel.frame.origin.x, (venueNameLabel.frame.origin.y + 44), venueNameLabel.frame.size.width, venueNameLabel.frame.size.height)];
        [self.venueAddressLabel setFrame:CGRectMake(venueAddressLabel.frame.origin.x, (venueAddressLabel.frame.origin.y + 44), venueAddressLabel.frame.size.width, venueAddressLabel.frame.size.height)];
        [self.performanceTableView setFrame:CGRectMake(performanceTableView.frame.origin.x, (performanceTableView.frame.origin.y + 44), performanceTableView.frame.size.width, (performanceTableView.frame.size.height - 44))];
        
        // also, filter the table contents!
    }
     
     */
    
    // custom back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0f, 0.0f, 92.0f, 42.0f)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton sizeToFit];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    artistDetailButton.hidden = YES;
    artistDetailView.hidden = YES;
    shadow.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.performanceTableView.separatorColor = [UIColor darkGrayColor];
    [self getPerformanceList];
    
    [self performSelectorInBackground:@selector(loadAdImage) withObject:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
    
    // initialize the timer
	timer = [NSTimer scheduledTimerWithTimeInterval:(30.0) target:self selector:@selector(loadAdImage) userInfo:nil repeats:YES];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // track!
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"ui_screen"
                        withAction:@"venue"
                         withLabel:@"ios"
                         withValue:[appDelegate.currentLocation objectForKey:@"id"]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    
	[super viewWillDisappear:animated];
}

- (void)loadAdImage {
    
    // get array of ad images
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"current location data: %@", appDelegate.currentLocation);
    
    int r = arc4random() % [[appDelegate.currentLocation objectForKey:@"sponsors"] count];
    
    NSLog(@"is going to get image: %@", [[appDelegate.currentLocation objectForKey:@"sponsors"] objectAtIndex:r]);
    
    [adImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[appDelegate.currentLocation objectForKey:@"sponsors"] objectAtIndex:r]]]]];
    
}

-(void)getPerformanceList {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // put together the performance list!
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"venue_id = %@", [appDelegate.currentVenue objectForKey:@"id"]];
    performanceList = [appDelegate.performanceList filteredArrayUsingPredicate:pred];

    // sort the performance list by time!
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES];
    performanceList = [performanceList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
    
    venueNameLabel.text = [appDelegate.currentVenue objectForKey:@"name"];
    
    venueAddressLabel.text = [appDelegate.currentVenue objectForKey:@"address"];
    
  //  [self filterCells];
    
  //  [self searchCells];
    
    [performanceTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark filter cells

- (void)filterCells {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *makingTheFilteredPerformances = [NSMutableArray array];
    
    for (int i = 0; i < performanceList.count; i++) {
        
        NSString *artist_id = [[performanceList objectAtIndex:i] objectForKey:@"artist_id"];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", artist_id];
        
        // get the artist data
        
        NSDictionary *artistData = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
        
        NSArray *thisArtistsGenres = [[artistData objectForKey:@"genres"] componentsSeparatedByString:@","];
        
        if ([thisArtistsGenres containsObject:appDelegate.genreFilter] || [appDelegate.genreFilter isEqualToString:@"All"]) {
            
            NSLog(@"in genre! %@", appDelegate.genreFilter);
            
            // this performance is in genre!
            [makingTheFilteredPerformances addObject:[performanceList objectAtIndex:i]];
            
        }
        
    }
    
    genreFilteredPerformances = makingTheFilteredPerformances;
    relevantPerformance = genreFilteredPerformances;
    
    [performanceTableView reloadData];
}

-(void)searchCells {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if(appDelegate.searchFilter.length == 0){
        //do something saying you need more to search
    }
    else{
        NSMutableArray *searchFilteredVenues = [NSMutableArray array];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < relevantPerformance.count; i++) {
            
            NSString *artist_id = [[relevantPerformance objectAtIndex:i] objectForKey:@"artist_id"];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", artist_id];
            
            NSDictionary *artistData = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
            
            NSString *thisArtistName = [artistData objectForKey:@"groupname"];
            
            if([thisArtistName rangeOfString:appDelegate.searchFilter options:NSCaseInsensitiveSearch].location == NSNotFound) {
                //the artist in this performance doesn't match
            }
            else {
            
                // match found!
                [searchFilteredVenues addObject:[relevantPerformance objectAtIndex:i]];
            
            }
            
        }
        
        NSMutableSet * set = [NSMutableSet setWithArray:searchFilteredVenues];
        relevantPerformance = [set allObjects];
        //        [set intersectSet:[NSSet setWithArray:searchFilteredVenues]];
        //        genreFilteredVenues = [set allObjects];
        [performanceTableView reloadData];
        
         }

    
    
}

# pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return performanceList.count;
 //   return relevantPerformance.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
        
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"onePerformanceCell"];
    
    cell.frame = CGRectZero;
    
    cell.selectedBackgroundView = [[UIImageView alloc] init];
    //  ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"gray_all_day.png"];
 //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // get the artist data
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [[performanceList objectAtIndex:indexPath.row] objectForKey:@"artist_id"]];
 //   NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [[relevantPerformance objectAtIndex:indexPath.row] objectForKey:@"artist_id"]];
    NSDictionary *currentArtist = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
        
    UILabel *artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 180, 40)];
    artistNameLabel.text = [currentArtist objectForKey:@"groupname"];
    artistNameLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size:16.0];
    artistNameLabel.textColor = [UIColor darkGrayColor];
    artistNameLabel.backgroundColor = [UIColor clearColor];
    artistNameLabel.adjustsFontSizeToFitWidth = YES;
    artistNameLabel.minimumScaleFactor = 50.0;
    artistNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    artistNameLabel.numberOfLines = 2;
    [cell addSubview:artistNameLabel];
    
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 180, 20)];
    startTimeLabel.font = [UIFont fontWithName: @"ArialMT" size:14.0];
    startTimeLabel.textColor = [UIColor darkGrayColor];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview:startTimeLabel];
    
    UILabel *artistGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 66, 180, 20)];
    artistGenreLabel.text = [currentArtist objectForKey:@"genres"];
    artistGenreLabel.font = [UIFont fontWithName: @"ArialMT" size:14.0];
    artistGenreLabel.textColor = [UIColor darkGrayColor];
    artistGenreLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview:artistGenreLabel];
    
    UIImageView *artistThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 90, 60)];
    artistThumbView.contentMode = UIViewContentModeScaleAspectFit;
    [artistThumbView setImage:[UIImage imageNamed:@"artistDefault"]];
    
    [cell addSubview:artistThumbView];
    
    if([currentArtist objectForKey:@"image_url"] != [NSNull null]){
   //     UIImageView *artistThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 90, 60)];
        //Lazy Load
        
        NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:[currentArtist objectForKey:@"image_url"], @"image_url", cell, @"cell", artistThumbView, @"artistImageView", nil];
        
        [self performSelectorInBackground:@selector(loadArtistImage:) withObject:imageData];
        
    }
    

//    if( [currentArtist objectForKey:@"140_description" ] != [NSNull null]){
//        UIButton *artistInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        artistInfoButton.frame = CGRectMake(280, 35, 30, 30);
//        artistInfoButton.tag = [[[performanceList objectAtIndex:indexPath.row] objectForKey:@"artist_id"] integerValue];
//        //[artistInfoButton setTitle:@"More Info" forState:UIControlStateNormal];
//        [artistInfoButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
//        [artistInfoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:artistInfoButton];
//    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"h:mm a, MMM dd, yyyy"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:[[performanceList objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
    
    startTimeLabel.text = [dateFormatter1 stringFromDate:dateFromString];
   
  //  cell.spinner.hidden = NO;
  //  [cell.spinner startAnimating];
    //[self performSelectorInBackground:@selector(loadImage:) withObject:[[performanceList objectAtIndex:indexPath.row] objectForKey:@"artist_image_url"]];
    
    // cell.detailTextLabel.text = @"details";
    
	return cell;
}

- (void)loadArtistImage:(NSDictionary *)imageData {
    
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:[imageData objectForKey:@"image_url"]]];
    UIImageView *imageView = (UIImageView *)[imageData objectForKey:@"artistImageView"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:[UIImage imageWithData: data]];
  //  [(UITableViewCell *)[imageData objectForKey:@"cell"] addSubview:imageView];
    
}

- (void)getArtistDetailImage:(NSDictionary *)imageData {
    
    UIImageView *imageView = (UIImageView *)[imageData objectForKey:@"imageView"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if([imageData objectForKey:@"image_url"] != [NSNull null]){
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageData objectForKey:@"image_url"]]];
    [imageView setImage:[UIImage imageWithData:data]];
    }  else{
        
    [imageView setImage:[UIImage imageNamed:@"artistDefault"]];
    }
    
}

- (IBAction)showInfo:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [NSString stringWithFormat:@"%i", ((UIButton*)sender).tag]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [[performanceList objectAtIndex:((UIButton*)sender).tag] objectForKey:@"artist_id"]];
    NSDictionary *currentArtist = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
    
    if([currentArtist objectForKey:@"140_description"] != [NSNull null]){
    
        artistDetailNameLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size:16.0];
        artistDetailNameLabel.textColor = [UIColor whiteColor];
        artistDescLabel.font = [UIFont fontWithName: @"ArialMT" size:14.0];
        artistDescLabel.textColor = [UIColor whiteColor];
        
        artistImageView.image = [UIImage imageNamed:@"artistDefault"];
        artistDescLabel.text = [currentArtist objectForKey:@"140_description"];
        NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:artistImageView, @"imageView", [currentArtist objectForKey:@"image_url"], @"image_url",nil];
        [self performSelectorInBackground:@selector(getArtistDetailImage:) withObject:imageData];
        artistDetailNameLabel.text = [currentArtist objectForKey:@"groupname"];
        [self showDetails];
        
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"More Artist Info"
                              message:[currentArtist objectForKey:@"140_description"]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
         */
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"More Artist Info"
                              message:@"No additional info available."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
}

- (void) tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	// make the blue selection bar fade
    UIButton *dummyButton = [[UIButton alloc] init];
    dummyButton.tag = indexPath.row;
    [self showInfo:dummyButton];
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
