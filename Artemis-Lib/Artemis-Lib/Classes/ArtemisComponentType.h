/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/ComponentType.java
 */
#import <Foundation/Foundation.h>

@interface ArtemisComponentType : NSObject

@property(nonatomic,readonly) int index;

+(int) getIndexFor:(Class) componentClass;
+(ArtemisComponentType*) getTypeFor:(Class) c;

@end
