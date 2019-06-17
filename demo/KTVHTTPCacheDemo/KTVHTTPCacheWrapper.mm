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

static BOOL isRunning=false;

+ (NSString *) getProxyUrl:(NSString *)originalUrl
{
    if (isRunning == false)
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
#ifdef __cplusplus
}
#endif
