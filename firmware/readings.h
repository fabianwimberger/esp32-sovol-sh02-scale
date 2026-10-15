#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>

namespace filament_scale {
class Readings {
 public:
  void add(float value, uint32_t now) {
    if (!std::isfinite(value) || std::abs(value) >= 8388607.0f) {
      count_ = 0;
      next_ = 0;
      return;
    }
    // A reconnected sensor must replace the entire pre-disconnection window.
    if (count_ && uint32_t(now - last_) >= 3000) {
      count_ = 0;
      next_ = 0;
    }
    values_[next_] = value;
    next_ = (next_ + 1) % values_.size();
    count_ = std::min(count_ + 1, values_.size());
    last_ = now;
  }

  bool ready(uint32_t now) const {
    return count_ == values_.size() && uint32_t(now - last_) < 3000;
  }

  float mean() const {
    if (count_ != values_.size()) return NAN;
    double sum = 0;
    for (float value : values_) sum += value;
    return float(sum / values_.size());
  }

  float range() const {
    if (count_ != values_.size()) return INFINITY;
    auto bounds = std::minmax_element(values_.begin(), values_.end());
    return *bounds.second - *bounds.first;
  }

  bool stable(uint32_t now, float counts_limit) const {
    return ready(now) && range() <= counts_limit;
  }

  float mass(uint32_t now, float zero, float counts_per_g) const {
    if (!ready(now) || !std::isfinite(counts_per_g) ||
        std::abs(counts_per_g) < 0.001f) return NAN;
    // Brief filament pulls must not bias the estimate or change calibration samples.
    auto sorted = values_;
    auto middle = sorted.begin() + sorted.size() / 2;
    std::nth_element(sorted.begin(), middle, sorted.end());
    return (*middle - zero) / counts_per_g;
  }

 private:
  std::array<float, 25> values_{};
  size_t count_{0};
  size_t next_{0};
  uint32_t last_{0};
};
inline Readings samples;
}  // namespace filament_scale
