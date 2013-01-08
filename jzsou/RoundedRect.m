//
//  roundedRect.m
//  iphone.hupoz
//
//  Created by tiantian on 7/8/10.
//  Copyright 2011 hupoz.com. All rights reserved.
//

#import "RoundedRect.h"


@implementation RoundedRect


- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius andText:(NSString *)text
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
	if(self != nil)
	{
		//self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
        self.backgroundColor = [UIColor clearColor];
        radius_ = radius;
        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.center = self.center;
        [self addSubview: textLabel];

	}

	return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0);
	// And draw with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.7);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 3.0);
	
	// If you were making this as a routine, you would probably accept a rectangle
	// that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
	CGRect rrect = CGRectMake(3, 3, self.frame.size.width - 3*2, self.frame.size.height - 3*2);
	// NOTE: At this point you may want to verify that your radius is no more than half
	// the width and height of your rectangle, as this technique degenerates for those cases.
	
	// In order to draw a rounded rectangle, we will take advantage of the fact that
	// CGContextAddArcToPoint will draw straight lines past the start and end of the arc
	// in order to create the path from the current position and the destination position.
	
	// In order to create the 4 arcs correctly, we need to know the min, mid and max positions
	// on the x and y lengths of the given rectangle.
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    2       3       4
	// midy   1 9              5
	// maxy    8       7       6
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius_);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius_);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius_);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius_);
	// Close the path
	CGContextClosePath(context);
	// Fill & stroke the path
	CGContextDrawPath(context, kCGPathFillStroke);

}


- (void)dealloc {
    [super dealloc];
}


@end
