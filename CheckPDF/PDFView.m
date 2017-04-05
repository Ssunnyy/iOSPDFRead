//
//  PDFView.m
//  CheckPDF
//
//  Created by eeesysmini2 on 2017/3/29.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "PDFView.h"

@implementation PDFView

- (instancetype)initWithFrame:(CGRect)frame DocumentRef:(CGPDFDocumentRef)adocumentRef Page:(int)aPage{
    self = [super initWithFrame:frame];
    pdf = adocumentRef;
    pageNum = aPage;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)drawInContext:(CGContextRef)context{

    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Grab the first PDF page
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageNum);
    // We’re about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
    CGContextSaveGState(context);
    // CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
    // base rotations necessary to display the PDF page correctly.
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    // Finally, we draw the page and restore the graphics state for further manipulations!
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);

}
- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
}
@end
