//
//  PerformanceCell.m
//  Make Music
//
//  Created by Matt Luedke on 4/25/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import "PerformanceCell.h"

@implementation PerformanceCell
@synthesize artistInfoButton, artistGenreLabel, artistImageView, artistNameLabel, artistWebsiteButton, startTimeLabel, artistDesc, spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.artistNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.artistNameLabel];

        self.artistGenreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.artistGenreLabel];

        self.artistInfoButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.artistInfoButton];

        self.artistImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.artistImageView];

        self.artistWebsiteButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.artistWebsiteButton];

        self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.startTimeLabel];

    }
    
    return self;
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX + 80, 20, 180, 20);
		self.artistNameLabel.frame = frame;
        self.artistNameLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size:16.0];
        self.artistNameLabel.textColor = [UIColor darkGrayColor];
        self.artistNameLabel.backgroundColor = [UIColor clearColor];
		
        frame = CGRectMake(boundsX + 80, 36, 180, 20);
		self.startTimeLabel.frame = frame;
        self.startTimeLabel.font = [UIFont fontWithName: @"ArialMT" size:12.0];
        self.startTimeLabel.textColor = [UIColor darkGrayColor];
        self.startTimeLabel.backgroundColor = [UIColor clearColor];
        
		frame = CGRectMake(boundsX + 80, 52, 180, 20);
		self.artistGenreLabel.frame = frame;
        self.artistGenreLabel.font = [UIFont fontWithName: @"ArialMT" size:12.0];
        self.artistGenreLabel.textColor = [UIColor darkGrayColor];
        self.artistGenreLabel.backgroundColor = [UIColor clearColor];

        
        frame = CGRectMake(boundsX + 10, 28, 50, 80);
		self.artistImageView.frame = frame;
        
//        frame = CGRectMake(boundsX + 10, 28, 100, 14);
//		self.spinner.frame = frame;
        
        frame = CGRectMake(boundsX + 260, 28, 44, 44);
		self.artistInfoButton.frame = frame;
        
        self.artistInfoButton.imageView.image = [UIImage imageNamed:@"info.png"];
        [self.artistInfoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
        
        
	}
}

- (void)showInfo {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:self.artistDesc
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
