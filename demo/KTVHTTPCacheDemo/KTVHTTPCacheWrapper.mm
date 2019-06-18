//
//  KTVHTTPCacheWrapper.m
//  KTVHTTPCacheDemo
//
//  Created by 胡珣珣 on 2019/6/6.
//  Copyright © 2019 Single. All rights reserved.
//
#import "KTVHTTPCache.h"
#import "KTVHTTPCacheWrapper.h"

@implementation KTVHTTPCacheWrapper

+ (void)setupHTTPCache
{
    [KTVHTTPCache logSetConsoleLogEnable:YES];
    NSError *error = nil;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
}

+ (NSString *) getProxyUrl:(NSString *)originalUrl
{
    if (![KTVHTTPCache proxyIsRunning])
    {
        [self setupHTTPCache];
    }
    
    NSString *URLString = [originalUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:URLString]];
    return URL.absoluteString;
}

@end

#ifdef __cplusplus
extern "C"
{
#endif
    const char* stringCopy (const char* input)
    {
        if (input == NULL)
        {
            return NULL;
        }
        
        char* output = (char*)malloc(strlen(input) + 1);
        
        strcpy (output, input);
        
        return output;
    }
    
    const char* GetProxyUrl (const char* inUrl)
    {
        NSString* inUrlNS = [NSString stringWithCString:inUrl encoding:NSASCIIStringEncoding];
        NSString* outUrlNS = [KTVHTTPCacheWrapper getProxyUrl:inUrlNS];
        const char* outUrl = [outUrlNS cStringUsingEncoding:NSASCIIStringEncoding];
        return stringCopy(outUrl);
    }
    
    int GetPercent (const char* originalUrl)
    {
        NSString* originalUrlNS = [NSString stringWithCString:originalUrl encoding:NSASCIIStringEncoding];
        NSLog(@"originalUrl : %@", originalUrlNS);
//        NSArray<KTVHCDataCacheItem *> * cacheItems = [KTVHTTPCache cacheAllCacheItems];
//
//        for (KTVHCDataCacheItem* cacheItem in cacheItems) {
//            NSLog(@"t:%lld, c:%lld, v:%lld === %@\n", cacheItem.totalLength,  cacheItem.cacheLength, cacheItem.vaildLength, cacheItem.URL);
//        }
        
        KTVHCDataCacheItem* cacheItem = [KTVHTTPCache cacheCacheItemWithURLString:originalUrlNS];
        if (cacheItem != NULL)
        {
            NSLog(@"totalLength:%lld, cacheLength:%lld, vaildLength:%lld", cacheItem.totalLength,  cacheItem.cacheLength, cacheItem.vaildLength);
            return (int)(cacheItem.cacheLength * 100 / cacheItem.totalLength);
        }
        else
        {
            return 0;
        }
    }
    
    const char* GetCacheCompleteFileUrlWithUrl (const char* inUrlCString)
    {
        NSString* inUrlNSString = [NSString stringWithCString:inUrlCString encoding:NSASCIIStringEncoding];
        NSURL* inUrl = [NSURL URLWithString:inUrlNSString];
        NSURL* outUrl = [KTVHTTPCache cacheCompleteFileURLWithURL:inUrl];
        NSString* outUrlNSString = outUrl.absoluteString;
        const char* outUrlCString = [outUrlNSString cStringUsingEncoding:NSASCIIStringEncoding];
        return stringCopy(outUrlCString);
    }
#ifdef __cplusplus
}
#endif
