//
//  ViewController.h
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;

    IBOutlet UITableView *locationTableView;
    IBOutlet UIImageView *progressHolder;
    IBOutlet UIProgressView *progressShower;
    IBOutlet UIActivityIndicatorView *spinner;
    float progressSize;
    IBOutlet UILabel *progressLabel;
    
    BOOL shouldAcceptThisLocation;
    
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property float progressSize;

@property BOOL shouldAcceptThisLocation;

@property (nonatomic, retain) IBOutlet UIImageView *progressHolder;
@property (nonatomic, retain) IBOutlet UIProgressView *progressShower;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) IBOutlet UITableView *locationTableView;

@end
