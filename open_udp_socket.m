% Open UDP SOCKET (ports)
port_out = 5067;
% only the first time to open the socket
sock = pnet('udpsocket',port_out);
pnet(sock,'udpconnect','10.0.0.111',port_out);

%% to send the name:
% eyetr_sendtrigger('name',sock);
% eyetr_sendtrigger(subj_ID{1,1},sock);