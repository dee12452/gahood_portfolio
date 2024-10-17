import 'dart:convert';

class Connection {
  // final Host host;
  // final Peer peer;
  // EnetEvent? event;
  // bool _connected = true;
  // bool _messagesInQueue = false;
  //
  // Connection({
  //   required this.host,
  //   required this.peer,
  // }) {
  //   host.flush();
  // }
  //
  // bool get connected => _connected;
  //
  // void send(String message) {
  //   peer.send(0, Packet(utf8.encode(message), flags: PacketFlags.reliable));
  //   _messagesInQueue = true;
  // }
  //
  void update() {
    // if (!connected) return;
    //
    // if (_messagesInQueue) {
    //   _messagesInQueue = false;
    //   host.flush();
    // }
    //
    // event = host.service();
    // if (event is DisconnectEvent) {
    //   _onDisconnect();
    // }
  }
  //
  void disconnect() {
    // if (!connected) return;
    //
    // peer.disconnect();
    // host.flush();
    // _onDisconnect();
  }
  //
  // void _onDisconnect() {
  //   _connected = false;
  //   deinitializeEnet();
  // }
}
