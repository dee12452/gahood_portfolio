#ifndef GAHOOD_GAME
#define GAHOOD_GAME

#include <chrono>
#include <cstdint>

#include "server.hpp"

class Game {
 public:
  static const int ticksPerSecond;
  static const std::chrono::milliseconds tickRate;

  Game();
  ~Game();

  void run();

 private:
  bool running;
  uint64_t ticks;
  Server server;
  std::chrono::time_point<std::chrono::high_resolution_clock> delay;
  std::chrono::milliseconds msCount;

  void update();
  void tick();
};

#endif  // !GAHOOD_GAME
