//
//  MapViewController.h
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, UITextFieldDelegate>{
    
    IBOutlet MKMapView *venueMapView;
    IBOutlet UIImageView *spinnerHolder;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UISegmentedControl *allOrCurrent;
    
    NSArray *genreFilteredVenues;
    NSArray *relevantVenues;
    
    IBOutlet UIPickerView *genrePicker;
    IBOutlet UIToolbar *genrePickerDismisser;
    UIBarButtonItem *genreFilterButton;
    
    IBOutlet UISearchBar *artistNameSearchBar;
    NSString *chosenGenre;
    NSArray *genreList;
    
}

@property (nonatomic, retain) IBOutlet MKMapView *venueMapView;
@property (nonatomic, retain) IBOutlet UIImageView *spinnerHolder;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UISegmentedControl *allOrCurrent;

@property (nonatomic, retain) IBOutlet UIPickerView *genrePicker;
@property (nonatomic, retain) IBOutlet UIToolbar *genrePickerDismisser;
@property (nonatomic, retain) UIBarButtonItem *genreFilterButton;
@property (nonatomic, retain) NSString *chosenGenre;
@property (nonatomic, retain) NSArray *genreList;

@property (nonatomic, retain) IBOutlet UISearchBar *artistNameSearchBar;

@property (nonatomic, retain) NSArray *genreFilteredVenues;
@property (nonatomic, retain) NSArray *relevantVenues;

-(IBAction)changeMode:(UISegmentedControl *)sender;
-(IBAction)dismissPicker:(id)sender;

@end
