#include <stdint.h>
#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* native_add(uint8_t *src, int32_t x, int32_t y, int32_t u, int32_t v) {
    cv::Mat m = cv::Mat::zeros(x, y, CV_8UC3);

    cv::Mat original(x, y, CV_8UC3, src);
    cv::Mat resized(u, v, CV_8UC3);
    cv::resize(original, resized, cv::Size(u, v), 0, 0, cv::INTER_AREA);

    uint8_t* data = original.data;
    return data;
}