'''
  UDP受信テスト
'''
from socket import socket, AF_INET, SOCK_DGRAM
from contextlib import closing

ADDRESS = '' 
PORT = 50000

with closing(socket(AF_INET, SOCK_DGRAM)) as sock:
  print("受信開始--------------")
  sock.bind((ADDRESS, PORT))

  while True:
    msg, address = sock.recvfrom(4096)  #4096はバッファサイズ。大きさはテキトーで深い意味はない
    print(f"[{address}] : {(msg).decode('utf-8')}" )
