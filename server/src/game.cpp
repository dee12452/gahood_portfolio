#include "game.hpp"

#include <chrono>
#include <iostream>

const int Game::ticksPerSecond = 20;
const std::chrono::milliseconds Game::tickRate =
    std::chrono::milliseconds(1000 / Game::ticksPerSecond);

std::chrono::time_point<std::chrono::high_resolution_clock> now() {
  return std::chrono::high_resolution_clock::now();
}

Game::Game()
    : running(true),
      ticks(0),
      msCount(std::chrono::milliseconds(0)),
      delay(now()) {}

Game::~Game() {}

void Game::run() {
  std::cout << "Starting game" << std::endl;
  while (running) {
    update();
  }
  std::cout << "Stopping game" << std::endl;
}

void Game::update() {
  auto nextDelay = now();
  auto msDelay =
      std::chrono::duration_cast<std::chrono::milliseconds>(nextDelay - delay);
  if (msDelay.count() > 0) {
    delay = nextDelay;
    msCount += msDelay;
  }
  while (msCount > Game::tickRate) {
    msCount -= Game::tickRate;
    tick();
  }
  server.update();
}

void Game::tick() {}
