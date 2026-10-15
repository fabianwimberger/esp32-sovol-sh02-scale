#include "../firmware/readings.h"
#include <cassert>
#include <cmath>

int main() {
  filament_scale::Readings samples;
  assert(!samples.ready(0));
  assert(std::isnan(samples.mass(0, 0, 100)));
  for (uint32_t i = 0; i < 25; ++i) samples.add(110000, i * 200);
  assert(samples.ready(4800));
  assert(samples.stable(4800, 100));
  assert(samples.mass(4800, 10000, 100) == 1000);
  assert(samples.mass(4800, 210000, -100) == 1000);
  assert(std::isnan(samples.mass(7800, 10000, 100)));
  assert(std::isnan(samples.mass(4800, 10000, 0)));
  samples.add(NAN, 7900);
  assert(!samples.ready(7900));
  samples.add(120000, 8000);
  assert(!samples.ready(8000));
  assert(!samples.stable(8000, 100));
  for (uint32_t i = 0; i < 25; ++i) samples.add(120000, 8200 + i * 200);
  assert(samples.stable(13000, 100));
  assert(samples.mass(13000, 10000, 100) == 1100);
  samples.add(8388607, 13200);
  assert(!samples.ready(13200));
  for (uint32_t i = 0; i < 25; ++i) samples.add(110000, 13400 + i * 200);
  assert(samples.ready(18200));
  samples.add(-8388608, 18400);
  assert(!samples.ready(18400));
  filament_scale::Readings wrapped;
  for (int i = 0; i < 25; ++i) wrapped.add(1, UINT32_MAX - 500);
  assert(wrapped.ready(500));
  assert(!wrapped.ready(3000));

  for (float gain : {100.0f, -100.0f}) {
    for (float disturbance : {-1000.0f, 1000.0f}) {
      filament_scale::Readings filtered;
      float baseline = 10000 + 3000 * gain;
      float disturbed = baseline + disturbance * gain;
      for (uint32_t i = 0; i < 25; ++i) filtered.add(baseline, i * 200);
      for (uint32_t i = 0; i < 12; ++i) {
        uint32_t now = 5000 + i * 200;
        filtered.add(disturbed, now);
        assert(filtered.mass(now, 10000, gain) == 3000);
        assert(!filtered.stable(now, 5 * std::abs(gain)));
        assert(filtered.mean() != baseline);
        assert(filtered.range() == std::abs(disturbance * gain));
      }
      filtered.add(disturbed, 7400);
      assert(filtered.mass(7400, 10000, gain) == 3000 + disturbance);
      for (uint32_t i = 0; i < 13; ++i) filtered.add(baseline, 7600 + i * 200);
      assert(filtered.mass(10000, 10000, gain) == 3000);
      assert(std::isnan(filtered.mass(13000, 10000, gain)));
      filtered.add(baseline, 13000);
      assert(!filtered.ready(13000));
      assert(std::isnan(filtered.mass(13000, 10000, gain)));
      for (uint32_t i = 1; i < 25; ++i) filtered.add(baseline, 13000 + i * 200);
      assert(filtered.mass(17800, 10000, gain) == 3000);
    }
  }

  filament_scale::Readings trend;
  for (uint32_t i = 0; i < 25; ++i) trend.add(310000 - float(i) * 100, i * 200);
  assert(trend.mass(4800, 10000, 100) == 2988);
  assert(trend.mean() == 308800);
  assert(std::isnan(trend.mass(4800, 10000, NAN)));
  assert(std::isnan(trend.mass(4800, 10000, INFINITY)));
}
