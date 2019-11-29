#include <chrono>

class Timer
{
public:

  using Clock = std::chrono::steady_clock;
  using dseconds = std::chrono::duration<double, std::ratio<1,1>>;
  using dmilliseconds = std::chrono::duration<double, std::ratio<1,1000>>;
  using dmicroseconds = std::chrono::duration<double, std::ratio<1,1000000>>;

  void reset() { _start = Clock::now(); }

  double seconds()
  {
    return std::chrono::duration_cast<dseconds>(get()).count();
  }
  double milliseconds()
  {
    return std::chrono::duration_cast<dmilliseconds>(get()).count();
  }
  double microseconds()
  {
    return std::chrono::duration_cast<dmicroseconds>(get()).count();
  }

private:

  dmilliseconds get() { return Clock::now() - _start; }
  Clock::time_point _start;
};
