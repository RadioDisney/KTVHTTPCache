//
//  KTVHTTPCacheWrapper.h
//  KTVHTTPCacheDemo
//
//  Created by 胡珣珣 on 2019/6/6.
//  Copyright © 2019 Single. All rights reserved.
//

#ifndef KTVHTTPCacheWrapper_h
#define KTVHTTPCacheWrapper_h

#import <Foundation/Foundation.h>

@interface KTVHTTPCacheWrapper : NSObject
@end

#ifdef __cplusplus
extern "C"
{
#endif
    const char* GetProxyUrl (const char* inUrl);
#ifdef __cplusplus
}
#endif

#endif /* KTVHTTPCacheWrapper_h */
