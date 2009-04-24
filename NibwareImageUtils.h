
typedef struct  {
    int longEdgeSize;
    float quality;
    int size;
} CImageQualityDataPoint;

@interface NibwareImageUtils : NSObject {
}

#define LONG_EDGE_OF_CGSIZE(size) (fmax(size.width, size.height))

+ (NSInteger) estimateBytesForImage:(UIImage *)image quality:(float)quality;
+ (NSInteger) estimateBytes:(CGSize)size quality:(float)quality;
+ (NSInteger) estimateUploadTime:(NSInteger)bytes;

@end