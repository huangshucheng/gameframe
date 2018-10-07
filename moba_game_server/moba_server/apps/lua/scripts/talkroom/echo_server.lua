function echo_recv_cmd(s, msg)
  print('\necho_recv_cmd-----------------start')
  print( 'stype: ' .. msg[1]) -- stype
  print('ctype: ' ..msg[2]) -- ctype
  print('utag: ' ..msg[3]) -- utag,

  local body = msg[4]
  if body then
    print("name: " .. tostring(body.name))
    print("email: " .. tostring(body.email))
    print("age: " .. tostring(body.age))
    print("int_set: " .. tostring(body.int_set))
  end
  -- send to client
  local to_client = {1, 2, 0, {status = 200}}
  Session.send_msg(s, to_client)
  print('echo_recv_cmd-----------------end\n')
end

function echo_session_disconnect(s)
  local ip, port = Session.get_address(s)
  print("echo_session_disconnect "..ip.." : "..port)
end


local echo_service = {
  on_session_recv_cmd = echo_recv_cmd,
  on_session_disconnect = echo_session_disconnect,
}

local echo_server = {
  stype = 1,
  service = echo_service,
}

return echo_server;
