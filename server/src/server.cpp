#include "server.hpp"

#include <iostream>

#include "enet/enet.h"

Server::Server() {
  if (enet_initialize() != 0) {
    std::cerr << "An error occurred while initializing ENet." << std::endl;
    exit(EXIT_FAILURE);
  }

  /* Bind the server to the default localhost.     */
  /* A specific host address can be specified by   */
  /* enet_address_set_host (& address, "x.x.x.x"); */
  ENetAddress address;
  address.host = ENET_HOST_ANY;
  address.port = 1234;

  server = enet_host_create(
      &address /* the address to bind the server host to */,
      32 /* allow up to 32 clients and/or outgoing connections */,
      2 /* allow up to 2 channels to be used, 0 and 1 */,
      0 /* assume any amount of incoming bandwidth */,
      0 /* assume any amount of outgoing bandwidth */);
  if (server == NULL) {
    std::cerr << "An error occurred while trying to create an ENet server host."
              << std::endl;
    exit(EXIT_FAILURE);
  }

  std::cout << "Created server" << std::endl;
}

Server::~Server() {
  enet_host_destroy(server);
  enet_deinitialize();
}

void Server::update() {
  while (enet_host_service(server, &event, 10) > 0) {
    std::cout << "An event occurred" << std::endl;
    switch (event.type) {
      case ENET_EVENT_TYPE_CONNECT:
        std::cout << "A new client connected from " << event.peer->address.host
                  << ":" << event.peer->address.port << std::endl;
        break;

      case ENET_EVENT_TYPE_RECEIVE:
        std::cout << "Received a packet" << event.packet->data << std::endl;
        /* Clean up the packet now that we're done using it. */
        enet_packet_destroy(event.packet);
        break;

      case ENET_EVENT_TYPE_DISCONNECT:
        std::cout << "A client disconnected" << std::endl;
        /* Reset the peer's client information. */
        event.peer->data = NULL;
        break;

      default:
        break;
    }
  }
}
