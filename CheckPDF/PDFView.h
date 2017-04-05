//
//  PDFView.h
//  CheckPDF
//
//  Created by eeesysmini2 on 2017/3/29.
//  Copyright © 2017年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView
{

    CGPDFDocumentRef pdf;
    int pageNum;

}
- (void)drawInContext:(CGContextRef)context;
- (instancetype)initWithFrame:(CGRect)frame DocumentRef:(CGPDFDocumentRef)adocumentRef Page:(int)aPage;
@end
