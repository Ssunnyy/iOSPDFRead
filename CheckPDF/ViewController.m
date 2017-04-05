//
//  ViewController.m
//  CheckPDF
//
//  Created by eeesysmini2 on 2017/3/29.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "ViewController.h"
#import "PDFView.h"
#import "PDFCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIWebViewDelegate>
{
    CGPDFDocumentRef pdfDocument;
    int totalPage;
    NSMutableArray *dataArr;
    UICollectionView *pdfCollectionView;
    UILabel *lll;
    CGFloat MAXScale;
    CGFloat CurrentSclae;
    CGFloat MinSclae;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //根据url获取pdf一共有多少页
    MAXScale = 2.0;//设置最大放大倍数
    MinSclae = 1.0;
    NSURL *url = [NSURL URLWithString:@""];
     CFURLRef refURL = (__bridge CFURLRef)(url);
    pdfDocument = CGPDFDocumentCreateWithURL(refURL);
     size_t totalPages =CGPDFDocumentGetNumberOfPages(pdfDocument);
    totalPage = (int)totalPages;
    NSLog(@"%d",totalPage);
    
    NSMutableArray *pdfViewArr = [NSMutableArray array];
    
    for (int i = 0; i<totalPage; i++) {
        PDFView *view = [[PDFView alloc]initWithFrame:self.view.frame DocumentRef:pdfDocument Page:i+1];
        
        view.tag = i;
        //view.backgroundColor = [UIColor greenColor];
        [pdfViewArr addObject:view];
    }
    dataArr = pdfViewArr;
    
    NSLog(@"%lu %@",(unsigned long)dataArr.count,dataArr);
    
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = self.view.frame.size;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    pdfCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    pdfCollectionView.backgroundColor = [UIColor clearColor];
    pdfCollectionView.pagingEnabled = YES;
    pdfCollectionView.delegate = self;
    pdfCollectionView.dataSource = self;
    for (NSInteger i = 0; i < dataArr.count ; i++) {
        
        NSString * stringID = [NSString stringWithFormat:@"PDFCollectionViewCell%ld",i];
        
        [pdfCollectionView registerClass:[PDFCollectionViewCell class] forCellWithReuseIdentifier:stringID];
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSString * stringID = [NSString stringWithFormat:@"PDFCollectionViewCell%ld",indexPath.row];
    
    //使用不同的重用标示创建cell,避免放大缩小时内容重复
    PDFCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = YES;
    //PDFCollectionViewCell *cell = [collectionView     //cell.cellDelegate = self;
    cell.cellView.delegate = self;
    cell.cellView.tag = indexPath.row;
   // cell.cellView.decelerationRate = 1.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 2;
    [cell.cellView addGestureRecognizer:tap];
    cell.cellView.userInteractionEnabled = YES;
    [cell.cellView addSubview:dataArr[indexPath.row]];
       return cell;
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[PDFView class]]) {
            return view;
        }
    }
    return nil;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[PDFCollectionViewCell class]]) {
            PDFCollectionViewCell *cell = (PDFCollectionViewCell *)view;
            [cell.cellView setZoomScale:1];
           
        }
    }

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    CurrentSclae = scale;
}
//根据当前的缩放倍数,决定是放大还是缩小
- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIScrollView *view = (UIScrollView *)tap.view;
    if (CurrentSclae == MAXScale) {
        CurrentSclae = MinSclae;
        [view setZoomScale:CurrentSclae animated:YES];
        return;
    }
    
    if (CurrentSclae== MinSclae) {
        CurrentSclae = MAXScale;
        [view setZoomScale:CurrentSclae animated:YES];
        return;
    }
    
    CGFloat aveScale = MinSclae+(MAXScale-MinSclae)/2.0;
    
    if (CurrentSclae>= aveScale) {
        CurrentSclae = MAXScale;
        [view setZoomScale:CurrentSclae animated:YES];
        return;
    }
    
    if (CurrentSclae<aveScale) {
        CurrentSclae = MinSclae ;
        [view setZoomScale:CurrentSclae animated:YES];
        return;
    }
    

}

@end
