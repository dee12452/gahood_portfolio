#ifndef GAHOOD_SERVER
#define GAHOOD_SERVER

#include "enet/enet.h"

class Server {
 public:
  Server();
  ~Server();

  void update();

 private:
  ENetHost *server;
  ENetEvent event;
};

#endif  // !GAHOOD_SERVER
