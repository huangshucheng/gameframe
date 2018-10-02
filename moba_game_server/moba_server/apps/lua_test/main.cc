#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <iostream>
#include <string>
using namespace std;


#include "../../netbus/proto_man.h"
#include "../../netbus/netbus.h"
#include "../../utils/logger.h"
#include "../../utils/time_list.h"
#include "../../utils/timestamp.h"
#include "../../database/mysql_wrapper.h"
#include "../../database/redis_wrapper.h"
#include "../../lua_wrapper/lua_wrapper.h"

//#include "pf_cmd_map.h"

int main(int argc, char** argv) {
	netbus::instance()->init();
	lua_wrapper::init();
	//netbus::instance()->tcp_connect("127.0.0.1", 7788, NULL, NULL);	//test
	if (argc != 3) { // ²âÊÔ
		std::string search_path = "../../apps/lua_test/scripts/";
		lua_wrapper::add_search_path(search_path);
		std::string lua_file = search_path + "main.lua";
		lua_wrapper::do_file(lua_file);
		// end 
	}
	else {
		std::string search_path = argv[1];
		if (*(search_path.end() - 1) != '/') {
			search_path += "/";
		}
		lua_wrapper::add_search_path(search_path);

		std::string lua_file = search_path + argv[2];
		lua_wrapper::do_file(lua_file);
	}
	netbus::instance()->run();
	lua_wrapper::exit();
	/*
	proto_man::init(PROTO_BUF);
	init_pf_cmd_map();
	netbus::instance()->init();
	netbus::instance()->tcp_listen(6080);
	netbus::instance()->run();
	*/
	system("pause");
	return 0;
}