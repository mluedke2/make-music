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

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize venueNameLabel, venueAddressLabel, performanceTableView, performanceList, venueImage;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.performanceTableView.separatorColor = [UIColor darkGrayColor];
    [self getPerformanceList];
    
}

-(void)getPerformanceList {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"getPerformanceList");
    
    // put together the performance list!
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"venue_id = %@", [appDelegate.currentVenue objectForKey:@"id"]];
    performanceList = [appDelegate.performanceList filteredArrayUsingPredicate:pred];

    // sort the performance list by time!
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES];
    performanceList = [performanceList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
    
    venueNameLabel.text = [appDelegate.currentVenue objectForKey:@"name"];
    
    venueAddressLabel.text = [appDelegate.currentVenue objectForKey:@"address"];
    //venueImage = [self loadImage:]];
    
    [performanceTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadImage:(NSIndexPath*)indexPath:(NSString *)url {
    
    //NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:url]];
    //UIImage *image = [UIImage imageWithData: data];
    
}

# pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return performanceList.count;
    
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
    NSDictionary *currentArtist = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
        
    UILabel *artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 180, 40)];
    artistNameLabel.text = [currentArtist objectForKey:@"groupname"];
    artistNameLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size:16.0];
    artistNameLabel.textColor = [UIColor darkGrayColor];
    artistNameLabel.backgroundColor = [UIColor clearColor];
    artistNameLabel.adjustsFontSizeToFitWidth = YES;
    artistNameLabel.minimumFontSize = 8.0;
    artistNameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    //artistNameLabel.numberOfLines = 2;
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
    
    if([currentArtist objectForKey:@"image_url"] != [NSNull null]){
        UIImageView *artistImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 90, 60)];
        //Lazy Load
        
        NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:[currentArtist objectForKey:@"image_url"]]];
        artistImageView.image = [UIImage imageWithData: data];
        [cell addSubview:artistImageView];
    }
    else{
        UIImageView *artistImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"artistDefault"]];
        [cell addSubview:artistImageView];
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

- (IBAction)showInfo:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [NSString stringWithFormat:@"%i", ((UIButton*)sender).tag]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [[performanceList objectAtIndex:((UIButton*)sender).tag] objectForKey:@"artist_id"]];
    NSDictionary *currentArtist = [[appDelegate.artistList filteredArrayUsingPredicate:pred] lastObject];
    
    if([currentArtist objectForKey:@"140_description"] != [NSNull null]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"More Artist Info"
                              message:[currentArtist objectForKey:@"140_description"]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
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
