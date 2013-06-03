//
//  DetailsViewController.h
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailsViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *performanceList;
    
    IBOutlet UITableView *performanceTableView;
    IBOutlet UILabel *venueNameLabel;
    IBOutlet UILabel *venueAddressLabel;
    IBOutlet UIImageView *adImage;
    NSTimer *timer;
    
    IBOutlet UIView *artistDetailView;
    IBOutlet UILabel *artistDetailNameLabel;
    IBOutlet UIImageView *artistImageView;
    IBOutlet UILabel *artistDescLabel;
    IBOutlet UIButton *artistDetailButton;
    
}

@property (nonatomic, retain) NSArray *performanceList;

@property (nonatomic, retain) IBOutlet UIView *artistDetailView;
@property (nonatomic, retain) IBOutlet UILabel *artistDetailNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *artistImageView;
@property (nonatomic, retain) IBOutlet UILabel *artistDescLabel;
@property (nonatomic, retain) IBOutlet UIButton *artistDetailButton;

@property (nonatomic, retain) IBOutlet UITableView *performanceTableView;
@property (nonatomic, retain) IBOutlet UILabel *venueNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *venueAddressLabel;
@property (nonatomic, retain) IBOutlet UIImageView *adImage;
-(IBAction)email:(id)sender;
-(IBAction)phone:(id)sender;
-(IBAction)info:(id)sender;
-(void)getPerformanceList;
-(IBAction)hideArtistDetails:(id)sender;

@end
