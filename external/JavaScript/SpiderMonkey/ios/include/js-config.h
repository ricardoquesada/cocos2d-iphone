/* -*- Mode: C; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sw=4 et tw=78:
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef js_config_h___
#define js_config_h___

/* Definitions set at build time that affect SpiderMonkey's public API.
   This header file is generated by the SpiderMonkey configure script,
   and installed along with jsapi.h.  */

/* Define to 1 if SpiderMonkey should support multi-threaded clients.  */
/* #undef JS_THREADSAFE */

/* Define to 1 if SpiderMonkey should include ctypes support.  */
/* #undef JS_HAS_CTYPES */

/* Define to 1 if SpiderMonkey should support the ability to perform
   entirely too much GC.  */
/* #undef JS_GC_ZEAL */

/* Define to 1 if the <endian.h> header is present and
   useable.  See jscpucfg.h.  */
#define JS_HAVE_ENDIAN_H 1

/* Define to 1 if the <machine/endian.h> header is present and
   useable.  See jscpucfg.h.  */
#define JS_HAVE_MACHINE_ENDIAN_H 1

/* Define to 1 if the <sys/isa_defs.h> header is present and
   useable.  See jscpucfg.h.  */
/* #undef JS_HAVE_SYS_ISA_DEFS_H */

/* The configure script defines these if it doesn't #define
   JS_HAVE_STDINT_H.  */
#define JS_BYTES_PER_WORD 8

/* MOZILLA JSAPI version number components */
#define MOZJS_MAJOR_VERSION 25
#define MOZJS_MINOR_VERSION 0

#endif /* js_config_h___ */
