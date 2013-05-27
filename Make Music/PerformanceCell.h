//
//  PerformanceCell.h
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerformanceCell : UITableViewCell {
    
    UILabel *artistNameLabel;
    UILabel *artistGenreLabel;
	UIButton *artistInfoButton;
    UILabel *startTimeLabel;
    UIButton *artistWebsiteButton;
    UIImageView *artistImageView;
    NSString *artistDesc;
    UIActivityIndicatorView *spinner;
    
}

// properties
@property (nonatomic, retain) NSString *artistDesc;
@property (nonatomic, retain) UILabel *artistNameLabel;
@property (nonatomic, retain) UILabel *artistGenreLabel;
@property (nonatomic, retain) UIButton *artistInfoButton;
@property (nonatomic, retain) UILabel *startTimeLabel;
@property (nonatomic, retain) UIButton *artistWebsiteButton;
@property (nonatomic, retain) UIImageView *artistImageView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
