local cmd_opcode_map = {}

cmd_opcode_map.LoginReq 			= 1;
cmd_opcode_map.LoginRes				= 2;
cmd_opcode_map.ExitReq				= 3;
cmd_opcode_map.ExitRes				= 4;
cmd_opcode_map.SendMsgReq			= 5;
cmd_opcode_map.SendMsgRes			= 6;
cmd_opcode_map.OnUserLogin			= 7;
cmd_opcode_map.OnUserExit			= 8;
cmd_opcode_map.OnSendMsg			= 9;

return cmd_opcode_map;