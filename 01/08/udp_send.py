'''
  UDP送信テスト
'''
from socket import socket, AF_INET, SOCK_DGRAM, SOL_SOCKET, SO_BROADCAST
from contextlib import closing

ADDRESS = '255.255.255.255' 
PORT = 50000

with closing(socket(AF_INET, SOCK_DGRAM)) as sock:
  print("送信開始--------------")
  sock.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)

  while True:
    msg = input("> ")
    sock.sendto(msg.encode('utf-8'), (ADDRESS, PORT))
