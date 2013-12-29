/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/ComponentType.java
 */
#import <Foundation/Foundation.h>

@interface ArtemisComponentType : NSObject

@property(nonatomic,readonly) NSUInteger index;

+(NSUInteger) getIndexFor:(Class) componentClass;
+(ArtemisComponentType*) getTypeFor:(Class) c;

@end
