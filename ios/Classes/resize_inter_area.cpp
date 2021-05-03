//
// Created by Yuki Konda on 5/2/21.
//

#include <stdint.h>
#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *resize_inter_area(uint8_t *src, uint8_t *dst, int32_t srcWidth, int32_t srcHeight, int32_t dstWidth, int32_t dstHeight) {

    cv::Mat original(srcWidth, srcHeight, CV_8UC3, src);
    cv::Mat resized(dstWidth, dstHeight, CV_8UC3);

    cv::resize(original, resized, cv::Size(dstWidth, dstHeight), 0, 0, CV_INTER_AREA);
    return resized.data;
}
