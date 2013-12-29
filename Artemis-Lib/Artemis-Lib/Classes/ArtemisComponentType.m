#import "ArtemisComponentType.h"

@interface ArtemisComponentType()
@property(nonatomic) Class type;
@property(nonatomic,readwrite) NSUInteger index;
@end

@implementation ArtemisComponentType

static int INDEX;
static NSMutableDictionary* componentTypes;

- (id)initWithType:(Class) type
{
	if( componentTypes == nil )
	{
		INDEX = 0;
		componentTypes = [[NSMutableDictionary dictionary] retain];
	}
	
    self = [super init];
    if (self) {
        self.index = INDEX++;
		self.type = type;
    }
    return self;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"ComponentType[%@] (%lu)", self.type, (unsigned long)self.index];
}

+(ArtemisComponentType*) getTypeFor:(Class) c
{
	ArtemisComponentType* type = [componentTypes objectForKey:c];
	
	if (type == nil)
	{
		type = [[[ArtemisComponentType alloc] initWithType:c] autorelease];
		[componentTypes setObject:type forKey:(id<NSCopying>)c]; // ObjC: looks wrong but IS OFFICIALLY legal and correct (ask Apple!)
	}
	
	return type;
}

+(NSUInteger) getIndexFor:(Class) c
{
	return ((ArtemisComponentType*)[self getTypeFor:c]).index;
}

@end
