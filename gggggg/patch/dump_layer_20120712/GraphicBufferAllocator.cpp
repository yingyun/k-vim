/* 
**
** Copyright 2009, The Android Open Source Project
**
** Licensed under the Apache License, Version 2.0 (the "License"); 
** you may not use this file except in compliance with the License. 
** You may obtain a copy of the License at 
**
**     http://www.apache.org/licenses/LICENSE-2.0 
**
** Unless required by applicable law or agreed to in writing, software 
** distributed under the License is distributed on an "AS IS" BASIS, 
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
** See the License for the specific language governing permissions and 
** limitations under the License.
*/

#define LOG_TAG "GraphicBufferAllocator"

#include <cutils/log.h>
#include <cutils/properties.h>
#include <utils/Singleton.h>
#include <utils/String8.h>
#include<sys/stat.h>
#include<sys/types.h>

#include <ui/GraphicBufferAllocator.h>

namespace android {
// ---------------------------------------------------------------------------

ANDROID_SINGLETON_STATIC_INSTANCE( GraphicBufferAllocator )

Mutex GraphicBufferAllocator::sLock;
KeyedVector<buffer_handle_t,
    GraphicBufferAllocator::alloc_rec_t> GraphicBufferAllocator::sAllocList;

GraphicBufferAllocator::GraphicBufferAllocator()
    : mAllocDev(0)
{
    hw_module_t const* module;
    int err = hw_get_module(GRALLOC_HARDWARE_MODULE_ID, &module);
    LOGE_IF(err, "FATAL: can't find the %s module", GRALLOC_HARDWARE_MODULE_ID);
    if (err == 0) {
        gralloc_open(module, &mAllocDev);
    }
}

GraphicBufferAllocator::~GraphicBufferAllocator()
{
    gralloc_close(mAllocDev);
}

void GraphicBufferAllocator::dump(String8& result) const
{
    Mutex::Autolock _l(sLock);
    KeyedVector<buffer_handle_t, alloc_rec_t>& list(sAllocList);
    size_t total = 0;
    const size_t SIZE = 4096;
    char buffer[SIZE];
    snprintf(buffer, SIZE, "Allocated buffers:\n");
    result.append(buffer);
    const size_t c = list.size();
    char dumpDir[PROPERTY_VALUE_MAX];
    char dumpDirPath[32];
    property_get("debug.layer.dir.dump", dumpDir, "Nooooo");
    snprintf(dumpDirPath, 32, "data/%s/", dumpDir);
    if(mkdir(dumpDirPath, S_IRWXU | S_IRWXO | S_IRWXG)){
        LOGE("Create dump layer dir error, is it exist the same dir?");
    }
      
    for (size_t i = 0; i < c; i++) {
        const alloc_rec_t& rec(list.valueAt(i));
        if (rec.size) {
            snprintf(buffer, SIZE, "%2d: %10p: %7.2f KiB | %4u (%4u) x %4u | %8X | 0x%08x\n", i,
                    list.keyAt(i), rec.size / 1024.0f, rec.w, rec.s, rec.h, rec.format, rec.usage);
        } else {
            snprintf(buffer, SIZE, "%2d: %10p: unknown     | %4u (%4u) x %4u | %8X | 0x%08x\n", i,
                    list.keyAt(i), rec.w, rec.s, rec.h, rec.format, rec.usage);
        }
        result.append(buffer);
        total += rec.size;
        if (rec.format > 4 && rec.format != 17)
            continue;
        char fName[34];
        snprintf(fName, 34, "/data/%s/buffer%9p.png",dumpDir, list.keyAt(i));
        dumpPixel(fName, list.keyAt(i), list.valueAt(i));
    }
    snprintf(buffer, SIZE, "Total allocated (estimate): %.2f KB\n", total/1024.0f);
    result.append(buffer);
    if (mAllocDev->common.version >= 1 && mAllocDev->dump) {
        mAllocDev->dump(mAllocDev, buffer, SIZE);
        result.append(buffer);
    }
}

void GraphicBufferAllocator::dumpPixel(char *out, buffer_handle_t pixel, alloc_rec_t rec) const
{
    char value[PROPERTY_VALUE_MAX];
    if (property_get("debug.layer.dump", value, NULL)) {
        if (atoi(value) == 0)
            return;
    }
    // obtain the private gralloc handle
    if (pixel) {
        private_handle_t *priv_handle = (private_handle_t *) pixel;

        // validate the handle
        if (private_handle_t::validate((native_handle *) priv_handle) == 0) {

            // check so that its contents seems ok
            if (priv_handle->size > 0 && priv_handle->base) {
                // dump buffer to file:
                FILE *fd = fopen(out, "w");
                if (fd) {
                    //fwrite((void*) priv_handle->base, 1, priv_handle->size, fd);
                    writeToPNG(fd, priv_handle, rec);
                    fclose(fd);
                } else {
                    LOGE("Error: opening file %s : %s", out, strerror(errno));
                }
            } else {
                LOGD("handle size %d, base %d", priv_handle->size, priv_handle->base);
            }
        }
    }
}

void GraphicBufferAllocator::writeToPNG(FILE *out, private_handle_t *handle, alloc_rec_t rec) const
{
    png_structp png;
    png_infop info;
    unsigned int colorTypePng = 0, rowSize = 0, needConvert = 0;

    png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (png == NULL) {
        LOGE("failed png_create_write_struct\n");
        return;
    }

    png_init_io(png, out);
    info = png_create_info_struct(png);
    if (info == NULL) {
        LOGE("failed png_create_info_struct\n");
        png_destroy_write_struct(&png, NULL);
        return;
    }

    if (setjmp(png_jmpbuf(png))) {
        LOGE("failed png setjmp\n");
        png_destroy_write_struct(&png, NULL);
        return;
    }

    switch (rec.format) {
    case 1:
    case 2:
        colorTypePng = PNG_COLOR_TYPE_RGB_ALPHA;
        rowSize = rec.s * 4;
        break;
    case 3:
        colorTypePng = PNG_COLOR_TYPE_RGB;
        rowSize = rec.s * 3;
        break;
    case 4:
        colorTypePng = PNG_COLOR_TYPE_RGB;
        rowSize = rec.s * 3;
        needConvert = 1;
        break;
    case 17:
        colorTypePng = PNG_COLOR_TYPE_RGB;
        rowSize = rec.s * 3;
        needConvert = 1;
        break;
    }

    png_set_IHDR(png, info, rec.w, rec.h, 8, colorTypePng, PNG_INTERLACE_NONE,
            PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);
    png_write_info(png, info);

    png_bytep pixelBase = (png_bytep) handle->base;

    if (needConvert) {
        uint8_t *dstPixel = new uint8_t[rowSize];
        uint16_t *srcPixel16 = 0;

        for (size_t i = 0; i < rec.h; i++) {
            switch (rec.format) {
            case 4:
                srcPixel16 = (uint16_t *) (pixelBase + i * rec.s * 2);
                convert565toRGB(dstPixel, srcPixel16, rec.w);
                break;
            case 17:
                convertNV21toRGB(dstPixel, pixelBase, rec.s, rec.w, rec.h, i);
                break;
            }

            png_write_row(png, dstPixel);
        }
        delete (dstPixel);
    } else {
        for (size_t i = 0; i < rec.h; i++) {
            png_write_row(png, pixelBase + i * rowSize);
        }
    }

    png_write_end(png, info);
    png_destroy_write_struct(&png, NULL);
}

void GraphicBufferAllocator::convert565toRGB(uint8_t *dst, uint16_t *src, uint32_t w) const
{
    for (size_t i = 0; i < w; i++) {
        dst[3 * i] = (src[i] >> 11) * 255 / 31;
        dst[3 * i + 1] = ((src[i] >> 5) & 0x3f) * 255 / 63;
        dst[3 * i + 2] = (src[i] & 0x1F) * 255 / 31;
    }
}

void GraphicBufferAllocator::convertNV21toRGB(uint8_t *dst, uint8_t *pixelBase,
        uint32_t s, int32_t w, uint32_t h, size_t hightIndex) const
{
    long Y = 0, Cr = 0, Cb = 0;
    for (size_t j = 0; j < w; j++) {
        Y = pixelBase[s * hightIndex + j];
        Cr = pixelBase[hightIndex / 2 * s + j + s * h];
        Cb = pixelBase[(hightIndex / 2) * s + j + 1 + s * h];

        dst[3 * j] = Y + 1.402 * (Cr - 128);
        dst[3 * j + 1] = Y - 0.34414 * (Cb - 128) - 0.71414 * (Cr - 128);
        dst[3 * j + 2] = Y + 1.772 * (Cb - 128);
    }
}

void GraphicBufferAllocator::dumpToSystemLog()
{
    String8 s;
    GraphicBufferAllocator::getInstance().dump(s);
    LOGD("%s", s.string());
}

status_t GraphicBufferAllocator::alloc(uint32_t w, uint32_t h, PixelFormat format,
        int usage, buffer_handle_t* handle, int32_t* stride)
{
    // make sure to not allocate a N x 0 or 0 x N buffer, since this is
    // allowed from an API stand-point allocate a 1x1 buffer instead.
    if (!w || !h)
        w = h = 1;

    // we have a h/w allocator and h/w buffer is requested
    status_t err; 
    
    err = mAllocDev->alloc(mAllocDev, w, h, format, usage, handle, stride);

    LOGW_IF(err, "alloc(%u, %u, %d, %08x, ...) failed %d (%s)",
            w, h, format, usage, err, strerror(-err));
    
    if (err == NO_ERROR) {
        Mutex::Autolock _l(sLock);
        KeyedVector<buffer_handle_t, alloc_rec_t>& list(sAllocList);
        int bpp = bytesPerPixel(format);
        if (bpp < 0) {
            // probably a HAL custom format. in any case, we don't know
            // what its pixel size is.
            bpp = 0;
        }
        alloc_rec_t rec;
        rec.w = w;
        rec.h = h;
        rec.s = *stride;
        rec.format = format;
        rec.usage = usage;
        rec.size = h * stride[0] * bpp;
        list.add(*handle, rec);
    }

    return err;
}

status_t GraphicBufferAllocator::free(buffer_handle_t handle)
{
    status_t err;

    err = mAllocDev->free(mAllocDev, handle);

    LOGW_IF(err, "free(...) failed %d (%s)", err, strerror(-err));
    if (err == NO_ERROR) {
        Mutex::Autolock _l(sLock);
        KeyedVector<buffer_handle_t, alloc_rec_t>& list(sAllocList);
        list.removeItem(handle);
    }

    return err;
}

// ---------------------------------------------------------------------------
}; // namespace android
