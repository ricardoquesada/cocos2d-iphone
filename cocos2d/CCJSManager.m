/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "jsapi.h"

#import "CCJSManager.h"
#import "Support/CCFileUtils.h"

JSBool callback_log(JSContext *cx, unsigned argc, jsval *vp);
void callback_ErrorReporter(JSContext *cx, const char *message, JSErrorReport *report);

static JSClass global_class = {
	"global", JSCLASS_GLOBAL_FLAGS,
	JS_PropertyStub, JS_PropertyStub, JS_PropertyStub, JS_StrictPropertyStub,
	JS_EnumerateStub, JS_ResolveStub, JS_ConvertStub, JS_FinalizeStub,
	JSCLASS_NO_OPTIONAL_MEMBERS
};

JSBool callback_log(JSContext *cx, unsigned argc, jsval *vp)
{
	if (argc > 0) {
		JSString *string = NULL;
		JS_ConvertArguments(cx, argc, JS_ARGV(cx, vp), "S", &string);
		if (string) {
			char *cstr = JS_EncodeString(cx, string);
			printf("%s\n", cstr);
		}
	}
	return JS_TRUE;
}

void callback_ErrorReporter(JSContext *cx, const char *message, JSErrorReport *report)
{
	fprintf(stderr, "%s:%u:%s\n",  
			report->filename ? report->filename : "<no filename=\"filename\">",  
			(unsigned int) report->lineno,  
			message);
}


@implementation CCJSManager

@synthesize runtime = runtime_;
@synthesize context = context_;

+(CCJSManager*) sharedManager
{
	static dispatch_once_t pred;
	static CCJSManager *sharedManager = nil;
	dispatch_once(&pred, ^{
		sharedManager = [[self alloc] init];
	});
	return sharedManager;
}

+(void) logWithJSContext:(JSContext*)cx argc:(uint32_t)argc values:(jsval*)vp
{
	
}

+(void) addRootJSWithContext:(JSContext*)cx argc:(uint32_t)argc value:(jsval*)vp
{
	
}

+(void) removeRootJSWithContext:(JSContext*)cx argc:(uint32_t)argc value:(jsval*)vp
{
	
}

+(void) forceGCWithContext:(JSContext*)cx argc:(uint32_t)argc value:(jsval*)vp
{
	
}

-(void) registerClass:(const char*)name withObject:(JSObject*) globalObj
{
	JSClass *jsClass = (JSClass *)calloc(1, sizeof(JSClass));
	jsClass->name = name;
	jsClass->addProperty = JS_PropertyStub;
	jsClass->delProperty = JS_PropertyStub;
	jsClass->getProperty = JS_PropertyStub;
	jsClass->setProperty = JS_StrictPropertyStub;
	jsClass->enumerate = JS_EnumerateStub;
	jsClass->resolve = JS_ResolveStub;
	jsClass->convert = JS_ConvertStub;
//	jsClass->finalize = jsFinalize;
	jsClass->flags = JSCLASS_HAS_PRIVATE;
//	static JSPropertySpec properties[] = {
//		{"animation", kAnimation, JSPROP_PERMANENT | JSPROP_SHARED, S_CCAnimate::jsPropertyGet, S_CCAnimate::jsPropertySet},
//		{"origFrame", kOrigFrame, JSPROP_PERMANENT | JSPROP_SHARED, S_CCAnimate::jsPropertyGet, S_CCAnimate::jsPropertySet},
//		{"restoreOriginalFrame", kRestoreOriginalFrame, JSPROP_PERMANENT | JSPROP_SHARED, S_CCAnimate::jsPropertyGet, S_CCAnimate::jsPropertySet},
//		{0, 0, 0, 0, 0}
//	};
	
//	static JSFunctionSpec funcs[] = {
//		JS_FN("initWithAnimation", S_CCAnimate::jsinitWithAnimation, 1, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FN("initWithDuration", S_CCAnimate::jsinitWithDuration, 3, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FN("startWithTarget", S_CCAnimate::jsstartWithTarget, 1, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FN("stop", S_CCAnimate::jsstop, 0, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FN("reverse", S_CCAnimate::jsreverse, 0, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FS_END
//	};
	
//	static JSFunctionSpec st_funcs[] = {
//		JS_FN("actionWithAnimation", S_CCAnimate::jsactionWithAnimation, 1, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FN("actionWithDuration", S_CCAnimate::jsactionWithDuration, 3, JSPROP_PERMANENT | JSPROP_SHARED),
//		JS_FS_END
//	};
	
	JSObject *jsObject = JS_InitClass(context_,globalObj,NULL,jsClass,NULL,0,NULL,NULL,NULL,NULL);
	
	(void)jsObject;
}

-(id) init
{
	if( (self=[super init]) ) {
		runtime_ = JS_NewRuntime(8 * 1024 * 1024);
		context_ = JS_NewContext(runtime_, 8192);
		JS_SetOptions(context_, JSOPTION_VAROBJFIX);
		JS_SetVersion(context_, JSVERSION_LATEST);
		JS_SetErrorReporter(context_, callback_ErrorReporter);
		globalObject_ = JS_NewCompartmentAndGlobalObject(context_, &global_class, NULL);

		if (!JS_InitStandardClasses(context_, globalObject_)) {
			NSLog(@"js error");
		}
		// create the cocos namespace
		JSObject *cocos = JS_NewObject(context_, NULL, NULL, NULL);
		jsval cocosVal = OBJECT_TO_JSVAL(cocos);
		JS_SetProperty(context_, globalObject_, "cocos", &cocosVal);
		
		[self registerClass:"Sprite" withObject:cocos];

//		IMP callback_log = [self methodForSelector:@selector(reportErrorMessage:withJSErrorReport:)];
		// register the internal classes		
		// register some global functions
		JS_DefineFunction(context_, cocos, "log", callback_log, 0, JSPROP_READONLY | JSPROP_PERMANENT);

//		JS_DefineFunction(context_, cocos, "addGCRootObject", callback_addRootJS, 0, JSPROP_READONLY | JSPROP_PERMANENT);
//		JS_DefineFunction(context_, cocos, "removeGCRootObject", callback_removeRootJS, 0, JSPROP_READONLY | JSPROP_PERMANENT);
//		JS_DefineFunction(context_, cocos, "forceGC", callback_forceGC, 0, JSPROP_READONLY | JSPROP_PERMANENT);
	}
	return  self;
}

+(void) reportErrorMessage:(NSString*)message withJSErrorReport:(JSErrorReport*)report
{
	
}

-(void) evalString:(NSString*)string
{
	jsval rval;
	JSString *str;
	JSBool ok;
	const char *filename = "noname";
	uint32_t lineno = 0;
	ok = JS_EvaluateScript(context_, globalObject_, [string UTF8String], [string length], filename, lineno, &rval);
	if ( ! ok ) {
		NSLog(@"error evaluating script:\n%@", string);
		return;
	}
	str = JS_ValueToString(context_, rval);
	printf("js result: %s\n", JS_EncodeString(context_, str));
}

-(void) runScript:(NSString*)path
{
	CCFileUtils *fileUtils = [CCFileUtils sharedFileUtils];
	
	NSString *realPath = [fileUtils fullPathFromRelativePath:path];
	unsigned char *content = NULL;
	size_t contentSize = ccLoadFileIntoMemory([realPath UTF8String], &content);
	if (content && contentSize) {
		JSBool ok;
		jsval rval;
		ok = JS_EvaluateScript(context_, globalObject_, (char *)content, contentSize, [path UTF8String], 1, &rval);
		if (JSVAL_IS_NULL(rval) ) { //|| rval == JSVAL_FALSE) {
			NSLog(@"error evaluating script:\n%s", content);
		}
		free(content);
	}
}

-(void) dealloc
{
	JS_DestroyContext(context_);
	JS_DestroyRuntime(runtime_);
	JS_ShutDown();
	
	[super dealloc];
}
@end

