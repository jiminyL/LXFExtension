

#import "LXF_StyledPageControl.h"


@implementation LXF_StyledPageControl

#define COLOR_GRAYISHBLUE [UIColor whiteColor]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];       
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
	self=[super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

-(void)setup{
	[self setBackgroundColor:[UIColor clearColor]];
	 self.userInteractionEnabled=NO;
	_strokeWidth = 2;
	_gapWidth = 7;
	_diameter = 6;
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
	[self addGestureRecognizer:tapGestureRecognizer];
}

- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2)
    {
        // move left
        if (self.currentPage>0)
        {
            if (touchPoint.x <= 22)
            {
                self.currentPage = 0;
            }
            else
            {
                self.currentPage -= 1;
            }
        }
        
    }
    else
    {
        // move right
        if (self.currentPage<self.numberOfPages-1)
        {
            if (touchPoint.x >= (CGRectGetWidth(self.bounds) - 22))
            {
                self.currentPage = self.numberOfPages-1;
            }
            else
            {
                self.currentPage += 1;
            }
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
    UIColor *coreNormalColor, *coreSelectedColor, *strokeNormalColor, *strokeSelectedColor;
    
    if (self.coreNormalColor) coreNormalColor = self.coreNormalColor;
    else coreNormalColor = COLOR_GRAYISHBLUE;
    
    if (self.coreSelectedColor) coreSelectedColor = self.coreSelectedColor;
    else
    {
 
            coreSelectedColor = COLOR_GRAY;
    }
    
    if (self.strokeNormalColor) strokeNormalColor = self.strokeNormalColor;
    else 
    {
        if (self.coreNormalColor)
        {
            strokeNormalColor = self.coreNormalColor;
        }

        
    }
    
    if (self.strokeSelectedColor) strokeSelectedColor = self.strokeSelectedColor;
    else
    {
   
    strokeSelectedColor = self.coreSelectedColor;
   
    }
    
    // Drawing code
    if (self.hidesForSinglePage && self.numberOfPages==1)
	{
		return;
	}
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	int gap = self.gapWidth;
    float diameter = self.diameter - 2*self.strokeWidth;
	
	int total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
	
	if (total_width>self.frame.size.width)
	{
		while (total_width>self.frame.size.width)
		{
			diameter -= 2;
			gap = diameter + 2;
			while (total_width>self.frame.size.width) 
			{
				gap -= 1;
				total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
				
				if (gap==2)
				{
					break;
					total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
				}
			}
			
			if (diameter==2)
			{
				break;
				total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
			}
		}
		
		
	}
	
	int i;
	for (i=0; i<self.numberOfPages; i++)
	{
		int x = (self.frame.size.width-total_width)/2 + i*(diameter+gap);
        
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        
	}
}

- (void)setCurrentPage:(int)page
{
    _currentPage = page;
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(int)numOfPages
{
    _numberOfPages = numOfPages;
    [self setNeedsDisplay];
}

@end
